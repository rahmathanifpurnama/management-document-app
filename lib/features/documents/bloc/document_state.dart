import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/document_model.dart';

part 'document_state.freezed.dart';

/// Document States for DocumentBloc
///
/// These states represent all possible states of the document management system.
@freezed
class DocumentState with _$DocumentState {
  /// Initial state when DocumentBloc is first created
  const factory DocumentState.initial() = DocumentInitial;

  /// Loading state when documents are being fetched
  ///
  /// [message] - Optional loading message to display
  const factory DocumentState.loading({String? message}) = DocumentLoading;

  /// Loaded state when documents have been successfully fetched
  ///
  /// [documents] - All documents from the repository
  /// [filteredDocuments] - Documents after applying filters and search
  /// [searchQuery] - Current search query
  /// [selectedCategory] - Currently selected category filter
  /// [selectedStatus] - Currently selected status filter
  /// [selectedFileType] - Currently selected file type filter
  /// [selectedUserId] - Currently selected user filter
  /// [sortBy] - Current sort field
  /// [sortAscending] - Current sort order
  /// [isListening] - Whether real-time listening is active
  /// [hasMoreDocuments] - Whether more documents are available for pagination
  /// [statistics] - Document statistics (optional)
  /// [lastLoadTime] - Timestamp of last successful load
  const factory DocumentState.loaded({
    required List<DocumentModel> documents,
    required List<DocumentModel> filteredDocuments,
    @Default('') String searchQuery,
    @Default('all') String selectedCategory,
    @Default('all') String selectedStatus,
    @Default('all') String selectedFileType,
    String? selectedUserId,
    @Default('uploadedAt') String sortBy,
    @Default(false) bool sortAscending,
    @Default(false) bool isListening,
    @Default(true) bool hasMoreDocuments,
    Map<String, dynamic>? statistics,
    DateTime? lastLoadTime,
  }) = DocumentLoaded;

  /// Error state when an operation has failed
  ///
  /// [message] - Error message to display
  /// [previousState] - Previous state before error (optional)
  /// [canRetry] - Whether the operation can be retried
  const factory DocumentState.error({
    required String message,
    DocumentState? previousState,
    @Default(true) bool canRetry,
  }) = DocumentError;

  /// Loading more documents state (for pagination)
  ///
  /// [currentDocuments] - Documents currently loaded
  /// [filteredDocuments] - Filtered documents currently displayed
  /// [searchQuery] - Current search query
  /// [selectedCategory] - Currently selected category filter
  /// [selectedStatus] - Currently selected status filter
  /// [selectedFileType] - Currently selected file type filter
  /// [selectedUserId] - Currently selected user filter
  /// [sortBy] - Current sort field
  /// [sortAscending] - Current sort order
  /// [isListening] - Whether real-time listening is active
  const factory DocumentState.loadingMore({
    required List<DocumentModel> currentDocuments,
    required List<DocumentModel> filteredDocuments,
    @Default('') String searchQuery,
    @Default('all') String selectedCategory,
    @Default('all') String selectedStatus,
    @Default('all') String selectedFileType,
    String? selectedUserId,
    @Default('uploadedAt') String sortBy,
    @Default(false) bool sortAscending,
    @Default(false) bool isListening,
  }) = DocumentLoadingMore;

  /// Performing operation state (delete, update, etc.)
  ///
  /// [operation] - Type of operation being performed
  /// [currentDocuments] - Documents currently loaded
  /// [filteredDocuments] - Filtered documents currently displayed
  /// [searchQuery] - Current search query
  /// [selectedCategory] - Currently selected category filter
  /// [selectedStatus] - Currently selected status filter
  /// [selectedFileType] - Currently selected file type filter
  /// [selectedUserId] - Currently selected user filter
  /// [sortBy] - Current sort field
  /// [sortAscending] - Current sort order
  /// [isListening] - Whether real-time listening is active
  const factory DocumentState.performingOperation({
    required String operation,
    required List<DocumentModel> currentDocuments,
    required List<DocumentModel> filteredDocuments,
    @Default('') String searchQuery,
    @Default('all') String selectedCategory,
    @Default('all') String selectedStatus,
    @Default('all') String selectedFileType,
    String? selectedUserId,
    @Default('uploadedAt') String sortBy,
    @Default(false) bool sortAscending,
    @Default(false) bool isListening,
  }) = DocumentPerformingOperation;

  /// Syncing state when synchronizing with external sources
  ///
  /// [message] - Sync status message
  /// [currentDocuments] - Documents currently loaded
  /// [filteredDocuments] - Filtered documents currently displayed
  const factory DocumentState.syncing({
    required String message,
    required List<DocumentModel> currentDocuments,
    required List<DocumentModel> filteredDocuments,
  }) = DocumentSyncing;
}

/// Extension methods for DocumentState
extension DocumentStateExtension on DocumentState {
  /// Get the current list of documents regardless of state
  List<DocumentModel> get currentDocuments {
    return when(
      initial: () => <DocumentModel>[],
      loading: (_) => <DocumentModel>[],
      loaded:
          (
            documents,
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
            ____________,
          ) => documents,
      error: (_, previousState, __) =>
          previousState?.currentDocuments ?? <DocumentModel>[],
      loadingMore:
          (
            currentDocuments,
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
          ) => currentDocuments,
      performingOperation:
          (
            _,
            currentDocuments,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => currentDocuments,
      syncing: (_, currentDocuments, __) => currentDocuments,
    );
  }

  /// Get the current list of filtered documents regardless of state
  List<DocumentModel> get currentFilteredDocuments {
    return when(
      initial: () => <DocumentModel>[],
      loading: (_) => <DocumentModel>[],
      loaded:
          (
            _,
            filteredDocuments,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
            ____________,
          ) => filteredDocuments,
      error: (_, previousState, __) =>
          previousState?.currentFilteredDocuments ?? <DocumentModel>[],
      loadingMore:
          (
            _,
            filteredDocuments,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
          ) => filteredDocuments,
      performingOperation:
          (
            _,
            __,
            filteredDocuments,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => filteredDocuments,
      syncing: (_, __, filteredDocuments) => filteredDocuments,
    );
  }

  /// Check if the state is loading
  bool get isLoading {
    return when(
      initial: () => false,
      loading: (_) => true,
      loaded:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
            ____________,
            _____________,
          ) => false,
      error: (_, __, ___) => false,
      loadingMore:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => true,
      performingOperation:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
          ) => true,
      syncing: (_, __, ___) => true,
    );
  }

  /// Check if the state has data
  bool get hasData {
    return currentDocuments.isNotEmpty;
  }

  /// Check if the state has an error
  bool get hasError {
    return when(
      initial: () => false,
      loading: (_) => false,
      loaded:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
            ____________,
            _____________,
          ) => false,
      error: (_, __, ___) => true,
      loadingMore:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
          ) => false,
      performingOperation:
          (
            _,
            __,
            ___,
            ____,
            _____,
            ______,
            _______,
            ________,
            _________,
            __________,
            ___________,
          ) => false,
      syncing: (_, __, ___) => false,
    );
  }
}
