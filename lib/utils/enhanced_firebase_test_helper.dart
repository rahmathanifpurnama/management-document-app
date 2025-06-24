import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import '../providers/document_provider.dart';
import '../services/enhanced_auth_service.dart';
import '../services/enhanced_document_service.dart';
import '../services/enhanced_firebase_storage_service.dart';

/// Helper class for testing Enhanced Firebase Providers in the app
class EnhancedFirebaseTestHelper {
  /// Test all enhanced features with UI context
  static Future<Map<String, dynamic>> runComprehensiveTest(
    BuildContext context,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('🧪 Starting Enhanced Firebase Providers Test...');

      // Get providers
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      // Test 1: Authentication and Permissions
      results['auth'] = await _testAuthentication(authProvider);

      // Test 2: Document Operations
      results['documents'] = await _testDocumentOperations(
        documentProvider,
        authProvider,
      );

      // Test 3: Storage Operations
      results['storage'] = await _testStorageOperations(
        documentProvider,
        authProvider,
      );

      // Test 4: Admin Features
      results['admin'] = await _testAdminFeatures(
        authProvider,
        documentProvider,
      );

      // Test 5: Performance
      results['performance'] = await _testPerformance(documentProvider);

      results['overall'] = 'SUCCESS';
      results['timestamp'] = DateTime.now().toIso8601String();

      debugPrint('✅ Enhanced Firebase Providers Test Completed Successfully');
    } catch (e) {
      results['overall'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Enhanced Firebase Providers Test Failed: $e');
    }

    return results;
  }

  /// Test authentication and permission system
  static Future<Map<String, dynamic>> _testAuthentication(
    AuthProvider authProvider,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('🔐 Testing Authentication...');

      // Basic auth checks
      results['isLoggedIn'] = authProvider.isLoggedIn;
      results['currentUser'] = authProvider.currentUser?.email ?? 'No user';
      results['isAdmin'] = await authProvider.isCurrentUserAdmin;

      // Permission checks
      results['canUpload'] = await authProvider.canUploadFiles();
      results['canDelete'] = await authProvider.canDeleteFiles();
      results['canManageUsers'] = await authProvider.canManageUsers();
      results['canViewAnalytics'] = await authProvider.canViewAnalytics();
      results['canUnlimitedQueries'] = await authProvider
          .canPerformUnlimitedQueries();
      results['canStorageManagement'] = await authProvider
          .canAccessStorageManagement();

      // Get permission summary
      final summary = await authProvider.getCurrentUserPermissionSummary();
      results['permissionSummary'] = summary;

      results['status'] = 'SUCCESS';
      debugPrint('✅ Authentication test completed');
    } catch (e) {
      results['status'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Authentication test failed: $e');
    }

    return results;
  }

  /// Test document operations
  static Future<Map<String, dynamic>> _testDocumentOperations(
    DocumentProvider documentProvider,
    AuthProvider authProvider,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('📄 Testing Document Operations...');

      // Basic document info
      results['totalDocuments'] = documentProvider.totalDocumentsCount;
      results['filteredDocuments'] = documentProvider.documents.length;
      results['canUseUnlimited'] =
          await documentProvider.canUseUnlimitedQueries;

      // Test unlimited queries if available
      if (await authProvider.canPerformUnlimitedQueries()) {
        debugPrint('🔓 Testing unlimited queries...');

        final startTime = DateTime.now();
        await documentProvider.loadAllDocumentsUnlimited();
        final endTime = DateTime.now();

        results['unlimitedQueryTime'] = endTime
            .difference(startTime)
            .inMilliseconds;
        results['unlimitedQueryCount'] = documentProvider.totalDocumentsCount;
        results['unlimitedQueryStatus'] = 'SUCCESS';

        // Test statistics
        final stats = await documentProvider.getDocumentStatistics();
        results['statistics'] = stats;
      } else {
        results['unlimitedQueryStatus'] = 'SKIPPED - Not admin user';
      }

      // Test regular document loading
      final startTime = DateTime.now();
      await documentProvider.loadDocuments();
      final endTime = DateTime.now();

      results['regularQueryTime'] = endTime
          .difference(startTime)
          .inMilliseconds;
      results['regularQueryCount'] = documentProvider.documents.length;

      results['status'] = 'SUCCESS';
      debugPrint('✅ Document operations test completed');
    } catch (e) {
      results['status'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Document operations test failed: $e');
    }

    return results;
  }

  /// Test storage operations
  static Future<Map<String, dynamic>> _testStorageOperations(
    DocumentProvider documentProvider,
    AuthProvider authProvider,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('📁 Testing Storage Operations...');

      results['canManageStorage'] = await documentProvider.canManageStorage;

      if (await authProvider.canAccessStorageManagement()) {
        debugPrint('🔓 Testing storage management...');

        // Test storage file loading
        final startTime = DateTime.now();
        await documentProvider.loadDocumentsFromStorageUnlimited();
        final endTime = DateTime.now();

        results['storageLoadTime'] = endTime
            .difference(startTime)
            .inMilliseconds;
        results['storageLoadStatus'] = 'SUCCESS';

        // Test URL refresh
        final refreshStartTime = DateTime.now();
        await documentProvider.refreshAllDownloadUrls();
        final refreshEndTime = DateTime.now();

        results['urlRefreshTime'] = refreshEndTime
            .difference(refreshStartTime)
            .inMilliseconds;
        results['urlRefreshStatus'] = 'SUCCESS';
      } else {
        results['storageLoadStatus'] = 'SKIPPED - No storage management access';
        results['urlRefreshStatus'] = 'SKIPPED - No storage management access';
      }

      results['status'] = 'SUCCESS';
      debugPrint('✅ Storage operations test completed');
    } catch (e) {
      results['status'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Storage operations test failed: $e');
    }

    return results;
  }

  /// Test admin-specific features
  static Future<Map<String, dynamic>> _testAdminFeatures(
    AuthProvider authProvider,
    DocumentProvider documentProvider,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('👑 Testing Admin Features...');

      if (!(await authProvider.isCurrentUserAdmin)) {
        results['status'] = 'SKIPPED - Not admin user';
        return results;
      }

      // Test enhanced services directly
      final enhancedAuth = EnhancedAuthService.instance;
      final enhancedDoc = EnhancedDocumentService.instance;
      final enhancedStorage = EnhancedFirebaseStorageService.instance;

      // Test admin capabilities
      results['canPerformUnlimitedQueries'] = await enhancedAuth
          .canPerformUnlimitedQueries();
      results['canAccessStorageManagement'] = await enhancedAuth
          .canAccessStorageManagement();
      results['canManageUsers'] = await enhancedAuth.canManageUsers();
      results['canViewAnalytics'] = await enhancedAuth.canViewAnalytics();

      // Test unlimited document operations
      final totalCount = await enhancedDoc.getTotalDocumentCount();
      results['totalDocumentCount'] = totalCount;

      // Test storage statistics
      final storageStats = await enhancedStorage.getStorageStatistics();
      results['storageStatistics'] = storageStats;

      // Test permission management
      await enhancedAuth.refreshCurrentUserPermissions();
      results['permissionRefreshStatus'] = 'SUCCESS';

      results['status'] = 'SUCCESS';
      debugPrint('✅ Admin features test completed');
    } catch (e) {
      results['status'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Admin features test failed: $e');
    }

    return results;
  }

  /// Test performance metrics
  static Future<Map<String, dynamic>> _testPerformance(
    DocumentProvider documentProvider,
  ) async {
    final results = <String, dynamic>{};

    try {
      debugPrint('⚡ Testing Performance...');

      // Test search performance
      final searchStartTime = DateTime.now();
      documentProvider.searchDocuments('test');
      final searchEndTime = DateTime.now();

      results['searchTime'] = searchEndTime
          .difference(searchStartTime)
          .inMilliseconds;

      // Test filter performance
      final filterStartTime = DateTime.now();
      documentProvider.filterByCategory('general');
      final filterEndTime = DateTime.now();

      results['filterTime'] = filterEndTime
          .difference(filterStartTime)
          .inMilliseconds;

      // Test sort performance
      final sortStartTime = DateTime.now();
      documentProvider.sortDocuments('fileName');
      final sortEndTime = DateTime.now();

      results['sortTime'] = sortEndTime
          .difference(sortStartTime)
          .inMilliseconds;

      // Memory usage (approximate)
      results['documentCount'] = documentProvider.totalDocumentsCount;
      results['filteredCount'] = documentProvider.documents.length;

      results['status'] = 'SUCCESS';
      debugPrint('✅ Performance test completed');
    } catch (e) {
      results['status'] = 'FAILED';
      results['error'] = e.toString();
      debugPrint('❌ Performance test failed: $e');
    }

    return results;
  }

  /// Generate test report
  static String generateTestReport(Map<String, dynamic> results) {
    final buffer = StringBuffer();

    buffer.writeln('🔥 Enhanced Firebase Providers Test Report');
    buffer.writeln('=' * 50);
    buffer.writeln('Timestamp: ${results['timestamp']}');
    buffer.writeln('Overall Status: ${results['overall']}');
    buffer.writeln();

    // Authentication results
    if (results['auth'] != null) {
      final auth = results['auth'] as Map<String, dynamic>;
      buffer.writeln('🔐 Authentication Test:');
      buffer.writeln('  Status: ${auth['status']}');
      buffer.writeln('  User: ${auth['currentUser']}');
      buffer.writeln('  Is Admin: ${auth['isAdmin']}');
      buffer.writeln('  Can Unlimited Queries: ${auth['canUnlimitedQueries']}');
      buffer.writeln(
        '  Can Storage Management: ${auth['canStorageManagement']}',
      );
      buffer.writeln();
    }

    // Document results
    if (results['documents'] != null) {
      final docs = results['documents'] as Map<String, dynamic>;
      buffer.writeln('📄 Document Operations Test:');
      buffer.writeln('  Status: ${docs['status']}');
      buffer.writeln('  Total Documents: ${docs['totalDocuments']}');
      buffer.writeln('  Regular Query Time: ${docs['regularQueryTime']}ms');
      if (docs['unlimitedQueryTime'] != null) {
        buffer.writeln(
          '  Unlimited Query Time: ${docs['unlimitedQueryTime']}ms',
        );
        buffer.writeln(
          '  Unlimited Query Count: ${docs['unlimitedQueryCount']}',
        );
      }
      buffer.writeln();
    }

    // Storage results
    if (results['storage'] != null) {
      final storage = results['storage'] as Map<String, dynamic>;
      buffer.writeln('📁 Storage Operations Test:');
      buffer.writeln('  Status: ${storage['status']}');
      buffer.writeln('  Can Manage Storage: ${storage['canManageStorage']}');
      if (storage['storageLoadTime'] != null) {
        buffer.writeln('  Storage Load Time: ${storage['storageLoadTime']}ms');
      }
      if (storage['urlRefreshTime'] != null) {
        buffer.writeln('  URL Refresh Time: ${storage['urlRefreshTime']}ms');
      }
      buffer.writeln();
    }

    // Admin results
    if (results['admin'] != null) {
      final admin = results['admin'] as Map<String, dynamic>;
      buffer.writeln('👑 Admin Features Test:');
      buffer.writeln('  Status: ${admin['status']}');
      if (admin['totalDocumentCount'] != null) {
        buffer.writeln(
          '  Total Document Count: ${admin['totalDocumentCount']}',
        );
      }
      buffer.writeln();
    }

    // Performance results
    if (results['performance'] != null) {
      final perf = results['performance'] as Map<String, dynamic>;
      buffer.writeln('⚡ Performance Test:');
      buffer.writeln('  Status: ${perf['status']}');
      buffer.writeln('  Search Time: ${perf['searchTime']}ms');
      buffer.writeln('  Filter Time: ${perf['filterTime']}ms');
      buffer.writeln('  Sort Time: ${perf['sortTime']}ms');
      buffer.writeln();
    }

    buffer.writeln('=' * 50);

    return buffer.toString();
  }

  /// Show test results in a dialog
  static void showTestResults(
    BuildContext context,
    Map<String, dynamic> results,
  ) {
    final report = generateTestReport(results);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enhanced Firebase Providers Test Results'),
        content: SingleChildScrollView(
          child: Text(
            report,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
