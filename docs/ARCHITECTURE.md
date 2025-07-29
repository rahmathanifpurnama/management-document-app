# Architecture Documentation

## Overview

The SimDoc application follows a **Riverpod + BLoC Hybrid Architecture** combined with **Clean Architecture** principles and comprehensive **Object-Oriented Design Patterns**.

## Architecture Layers

### 1. Presentation Layer
- **Screens**: UI components organized by feature
- **Widgets**: Reusable UI components
- **BLoC**: Complex business logic state management
- **Riverpod**: Simple state and UI management

### 2. Domain Layer
- **Models**: Data structures and business entities
- **Repositories**: Abstract data access interfaces
- **Use Cases**: Business logic operations

### 3. Data Layer
- **Firebase Services**: Cloud data access
- **Local Storage**: Device-based storage
- **Repository Implementations**: Concrete data access

## State Management Strategy

### Riverpod Usage (Simple State)
```dart
// UI State Management
final loadingStateProvider = StateProvider<bool>((ref) => false);

// Settings and Preferences
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

// Computed Values
final filteredDocumentsProvider = Provider<List<DocumentModel>>((ref) {
  final documents = ref.watch(documentsProvider);
  final filter = ref.watch(filterProvider);
  return documents.where((doc) => doc.category == filter).toList();
});

// Dependency Injection
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService.instance;
});
```

### BLoC Usage (Complex Business Logic)
```dart
// Authentication Flow
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState.initial()) {
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<Initialize>(_onInitialize);
  }
}

// Document Operations
class DocumentBloc extends BaseBloc<DocumentEvent, DocumentState> {
  DocumentBloc({DocumentRepository? repository})
    : _repository = repository ?? DocumentRepositoryImpl.instance,
      super(const DocumentState.initial()) {
    on<LoadDocuments>(_onLoadDocuments);
    on<UploadDocument>(_onUploadDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }
}
```

## Object-Oriented Design Patterns

### 1. Abstraction

#### Base Classes
```dart
// Abstract base notifier for Riverpod
abstract class BaseNotifier<T> extends StateNotifier<T> {
  BaseNotifier(super.initialState);
  
  void safeUpdate(T Function() updater);
  void handleError(Object error);
  void reset();
}

// Abstract base BLoC
abstract class BaseBloc<Event extends BaseEvent, State extends BaseState>
    extends Bloc<Event, State> {
  BaseBloc(super.initialState);
  
  Future<void> onRefresh(Emitter<State> emit);
}

// Abstract repository interface
abstract class BaseRepository {
  Future<T> executeWithTimeout<T>(Future<T> Function() operation);
  Future<T> executeWithRetry<T>(Future<T> Function() operation);
  Future<bool> isAvailable();
}
```

#### Interface Definitions
```dart
// Document repository interface
abstract class DocumentRepository {
  Future<List<DocumentModel>> getAllDocuments();
  Future<DocumentModel?> getDocumentById(String id);
  Future<String> createDocument(DocumentModel document);
  Future<void> updateDocument(DocumentModel document);
  Future<void> deleteDocument(String id);
  Stream<List<DocumentModel>> watchDocuments();
}

// Authentication service interface
abstract class AuthenticationService {
  Future<UserModel?> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> watchAuthState();
}
```

### 2. Encapsulation

#### Data Encapsulation
```dart
class DocumentModel {
  final String _id;
  final String _fileName;
  final DateTime _uploadedAt;
  
  // Private constructor
  DocumentModel._({
    required String id,
    required String fileName,
    required DateTime uploadedAt,
  }) : _id = id, _fileName = fileName, _uploadedAt = uploadedAt;
  
  // Factory constructor with validation
  factory DocumentModel.create({
    required String fileName,
    required String uploadedBy,
  }) {
    if (fileName.isEmpty) throw ArgumentError('File name cannot be empty');
    
    return DocumentModel._(
      id: const Uuid().v4(),
      fileName: fileName,
      uploadedAt: DateTime.now(),
    );
  }
  
  // Public getters
  String get id => _id;
  String get fileName => _fileName;
  DateTime get uploadedAt => _uploadedAt;
}
```

#### Service Encapsulation
```dart
class DocumentService {
  static final DocumentService _instance = DocumentService._internal();
  factory DocumentService() => _instance;
  DocumentService._internal();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Private methods
  Future<String> _generateSecureFileName(String originalName) async {
    // Internal file name generation logic
  }
  
  Future<void> _validateFileType(String fileName) async {
    // Internal file validation logic
  }
  
  // Public interface
  Future<String> uploadDocument(File file, String category) async {
    await _validateFileType(file.path);
    final secureFileName = await _generateSecureFileName(file.path);
    // Upload logic
  }
}
```

### 3. Polymorphism

#### Repository Implementations
```dart
// Multiple implementations of the same interface
class FirebaseDocumentRepository extends BaseRepository implements DocumentRepository {
  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    // Firebase implementation
  }
}

class LocalDocumentRepository extends BaseRepository implements DocumentRepository {
  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    // Local storage implementation
  }
}

class CachedDocumentRepository extends BaseRepository implements DocumentRepository {
  final DocumentRepository _primary;
  final DocumentRepository _cache;
  
  CachedDocumentRepository(this._primary, this._cache);
  
  @override
  Future<List<DocumentModel>> getAllDocuments() async {
    try {
      return await _primary.getAllDocuments();
    } catch (e) {
      return await _cache.getAllDocuments();
    }
  }
}
```

#### File Processors
```dart
abstract class FileProcessor {
  Future<Map<String, dynamic>> extractMetadata(File file);
  Future<bool> validateFile(File file);
}

class PDFProcessor implements FileProcessor {
  @override
  Future<Map<String, dynamic>> extractMetadata(File file) async {
    // PDF-specific metadata extraction
  }
  
  @override
  Future<bool> validateFile(File file) async {
    // PDF-specific validation
  }
}

class ImageProcessor implements FileProcessor {
  @override
  Future<Map<String, dynamic>> extractMetadata(File file) async {
    // Image-specific metadata extraction
  }
  
  @override
  Future<bool> validateFile(File file) async {
    // Image-specific validation
  }
}

// Factory for creating processors
class FileProcessorFactory {
  static FileProcessor createProcessor(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return PDFProcessor();
      case 'jpg':
      case 'png':
        return ImageProcessor();
      default:
        throw UnsupportedError('Unsupported file type: $fileType');
    }
  }
}
```

### 4. Inheritance

#### Widget Inheritance
```dart
// Base screen class
abstract class BaseScreen extends StatefulWidget {
  const BaseScreen({super.key});
  
  @override
  BaseScreenState createState();
}

abstract class BaseScreenState<T extends BaseScreen> extends State<T> 
    with RouteAware {
  
  @override
  void initState() {
    super.initState();
    onInitialize();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }
  
  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    onDispose();
    super.dispose();
  }
  
  // Abstract methods for subclasses
  void onInitialize();
  void onDispose();
  
  // Common functionality
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Concrete implementation
class HomeScreen extends BaseScreen {
  const HomeScreen({super.key});
  
  @override
  BaseScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseScreenState<HomeScreen> {
  @override
  void onInitialize() {
    // Home screen specific initialization
  }
  
  @override
  void onDispose() {
    // Home screen specific cleanup
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Home screen UI
    );
  }
}
```

#### BLoC Inheritance
```dart
// Feature-specific BLoCs extending base
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthService _authService;
  
  AuthBloc({AuthService? authService})
    : _authService = authService ?? AuthService.instance,
      super(const AuthState.initial());
  
  @override
  Future<void> onRefresh(Emitter<AuthState> emit) async {
    add(const AuthEvent.initialize());
  }
}

class DocumentBloc extends BaseBloc<DocumentEvent, DocumentState> {
  final DocumentRepository _repository;
  
  DocumentBloc({DocumentRepository? repository})
    : _repository = repository ?? DocumentRepositoryImpl.instance,
      super(const DocumentState.initial());
  
  @override
  Future<void> onRefresh(Emitter<DocumentState> emit) async {
    add(const DocumentEvent.loadDocuments());
  }
}
```

## Dependency Injection

### Riverpod Provider Graph
```dart
// Service providers
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService.instance;
});

final authServiceProvider = Provider<AuthService>((ref) {
  final firebase = ref.watch(firebaseServiceProvider);
  return AuthService(firebase);
});

// Repository providers
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final authService = ref.watch(authServiceProvider);
  return DocumentRepositoryImpl(authService);
});

// BLoC providers
final authBlocProvider = Provider<AuthBloc>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthBloc(authService: authService);
});

final documentBlocProvider = Provider<DocumentBloc>((ref) {
  final repository = ref.watch(documentRepositoryProvider);
  return DocumentBloc(repository: repository);
});
```

## Error Handling Strategy

### Centralized Error Handling
```dart
// Base error handling
abstract class AppError {
  final String message;
  final String? code;
  final dynamic originalError;
  
  const AppError({
    required this.message,
    this.code,
    this.originalError,
  });
}

class NetworkError extends AppError {
  const NetworkError({required super.message, super.code, super.originalError});
}

class AuthenticationError extends AppError {
  const AuthenticationError({required super.message, super.code, super.originalError});
}

class ValidationError extends AppError {
  const ValidationError({required super.message, super.code, super.originalError});
}

// Error handler service
class ErrorHandlerService {
  static void handleError(AppError error) {
    // Log error
    debugPrint('Error: ${error.message}');
    
    // Report to analytics
    FirebaseCrashlytics.instance.recordError(
      error.originalError ?? error.message,
      null,
      fatal: false,
    );
    
    // Show user-friendly message
    _showUserMessage(error);
  }
  
  static void _showUserMessage(AppError error) {
    String userMessage;
    switch (error.runtimeType) {
      case NetworkError:
        userMessage = 'Koneksi internet bermasalah. Silakan coba lagi.';
        break;
      case AuthenticationError:
        userMessage = 'Sesi Anda telah berakhir. Silakan login kembali.';
        break;
      case ValidationError:
        userMessage = error.message;
        break;
      default:
        userMessage = 'Terjadi kesalahan. Silakan coba lagi.';
    }
    
    // Show snackbar or dialog
    _showSnackBar(userMessage);
  }
}
```

This architecture ensures maintainable, scalable, and testable code while following object-oriented principles throughout the application.
