import 'package:flutter/material.dart';
import '../interfaces/segregated_interfaces.dart';
import '../services/greeting_service.dart';
import '../../services/optimized_statistics_service.dart';
import '../../services/share_service.dart';
import '../../services/file_download_service.dart';
import '../../models/document_model.dart';
import '../constants/app_routes.dart';

// ============================================================================
// GREETING IMPLEMENTATIONS
// ============================================================================

/// Concrete implementation of greeting interfaces
class GreetingServiceProvider implements 
    IGreetingProvider, 
    ISmartGreetingProvider, 
    IMotivationalGreetingProvider {
  
  final GreetingService _greetingService = GreetingService.instance;

  @override
  String getPersonalizedGreeting(String? userName) {
    return _greetingService.getPersonalizedGreeting(userName);
  }

  @override
  String getMainGreeting() {
    return _greetingService.getMainGreeting();
  }

  @override
  GreetingSet getSmartGreeting(String? userName) {
    return _greetingService.getSmartGreeting(userName);
  }

  @override
  GreetingSet getGreetingWithMotivation(String? userName) {
    return _greetingService.getGreetingWithMotivation(userName);
  }

  @override
  String getMotivationalQuote() {
    return _greetingService.getMotivationalQuote();
  }
}

// ============================================================================
// STATISTICS IMPLEMENTATIONS
// ============================================================================

/// Concrete implementation of statistics interfaces
class StatisticsServiceProvider implements 
    IStatisticsProvider, 
    IStatisticsCacheManager, 
    IRealtimeStatisticsProvider {
  
  final OptimizedStatisticsService _statisticsService = OptimizedStatisticsService.instance;

  @override
  Future<Map<String, dynamic>> getAggregatedStatistics({bool forceRefresh = false}) {
    return _statisticsService.getAggregatedStatistics(forceRefresh: forceRefresh);
  }

  @override
  Future<void> invalidateCache({String? reason}) {
    return _statisticsService.invalidateCache(reason: reason);
  }

  @override
  bool isCacheValid() {
    // Implementation would check cache validity
    return true; // Placeholder
  }

  @override
  Stream<Map<String, dynamic>> getStatisticsStream() {
    return _statisticsService.getStatisticsStream();
  }

  @override
  Future<void> subscribeToRealtimeUpdates() async {
    // Implementation would subscribe to real-time updates
    await _statisticsService.initializeRealTimeSync();
  }
}

// ============================================================================
// SHARING IMPLEMENTATIONS
// ============================================================================

/// Concrete implementation of sharing interfaces
class SharingServiceProvider implements 
    IFileSharer, 
    IGoogleDriveSharer, 
    IBulkSharer, 
    ILinkSharer {
  
  final ShareService _shareService = ShareService();

  @override
  Future<void> shareFile(DocumentModel document) {
    return shareGoogleDriveLink(document);
  }

  @override
  Future<void> shareGoogleDriveLink(
    DocumentModel document, {
    Function(double progress)? onProgress,
    String? customMessage,
  }) {
    return _shareService.shareGoogleDriveLink(
      document,
      onProgress: onProgress,
      customMessage: customMessage,
    );
  }

  @override
  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
    Function(int completed, int total, String currentFile)? onProgress,
  }) {
    return _shareService.shareBulkFiles(
      documents: documents,
      linkExpiration: linkExpiration,
      customMessage: customMessage,
      onProgress: onProgress,
    );
  }

  @override
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
    Function(double progress)? onProgress,
  }) {
    return _shareService.shareFileWithLink(
      document: document,
      linkExpiration: linkExpiration,
      customMessage: customMessage,
      onProgress: onProgress,
    );
  }
}

// ============================================================================
// FILE OPERATION IMPLEMENTATIONS
// ============================================================================

/// Concrete implementation of file operation interfaces
class FileOperationServiceProvider implements 
    IFileDownloader, 
    IFileDeleter, 
    IFileRestorer, 
    IFileMetadataManager {
  
  final FileDownloadService _downloadService = FileDownloadService();

  @override
  Future<void> downloadFile(DocumentModel document) {
    return _downloadService.downloadFile(document);
  }

  @override
  Future<void> downloadMultipleFiles(List<DocumentModel> documents) async {
    for (final document in documents) {
      await downloadFile(document);
    }
  }

  @override
  Future<void> deleteFile(DocumentModel document) async {
    // Implementation would handle file deletion
    throw UnimplementedError('Delete file not implemented yet');
  }

  @override
  Future<void> permanentlyDeleteFile(DocumentModel document) async {
    // Implementation would handle permanent file deletion
    throw UnimplementedError('Permanently delete file not implemented yet');
  }

  @override
  Future<void> restoreFile(DocumentModel document) async {
    // Implementation would handle file restoration
    throw UnimplementedError('Restore file not implemented yet');
  }

  @override
  Future<void> restoreMultipleFiles(List<DocumentModel> documents) async {
    for (final document in documents) {
      await restoreFile(document);
    }
  }

  @override
  Future<void> updateFileMetadata(DocumentModel document, Map<String, dynamic> metadata) async {
    // Implementation would update file metadata
    throw UnimplementedError('Update file metadata not implemented yet');
  }

  @override
  Future<Map<String, dynamic>> getFileMetadata(String fileId) async {
    // Implementation would get file metadata
    throw UnimplementedError('Get file metadata not implemented yet');
  }
}

// ============================================================================
// NAVIGATION IMPLEMENTATIONS
// ============================================================================

/// Concrete implementation of navigation interfaces
class NavigationServiceProvider implements 
    INavigator, 
    IFileNavigator, 
    IUserNavigator, 
    ICategoryNavigator, 
    IModalManager {
  
  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }

  BuildContext get context {
    if (_context == null) {
      throw Exception('Navigation context not set. Call setContext() first.');
    }
    return _context!;
  }

  @override
  void navigateToRoute(String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  @override
  void navigateBack() {
    Navigator.pop(context);
  }

  @override
  void navigateToFilePreview(DocumentModel document) {
    navigateToRoute(AppRoutes.filePreview, arguments: document);
  }

  @override
  void navigateToFileEdit(DocumentModel document) {
    // Implementation would navigate to file edit screen
    throw UnimplementedError('Navigate to file edit not implemented yet');
  }

  @override
  void navigateToProfile() {
    navigateToRoute(AppRoutes.profile);
  }

  @override
  void navigateToUserManagement() {
    navigateToRoute(AppRoutes.userManagement);
  }

  @override
  void navigateToCategory(String categoryId) {
    navigateToRoute(AppRoutes.manageCategories, arguments: categoryId);
  }

  @override
  void navigateToManageCategories() {
    navigateToRoute(AppRoutes.manageCategories);
  }

  @override
  void showDocumentMenu(DocumentModel document) {
    showModalBottomSheet(
      context: context,
      builder: (context) => DocumentMenuBottomSheet(document: document),
    );
  }

  @override
  void showConfirmationDialog(String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  void showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Document menu bottom sheet widget
class DocumentMenuBottomSheet extends StatelessWidget {
  final DocumentModel document;

  const DocumentMenuBottomSheet({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.visibility),
            title: const Text('Preview'),
            onTap: () {
              Navigator.pop(context);
              // Handle preview
            },
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Download'),
            onTap: () {
              Navigator.pop(context);
              // Handle download
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share'),
            onTap: () {
              Navigator.pop(context);
              // Handle share
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Delete'),
            onTap: () {
              Navigator.pop(context);
              // Handle delete
            },
          ),
        ],
      ),
    );
  }
}
