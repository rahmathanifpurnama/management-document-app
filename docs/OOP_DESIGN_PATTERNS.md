# Object-Oriented Design Patterns in SimDoc

## Overview

The SimDoc application extensively uses object-oriented programming principles and design patterns to create maintainable, scalable, and testable code. This document details the implementation of the four fundamental OOP principles: Abstraction, Encapsulation, Polymorphism, and Inheritance.

## 1. Abstraction

Abstraction hides complex implementation details while exposing only the necessary interface to the user. In SimDoc, abstraction is implemented through abstract base classes and interfaces.

### Base Notifier Abstraction (Riverpod)

```dart
/// Abstract base class for all StateNotifiers
/// Provides common functionality and error handling patterns
abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.initialState);

  /// Safe state update with error handling
  /// Prevents state updates on disposed notifiers
  void safeUpdate(T Function() updater) {
    if (mounted) {
      try {
        state = updater();
      } catch (e) {
        debugPrint('$runtimeType Error updating state: $e');
        handleError(e);
      }
    }
  }

  /// Abstract error handling method
  /// Subclasses must implement their specific error handling logic
  void handleError(Object error);

  /// Abstract reset method
  /// Subclasses define how to reset to initial state
  void reset();

  @override
  void dispose() {
    debugPrint('$runtimeType disposed');
    super.dispose();
  }
}

/// Concrete implementation for file selection
class FileSelectionNotifier extends BaseNotifier<FileSelectionState> {
  FileSelectionNotifier() : super(const FileSelectionState());

  @override
  void handleError(Object error) {
    // Specific error handling for file selection
    safeUpdate(() => state.copyWith(
      errorMessage: 'File selection error: ${error.toString()}',
      isLoading: false,
    ));
  }

  @override
  void reset() {
    safeUpdate(() => const FileSelectionState());
  }

  void selectFile(DocumentModel document) {
    safeUpdate(() => state.copyWith(
      selectedFiles: [...state.selectedFiles, document],
    ));
  }
}
```

### Base BLoC Abstraction

```dart
/// Abstract base class for all BLoCs
/// Provides common functionality and lifecycle management
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  
  BaseBloc(super.initialState) {
    // Common event handlers can be registered here
    on<RefreshEvent>((event, emit) => onRefresh(emit));
  }

  /// Abstract refresh method
  /// Each BLoC implements its specific refresh logic
  Future<void> onRefresh(Emitter<State> emit);

  /// Common error handling
  void handleBlocError(Object error, StackTrace stackTrace, Emitter<State> emit) {
    debugPrint('$runtimeType Error: $error');
    debugPrint('StackTrace: $stackTrace');
    
    // Emit error state
    emit(ErrorState(
      message: _getErrorMessage(error),
      code: _getErrorCode(error),
      error: error,
    ) as State);
  }

  String _getErrorMessage(Object error) {
    if (error is FirebaseException) {
      return 'Firebase error: ${error.message}';
    } else if (error is NetworkException) {
      return 'Network error: Please check your connection';
    }
    return 'An unexpected error occurred';
  }

  String? _getErrorCode(Object error) {
    if (error is FirebaseException) {
      return error.code;
    }
    return null;
  }
}

/// Concrete BLoC implementation
class DocumentBloc extends BaseBloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repository;

  DocumentBloc({DocumentRepository? repository})
    : _repository = repository ?? DocumentRepositoryImpl.instance,
      super(const DocumentState.initial()) {
    
    on<LoadDocuments>(_onLoadDocuments);
    on<UploadDocument>(_onUploadDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  @override
  Future<void> onRefresh(Emitter<DocumentState> emit) async {
    add(const DocumentEvent.loadDocuments());
  }

  Future<void> _onLoadDocuments(
    LoadDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    try {
      emit(const DocumentState.loading());
      final documents = await _repository.getAllDocuments();
      emit(DocumentState.loaded(documents));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }
}
```

### Repository Abstraction

```dart
/// Abstract base repository providing common functionality
abstract class BaseRepository {
  static const Duration defaultTimeout = Duration(seconds: 30);

  /// Execute operation with timeout and error handling
  Future<T> executeWithTimeout<T>(
    Future<T> Function() operation, {
    Duration? timeout,
    String? operationName,
  }) async {
    try {
      final result = await operation().timeout(
        timeout ?? defaultTimeout,
        onTimeout: () {
          throw TimeoutException(
            'Operation ${operationName ?? 'unknown'} timed out',
            timeout ?? defaultTimeout,
          );
        },
      );
      return result;
    } catch (e) {
      debugPrint('Repository Error in ${operationName ?? 'unknown'}: $e');
      rethrow;
    }
  }

  /// Execute operation with retry logic
  Future<T> executeWithRetry<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 1),
    String? operationName,
  }) async {
    int attempts = 0;
    
    while (attempts < maxRetries) {
      try {
        return await operation();
      } catch (e) {
        attempts++;
        
        if (attempts >= maxRetries) {
          debugPrint('Repository: Max retries reached for ${operationName ?? 'unknown'}');
          rethrow;
        }
        
        debugPrint('Repository: Retry $attempts for ${operationName ?? 'unknown'}: $e');
        await Future.delayed(delay * attempts);
      }
    }
    
    throw Exception('Max retries exceeded');
  }

  /// Check if the repository is available
  Future<bool> isAvailable() async {
    return true; // Override in subclasses
  }
}

/// Abstract document repository interface
abstract class DocumentRepository {
  Future<List<DocumentModel>> getAllDocuments({int? limit, DocumentModel? startAfter});
  Future<DocumentModel?> getDocumentById(String id);
  Future<String> createDocument(DocumentModel document);
  Future<void> updateDocument(DocumentModel document);
  Future<void> deleteDocument(String id);
  Stream<List<DocumentModel>> watchDocuments();
  Future<List<DocumentModel>> searchDocuments(String query);
}

/// Concrete implementation
class DocumentRepositoryImpl extends BaseRepository implements DocumentRepository {
  static final DocumentRepositoryImpl _instance = DocumentRepositoryImpl._internal();
  factory DocumentRepositoryImpl() => _instance;
  DocumentRepositoryImpl._internal();

  static DocumentRepositoryImpl get instance => _instance;

  final DocumentService _documentService = DocumentService.instance;
  final EnhancedDocumentService _enhancedDocumentService = EnhancedDocumentService.instance;

  @override
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentModel? startAfter,
  }) async {
    return executeWithTimeout(
      () async {
        // Check if enhanced service can handle unlimited queries
        if (limit == null || limit > FirebaseConfig.batchSize) {
          final canUnlimited = await _enhancedDocumentService.canPerformUnlimitedQueries;
          if (canUnlimited) {
            return await _enhancedDocumentService.getAllDocumentsUnlimited();
          }
        }

        // Use regular service for limited queries
        return await _documentService.getAllDocuments(
          limit: limit,
          startAfter: startAfter != null ? await _getDocumentSnapshot(startAfter.id) : null,
        );
      },
      operationName: 'getAllDocuments',
    );
  }

  @override
  Future<bool> isAvailable() async {
    try {
      await FirebaseFirestore.instance.doc('test/connectivity').get();
      return true;
    } catch (e) {
      return false;
    }
  }
}
```

## 2. Encapsulation

Encapsulation bundles data and methods together while hiding internal implementation details. SimDoc uses encapsulation to protect data integrity and provide controlled access to object properties.

### Model Encapsulation

```dart
/// Document model with encapsulated data and validation
class DocumentModel {
  // Private fields
  final String _id;
  final String _fileName;
  final int _fileSize;
  final String _fileType;
  final String _filePath;
  final String _uploadedBy;
  final DateTime _uploadedAt;
  final String _category;
  final List<String> _permissions;
  final DocumentMetadata _metadata;

  // Recycle bin fields
  final bool _isDeleted;
  final DateTime? _deletedAt;
  final String? _deletedBy;

  // Private constructor
  DocumentModel._({
    required String id,
    required String fileName,
    required int fileSize,
    required String fileType,
    required String filePath,
    required String uploadedBy,
    required DateTime uploadedAt,
    required String category,
    required List<String> permissions,
    required DocumentMetadata metadata,
    required bool isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) : _id = id,
       _fileName = fileName,
       _fileSize = fileSize,
       _fileType = fileType,
       _filePath = filePath,
       _uploadedBy = uploadedBy,
       _uploadedAt = uploadedAt,
       _category = category,
       _permissions = List.unmodifiable(permissions),
       _metadata = metadata,
       _isDeleted = isDeleted,
       _deletedAt = deletedAt,
       _deletedBy = deletedBy;

  /// Factory constructor with validation
  factory DocumentModel.create({
    required String fileName,
    required int fileSize,
    required String fileType,
    required String filePath,
    required String uploadedBy,
    required String category,
    List<String>? permissions,
    DocumentMetadata? metadata,
  }) {
    // Validation
    if (fileName.isEmpty) {
      throw ArgumentError('File name cannot be empty');
    }
    if (fileSize <= 0) {
      throw ArgumentError('File size must be positive');
    }
    if (fileSize > 15 * 1024 * 1024) {
      throw ArgumentError('File size cannot exceed 15MB');
    }
    if (!_isValidFileType(fileType)) {
      throw ArgumentError('Unsupported file type: $fileType');
    }

    return DocumentModel._(
      id: const Uuid().v4(),
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      filePath: filePath,
      uploadedBy: uploadedBy,
      uploadedAt: DateTime.now(),
      category: category,
      permissions: permissions ?? [],
      metadata: metadata ?? DocumentMetadata.empty(),
      isDeleted: false,
    );
  }

  /// Factory constructor from Firestore data
  factory DocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    return DocumentModel._(
      id: data['id'] ?? doc.id,
      fileName: data['fileName'] ?? '',
      fileSize: data['fileSize'] ?? 0,
      fileType: data['fileType'] ?? '',
      filePath: data['filePath'] ?? '',
      uploadedBy: data['uploadedBy'] ?? '',
      uploadedAt: (data['uploadedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      category: data['category'] ?? '',
      permissions: List<String>.from(data['permissions'] ?? []),
      metadata: DocumentMetadata.fromMap(data['metadata'] ?? {}),
      isDeleted: data['isDeleted'] ?? false,
      deletedAt: (data['deletedAt'] as Timestamp?)?.toDate(),
      deletedBy: data['deletedBy'],
    );
  }

  // Public getters (read-only access)
  String get id => _id;
  String get fileName => _fileName;
  int get fileSize => _fileSize;
  String get fileType => _fileType;
  String get filePath => _filePath;
  String get uploadedBy => _uploadedBy;
  DateTime get uploadedAt => _uploadedAt;
  String get category => _category;
  List<String> get permissions => List.unmodifiable(_permissions);
  DocumentMetadata get metadata => _metadata;
  bool get isDeleted => _isDeleted;
  DateTime? get deletedAt => _deletedAt;
  String? get deletedBy => _deletedBy;

  // Computed properties
  String get fileExtension => path.extension(_fileName);
  String get fileSizeFormatted => _formatFileSize(_fileSize);
  bool get isImage => _fileType.startsWith('image/');
  bool get isPDF => _fileType == 'application/pdf';
  bool get isExpired => _isDeleted && _deletedAt != null && 
                       DateTime.now().difference(_deletedAt!).inDays > 7;

  // Business logic methods
  bool hasPermission(String userId, String permission) {
    return _uploadedBy == userId || _permissions.contains('$userId:$permission');
  }

  bool canBeAccessedBy(String userId) {
    return !_isDeleted && (_uploadedBy == userId || _permissions.contains(userId));
  }

  // Immutable update methods
  DocumentModel copyWith({
    String? fileName,
    String? category,
    List<String>? permissions,
    bool? isDeleted,
    DateTime? deletedAt,
    String? deletedBy,
  }) {
    return DocumentModel._(
      id: _id,
      fileName: fileName ?? _fileName,
      fileSize: _fileSize,
      fileType: _fileType,
      filePath: _filePath,
      uploadedBy: _uploadedBy,
      uploadedAt: _uploadedAt,
      category: category ?? _category,
      permissions: permissions ?? _permissions,
      metadata: _metadata,
      isDeleted: isDeleted ?? _isDeleted,
      deletedAt: deletedAt ?? _deletedAt,
      deletedBy: deletedBy ?? _deletedBy,
    );
  }

  DocumentModel markAsDeleted(String deletedBy) {
    return copyWith(
      isDeleted: true,
      deletedAt: DateTime.now(),
      deletedBy: deletedBy,
    );
  }

  DocumentModel restore() {
    return copyWith(
      isDeleted: false,
      deletedAt: null,
      deletedBy: null,
    );
  }

  // Conversion methods
  Map<String, dynamic> toFirestore() {
    return {
      'id': _id,
      'fileName': _fileName,
      'fileSize': _fileSize,
      'fileType': _fileType,
      'filePath': _filePath,
      'uploadedBy': _uploadedBy,
      'uploadedAt': Timestamp.fromDate(_uploadedAt),
      'category': _category,
      'permissions': _permissions,
      'metadata': _metadata.toMap(),
      'isDeleted': _isDeleted,
      'deletedAt': _deletedAt != null ? Timestamp.fromDate(_deletedAt!) : null,
      'deletedBy': _deletedBy,
    };
  }

  // Private helper methods
  static bool _isValidFileType(String fileType) {
    const allowedTypes = [
      'application/pdf',
      'application/msword',
      'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'application/vnd.ms-powerpoint',
      'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    ];
    return allowedTypes.contains(fileType);
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DocumentModel && other._id == _id;
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() => 'DocumentModel(id: $_id, fileName: $_fileName)';
}
```

### Service Encapsulation

```dart
/// Document service with encapsulated Firebase operations
class DocumentService {
  // Singleton pattern with private constructor
  static final DocumentService _instance = DocumentService._internal();
  factory DocumentService() => _instance;
  DocumentService._internal();

  static DocumentService get instance => _instance;

  // Private dependencies
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;

  // Private configuration
  static const String _documentsCollection = 'documents';
  static const int _defaultBatchSize = 50;
  static const Duration _operationTimeout = Duration(seconds: 30);

  // Private state
  bool _isInitialized = false;
  StreamSubscription<QuerySnapshot>? _documentsSubscription;

  /// Initialize the service (private method)
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await _initializeService();
      _isInitialized = true;
    }
  }

  Future<void> _initializeService() async {
    // Private initialization logic
    debugPrint('DocumentService: Initializing...');
    // Setup listeners, validate configuration, etc.
  }

  /// Public interface for getting all documents
  Future<List<DocumentModel>> getAllDocuments({
    int? limit,
    DocumentSnapshot? startAfter,
  }) async {
    await _ensureInitialized();
    
    try {
      return await _executeQuery(
        limit: limit ?? _defaultBatchSize,
        startAfter: startAfter,
      );
    } catch (e) {
      debugPrint('DocumentService: Error getting documents: $e');
      rethrow;
    }
  }

  /// Private query execution method
  Future<List<DocumentModel>> _executeQuery({
    int limit = 50,
    DocumentSnapshot? startAfter,
    Map<String, dynamic>? filters,
  }) async {
    Query query = _firestore
        .collection(_documentsCollection)
        .where('isDeleted', isEqualTo: false)
        .orderBy('uploadedAt', descending: true)
        .limit(limit);

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    if (filters != null) {
      filters.forEach((field, value) {
        query = query.where(field, isEqualTo: value);
      });
    }

    final snapshot = await query.get().timeout(_operationTimeout);
    return snapshot.docs.map((doc) => DocumentModel.fromFirestore(doc)).toList();
  }

  /// Private file validation method
  Future<void> _validateFile(File file) async {
    final fileSize = await file.length();
    if (fileSize > 15 * 1024 * 1024) {
      throw ValidationException('File size exceeds 15MB limit');
    }

    final fileName = path.basename(file.path);
    final extension = path.extension(fileName).toLowerCase();
    
    const allowedExtensions = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx'];
    if (!allowedExtensions.contains(extension)) {
      throw ValidationException('Unsupported file type: $extension');
    }
  }

  /// Private cleanup method
  void _cleanup() {
    _documentsSubscription?.cancel();
    _documentsSubscription = null;
    _isInitialized = false;
  }

  /// Public disposal method
  void dispose() {
    _cleanup();
    debugPrint('DocumentService: Disposed');
  }
}
```

## 3. Polymorphism

Polymorphism allows objects of different types to be treated as instances of the same type through a common interface. SimDoc uses polymorphism extensively for flexible and extensible code.

### File Processor Polymorphism

```dart
/// Abstract file processor interface
abstract class FileProcessor {
  Future<Map<String, dynamic>> extractMetadata(File file);
  Future<bool> validateFile(File file);
  Future<String> generateThumbnail(File file);
  String get supportedMimeType;
  List<String> get supportedExtensions;
}

/// PDF file processor implementation
class PDFProcessor implements FileProcessor {
  @override
  String get supportedMimeType => 'application/pdf';

  @override
  List<String> get supportedExtensions => ['.pdf'];

  @override
  Future<Map<String, dynamic>> extractMetadata(File file) async {
    // PDF-specific metadata extraction
    final bytes = await file.readAsBytes();

    return {
      'pageCount': await _getPageCount(bytes),
      'title': await _extractTitle(bytes),
      'author': await _extractAuthor(bytes),
      'creationDate': await _extractCreationDate(bytes),
      'hasText': await _hasTextContent(bytes),
      'isPasswordProtected': await _isPasswordProtected(bytes),
    };
  }

  @override
  Future<bool> validateFile(File file) async {
    try {
      final bytes = await file.readAsBytes();

      // Check PDF signature
      if (bytes.length < 4) return false;
      final signature = String.fromCharCodes(bytes.take(4));
      if (signature != '%PDF') return false;

      // Additional PDF validation
      return await _validatePDFStructure(bytes);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> generateThumbnail(File file) async {
    // PDF thumbnail generation logic
    final bytes = await file.readAsBytes();
    final thumbnailBytes = await _generatePDFThumbnail(bytes);

    // Save thumbnail and return path
    final thumbnailPath = await _saveThumbnail(thumbnailBytes, file.path);
    return thumbnailPath;
  }

  // Private PDF-specific methods
  Future<int> _getPageCount(Uint8List bytes) async { /* Implementation */ }
  Future<String?> _extractTitle(Uint8List bytes) async { /* Implementation */ }
  Future<bool> _validatePDFStructure(Uint8List bytes) async { /* Implementation */ }
}

/// Word document processor implementation
class WordProcessor implements FileProcessor {
  @override
  String get supportedMimeType => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';

  @override
  List<String> get supportedExtensions => ['.docx', '.doc'];

  @override
  Future<Map<String, dynamic>> extractMetadata(File file) async {
    // Word-specific metadata extraction
    return {
      'wordCount': await _getWordCount(file),
      'pageCount': await _getPageCount(file),
      'author': await _extractAuthor(file),
      'lastModified': await _getLastModified(file),
      'hasImages': await _hasImages(file),
      'hasComments': await _hasComments(file),
    };
  }

  @override
  Future<bool> validateFile(File file) async {
    try {
      // Word document validation logic
      if (file.path.endsWith('.docx')) {
        return await _validateDocx(file);
      } else {
        return await _validateDoc(file);
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String> generateThumbnail(File file) async {
    // Word document thumbnail generation
    final previewImage = await _generateWordPreview(file);
    final thumbnailPath = await _saveThumbnail(previewImage, file.path);
    return thumbnailPath;
  }

  // Private Word-specific methods
  Future<int> _getWordCount(File file) async { /* Implementation */ }
  Future<bool> _validateDocx(File file) async { /* Implementation */ }
}

/// File processor factory using polymorphism
class FileProcessorFactory {
  static final Map<String, FileProcessor> _processors = {
    'application/pdf': PDFProcessor(),
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document': WordProcessor(),
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': ExcelProcessor(),
    'application/vnd.openxmlformats-officedocument.presentationml.presentation': PowerPointProcessor(),
  };

  /// Get processor for file type (polymorphic behavior)
  static FileProcessor? getProcessor(String mimeType) {
    return _processors[mimeType];
  }

  /// Process file using appropriate processor
  static Future<ProcessingResult> processFile(File file, String mimeType) async {
    final processor = getProcessor(mimeType);
    if (processor == null) {
      throw UnsupportedError('Unsupported file type: $mimeType');
    }

    // Polymorphic method calls - same interface, different implementations
    final isValid = await processor.validateFile(file);
    if (!isValid) {
      throw ValidationException('File validation failed');
    }

    final metadata = await processor.extractMetadata(file);
    final thumbnailPath = await processor.generateThumbnail(file);

    return ProcessingResult(
      metadata: metadata,
      thumbnailPath: thumbnailPath,
      processor: processor.runtimeType.toString(),
    );
  }
}
```

### Repository Polymorphism

```dart
/// Multiple repository implementations for different data sources
abstract class DocumentRepository {
  Future<List<DocumentModel>> getAllDocuments();
  Future<DocumentModel?> getDocumentById(String id);
  Future<void> saveDocument(DocumentModel document);
}

/// Firebase implementation
class FirebaseDocumentRepository implements DocumentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    final snapshot = await _firestore.collection('documents').get();
    return snapshot.docs.map((doc) => DocumentModel.fromFirestore(doc)).toList();
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    final doc = await _firestore.collection('documents').doc(id).get();
    return doc.exists ? DocumentModel.fromFirestore(doc) : null;
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    await _firestore.collection('documents').doc(document.id).set(document.toFirestore());
  }
}

/// Local storage implementation
class LocalDocumentRepository implements DocumentRepository {
  final Box<Map> _box = Hive.box<Map>('documents');

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    final documents = _box.values
        .map((data) => DocumentModel.fromMap(Map<String, dynamic>.from(data)))
        .toList();
    return documents;
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    final data = _box.get(id);
    return data != null ? DocumentModel.fromMap(Map<String, dynamic>.from(data)) : null;
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    await _box.put(document.id, document.toMap());
  }
}

/// Cached repository combining multiple sources
class CachedDocumentRepository implements DocumentRepository {
  final DocumentRepository _primaryRepository;
  final DocumentRepository _cacheRepository;

  CachedDocumentRepository({
    required DocumentRepository primaryRepository,
    required DocumentRepository cacheRepository,
  }) : _primaryRepository = primaryRepository,
       _cacheRepository = cacheRepository;

  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    try {
      // Try primary repository first
      final documents = await _primaryRepository.getAllDocuments();

      // Update cache
      for (final document in documents) {
        await _cacheRepository.saveDocument(document);
      }

      return documents;
    } catch (e) {
      // Fallback to cache
      debugPrint('Primary repository failed, using cache: $e');
      return await _cacheRepository.getAllDocuments();
    }
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    try {
      final document = await _primaryRepository.getDocumentById(id);
      if (document != null) {
        await _cacheRepository.saveDocument(document);
      }
      return document;
    } catch (e) {
      return await _cacheRepository.getDocumentById(id);
    }
  }

  @override
  Future<void> saveDocument(DocumentModel document) async {
    // Save to both repositories
    await Future.wait([
      _primaryRepository.saveDocument(document),
      _cacheRepository.saveDocument(document),
    ]);
  }
}

/// Repository provider using polymorphism
class RepositoryProvider {
  static DocumentRepository createRepository({
    bool useCache = true,
    bool offlineMode = false,
  }) {
    if (offlineMode) {
      return LocalDocumentRepository();
    }

    final primaryRepo = FirebaseDocumentRepository();

    if (useCache) {
      final cacheRepo = LocalDocumentRepository();
      return CachedDocumentRepository(
        primaryRepository: primaryRepo,
        cacheRepository: cacheRepo,
      );
    }

    return primaryRepo;
  }
}
```

## 4. Inheritance

Inheritance allows classes to inherit properties and methods from parent classes, promoting code reuse and establishing hierarchical relationships.

### Widget Inheritance Hierarchy

```dart
/// Base screen class providing common functionality
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});

  @override
  BaseScreenState createState();
}

/// Base state class with common lifecycle management
abstract class BaseScreenState<T extends BaseScreen> extends State<T>
    with RouteAware, WidgetsBindingObserver {

  // Common properties
  bool _isLoading = false;
  String? _errorMessage;
  late final StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeConnectivity();
    onInitialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    _connectivitySubscription.cancel();
    onDispose();
    super.dispose();
  }

  // Abstract methods for subclasses to implement
  void onInitialize();
  void onDispose();
  Widget buildBody(BuildContext context);

  // Common lifecycle methods
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onAppResumed();
        break;
      case AppLifecycleState.paused:
        onAppPaused();
        break;
      case AppLifecycleState.detached:
        onAppDetached();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  // Virtual methods (can be overridden)
  void onAppResumed() {
    debugPrint('${widget.runtimeType}: App resumed');
  }

  void onAppPaused() {
    debugPrint('${widget.runtimeType}: App paused');
  }

  void onAppDetached() {
    debugPrint('${widget.runtimeType}: App detached');
  }

  // Common utility methods
  void setLoading(bool loading) {
    if (mounted) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  void setError(String? error) {
    if (mounted) {
      setState(() {
        _errorMessage = error;
      });
    }
  }

  void showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
        ),
      );
    }
  }

  Future<bool> showConfirmDialog(String title, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _initializeConnectivity() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        onConnectivityChanged(result);
      },
    );
  }

  void onConnectivityChanged(ConnectivityResult result) {
    final isConnected = result != ConnectivityResult.none;
    debugPrint('${widget.runtimeType}: Connectivity changed - $isConnected');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildBody(context),
          if (_isLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (_errorMessage != null)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 10,
              right: 10,
              child: Material(
                color: Colors.red,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.error, color: Colors.white),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => setError(null),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Concrete screen implementation inheriting from BaseScreen
class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});

  @override
  BaseScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DocumentModel> _documents = [];

  @override
  void onInitialize() {
    // Home screen specific initialization
    _loadDocuments();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void onDispose() {
    // Home screen specific cleanup
    _searchController.dispose();
  }

  @override
  void onAppResumed() {
    super.onAppResumed();
    // Refresh data when app resumes
    _refreshDocuments();
  }

  @override
  void onConnectivityChanged(ConnectivityResult result) {
    super.onConnectivityChanged(result);
    if (result != ConnectivityResult.none) {
      // Sync data when connectivity is restored
      _syncDocuments();
    }
  }

  @override
  Widget buildBody(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshDocuments,
      child: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _buildDocumentList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        decoration: const InputDecoration(
          hintText: 'Cari dokumen...',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildDocumentList() {
    if (_documents.isEmpty) {
      return const Center(
        child: Text('Tidak ada dokumen'),
      );
    }

    return ListView.builder(
      itemCount: _documents.length,
      itemBuilder: (context, index) {
        final document = _documents[index];
        return ListTile(
          title: Text(document.fileName),
          subtitle: Text(document.fileSizeFormatted),
          onTap: () => _openDocument(document),
        );
      },
    );
  }

  Future<void> _loadDocuments() async {
    setLoading(true);
    try {
      // Load documents logic
      final documents = await DocumentService.instance.getAllDocuments();
      setState(() {
        _documents = documents;
      });
      setError(null);
    } catch (e) {
      setError('Gagal memuat dokumen: $e');
    } finally {
      setLoading(false);
    }
  }

  Future<void> _refreshDocuments() async {
    await _loadDocuments();
  }

  Future<void> _syncDocuments() async {
    // Sync logic
  }

  void _onSearchChanged() {
    // Search logic
  }

  void _openDocument(DocumentModel document) {
    Navigator.pushNamed(
      context,
      AppRoutes.filePreview,
      arguments: document,
    );
  }
}
```

### BLoC Inheritance Hierarchy

```dart
/// Specialized BLoC for file operations inheriting from BaseBloc
class FileOperationBloc extends BaseBloc<FileOperationEvent, FileOperationState> {
  final FileService _fileService;

  FileOperationBloc({FileService? fileService})
    : _fileService = fileService ?? FileService.instance,
      super(const FileOperationState.initial()) {

    // Register common file operation events
    on<UploadFile>(_onUploadFile);
    on<DownloadFile>(_onDownloadFile);
    on<DeleteFile>(_onDeleteFile);
  }

  @override
  Future<void> onRefresh(Emitter<FileOperationState> emit) async {
    add(const FileOperationEvent.refreshFiles());
  }

  // Common file operation methods
  Future<void> _onUploadFile(UploadFile event, Emitter<FileOperationState> emit) async {
    try {
      emit(const FileOperationState.uploading());

      final result = await _fileService.uploadFile(
        event.file,
        event.category,
        onProgress: (progress) {
          emit(FileOperationState.uploadProgress(progress));
        },
      );

      emit(FileOperationState.uploadSuccess(result));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }

  Future<void> _onDownloadFile(DownloadFile event, Emitter<FileOperationState> emit) async {
    try {
      emit(const FileOperationState.downloading());

      final filePath = await _fileService.downloadFile(
        event.document,
        onProgress: (progress) {
          emit(FileOperationState.downloadProgress(progress));
        },
      );

      emit(FileOperationState.downloadSuccess(filePath));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }

  Future<void> _onDeleteFile(DeleteFile event, Emitter<FileOperationState> emit) async {
    try {
      emit(const FileOperationState.deleting());

      await _fileService.deleteFile(event.documentId);

      emit(const FileOperationState.deleteSuccess());
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }
}

/// Document-specific BLoC inheriting from FileOperationBloc
class DocumentBloc extends FileOperationBloc {
  final DocumentRepository _repository;

  DocumentBloc({DocumentRepository? repository})
    : _repository = repository ?? DocumentRepositoryImpl.instance,
      super() {

    // Register document-specific events
    on<LoadDocuments>(_onLoadDocuments);
    on<SearchDocuments>(_onSearchDocuments);
    on<FilterDocuments>(_onFilterDocuments);
  }

  Future<void> _onLoadDocuments(LoadDocuments event, Emitter<FileOperationState> emit) async {
    try {
      emit(const FileOperationState.loading());

      final documents = await _repository.getAllDocuments(
        limit: event.limit,
        startAfter: event.startAfter,
      );

      emit(FileOperationState.documentsLoaded(documents));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }

  Future<void> _onSearchDocuments(SearchDocuments event, Emitter<FileOperationState> emit) async {
    try {
      emit(const FileOperationState.searching());

      final documents = await _repository.searchDocuments(event.query);

      emit(FileOperationState.searchResults(documents, event.query));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }
}

/// Category-specific BLoC inheriting from BaseBloc
class CategoryBloc extends BaseBloc<CategoryEvent, CategoryState> {
  final CategoryRepository _repository;

  CategoryBloc({CategoryRepository? repository})
    : _repository = repository ?? CategoryRepositoryImpl.instance,
      super(const CategoryState.initial()) {

    on<LoadCategories>(_onLoadCategories);
    on<CreateCategory>(_onCreateCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<DeleteCategory>(_onDeleteCategory);
  }

  @override
  Future<void> onRefresh(Emitter<CategoryState> emit) async {
    add(const CategoryEvent.loadCategories());
  }

  // Category-specific implementations
  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(const CategoryState.loading());

      final categories = await _repository.getAllCategories();

      emit(CategoryState.loaded(categories));
    } catch (error, stackTrace) {
      handleBlocError(error, stackTrace, emit);
    }
  }
}
```

This comprehensive documentation demonstrates how SimDoc implements all four fundamental object-oriented design patterns to create a maintainable, scalable, and robust application architecture. Each pattern serves a specific purpose in promoting code reuse, maintainability, and extensibility while ensuring proper separation of concerns and data protection.
