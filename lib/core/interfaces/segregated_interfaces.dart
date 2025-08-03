import 'package:flutter/material.dart';
import '../services/greeting_service.dart';
import '../../models/document_model.dart';

/// Interface Segregation Principle Implementation
/// Breaking down large interfaces into smaller, focused ones

// ============================================================================
// GREETING INTERFACES
// ============================================================================

/// Interface for basic greeting functionality
abstract class IGreetingProvider {
  String getPersonalizedGreeting(String? userName);
  String getMainGreeting();
}

/// Interface for smart greeting functionality
abstract class ISmartGreetingProvider {
  GreetingSet getSmartGreeting(String? userName);
}

/// Interface for motivational greeting functionality
abstract class IMotivationalGreetingProvider {
  GreetingSet getGreetingWithMotivation(String? userName);
  String getMotivationalQuote();
}

// ============================================================================
// STATISTICS INTERFACES
// ============================================================================

/// Interface for basic statistics retrieval
abstract class IStatisticsProvider {
  Future<Map<String, dynamic>> getAggregatedStatistics({
    bool forceRefresh = false,
  });
}

/// Interface for statistics caching
abstract class IStatisticsCacheManager {
  Future<void> invalidateCache({String? reason});
  bool isCacheValid();
}

/// Interface for real-time statistics
abstract class IRealtimeStatisticsProvider {
  Stream<Map<String, dynamic>> getStatisticsStream();
  Future<void> subscribeToRealtimeUpdates();
}

// ============================================================================
// SHARING INTERFACES
// ============================================================================

/// Interface for basic file sharing
abstract class IFileSharer {
  Future<void> shareFile(DocumentModel document);
}

/// Interface for Google Drive sharing
abstract class IGoogleDriveSharer {
  Future<void> shareGoogleDriveLink(
    DocumentModel document, {
    Function(double progress)? onProgress,
    String? customMessage,
  });
}

/// Interface for bulk sharing operations
abstract class IBulkSharer {
  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
    Function(int completed, int total, String currentFile)? onProgress,
  });
}

/// Interface for link-based sharing
abstract class ILinkSharer {
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
    Function(double progress)? onProgress,
  });
}

// ============================================================================
// FILE OPERATION INTERFACES
// ============================================================================

/// Interface for file download operations
abstract class IFileDownloader {
  Future<void> downloadFile(DocumentModel document);
  Future<void> downloadMultipleFiles(List<DocumentModel> documents);
}

/// Interface for file deletion operations
abstract class IFileDeleter {
  Future<void> deleteFile(DocumentModel document);
  Future<void> permanentlyDeleteFile(DocumentModel document);
}

/// Interface for file restoration operations
abstract class IFileRestorer {
  Future<void> restoreFile(DocumentModel document);
  Future<void> restoreMultipleFiles(List<DocumentModel> documents);
}

/// Interface for file metadata operations
abstract class IFileMetadataManager {
  Future<void> updateFileMetadata(
    DocumentModel document,
    Map<String, dynamic> metadata,
  );
  Future<Map<String, dynamic>> getFileMetadata(String fileId);
}

// ============================================================================
// NAVIGATION INTERFACES
// ============================================================================

/// Interface for basic navigation
abstract class INavigator {
  void navigateToRoute(String route, {Object? arguments});
  void navigateBack();
}

/// Interface for file-specific navigation
abstract class IFileNavigator {
  void navigateToFilePreview(DocumentModel document);
  void navigateToFileEdit(DocumentModel document);
}

/// Interface for user-specific navigation
abstract class IUserNavigator {
  void navigateToProfile();
  void navigateToUserManagement();
}

/// Interface for category-specific navigation
abstract class ICategoryNavigator {
  void navigateToCategory(String categoryId);
  void navigateToManageCategories();
}

/// Interface for modal operations
abstract class IModalManager {
  void showDocumentMenu(DocumentModel document);
  void showConfirmationDialog(
    String title,
    String message,
    VoidCallback onConfirm,
  );
  void showErrorDialog(String title, String message);
}

// ============================================================================
// SEARCH AND FILTER INTERFACES
// ============================================================================

/// Interface for search functionality
abstract class ISearchProvider {
  Future<List<DocumentModel>> searchDocuments(String query);
  Stream<List<DocumentModel>> getSearchStream(String query);
}

/// Interface for filter functionality
abstract class IFilterProvider {
  Future<List<DocumentModel>> filterDocuments(Map<String, dynamic> filters);
  List<String> getAvailableFilters();
}

/// Interface for sorting functionality
abstract class ISortProvider {
  List<DocumentModel> sortDocuments(
    List<DocumentModel> documents,
    String sortBy,
    bool ascending,
  );
  List<String> getAvailableSortOptions();
}

// ============================================================================
// NOTIFICATION INTERFACES
// ============================================================================

/// Interface for notification display
abstract class INotificationDisplayer {
  void showSuccessNotification(String message);
  void showErrorNotification(String message);
  void showInfoNotification(String message);
}

/// Interface for notification management
abstract class INotificationManager {
  Future<void> scheduleNotification(
    String title,
    String body,
    DateTime scheduledTime,
  );
  Future<void> cancelNotification(String notificationId);
  Future<List<String>> getPendingNotifications();
}

// ============================================================================
// CALLBACK INTERFACES
// ============================================================================

/// Interface for progress callbacks
abstract class IProgressCallback {
  void onProgress(double progress);
  void onComplete();
  void onError(String error);
}

/// Interface for lifecycle callbacks
abstract class ILifecycleCallback {
  void onInitialize();
  void onDispose();
  void onPause();
  void onResume();
}
