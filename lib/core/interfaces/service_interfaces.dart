import '../services/greeting_service.dart';
import '../../models/document_model.dart';

/// Interface for greeting services
abstract class IGreetingService {
  GreetingSet getSmartGreeting(String? userName);
  GreetingSet getGreetingWithMotivation(String? userName);
  String getPersonalizedGreeting(String? userName);
  String getMainGreeting();
}

/// Interface for statistics services
abstract class IStatisticsService {
  Future<Map<String, dynamic>> getAggregatedStatistics({
    bool forceRefresh = false,
  });
  Future<void> invalidateCache({String? reason});
  Stream<Map<String, dynamic>> getStatisticsStream();
}

/// Interface for sharing services
abstract class IShareService {
  Future<void> shareGoogleDriveLink(
    DocumentModel document, {
    Function(double progress)? onProgress,
    String? customMessage,
  });

  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
    Function(double progress)? onProgress,
  });

  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
    Function(int completed, int total, String currentFile)? onProgress,
  });
}

/// Interface for file operations
abstract class IFileOperationService {
  Future<void> downloadFile(DocumentModel document);
  Future<void> deleteFile(DocumentModel document);
  Future<void> restoreFile(DocumentModel document);
}

/// Interface for navigation services
abstract class INavigationService {
  void navigateToFilePreview(DocumentModel document);
  void navigateToProfile();
  void navigateToCategory(String categoryId);
  void showDocumentMenu(DocumentModel document);
}
