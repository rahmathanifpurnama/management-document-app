import 'package:flutter/foundation.dart';
import '../services/direct_storage_deletion_service.dart';

/// Example usage of DirectStorageDeletionService
/// 
/// This file demonstrates how to use the standalone storage deletion service
/// that bypasses Firestore and works directly with Firebase Storage.
class DirectStorageDeletionExample {
  final DirectStorageDeletionService _deletionService = 
      DirectStorageDeletionService.instance;

  /// Example 1: Delete a single file by its storage path
  Future<void> deleteSingleFileExample() async {
    try {
      debugPrint('📝 Example 1: Delete single file by path');

      // Example storage path - replace with actual path from your storage
      const storagePath = 'documents/user123/sample-document.pdf';

      final result = await _deletionService.deleteFileByPath(storagePath);

      if (result.success) {
        debugPrint('✅ File deleted successfully: ${result.message}');
        debugPrint('📄 File: ${result.fileName}');
        debugPrint('📏 Size: ${result.fileSize} bytes');
      } else {
        debugPrint('❌ Deletion failed: ${result.message}');
        debugPrint('🔍 Error code: ${result.errorCode}');
      }

    } catch (e) {
      debugPrint('❌ Example 1 failed: $e');
    }
  }

  /// Example 2: Delete multiple files by their storage paths
  Future<void> deleteMultipleFilesExample() async {
    try {
      debugPrint('📝 Example 2: Delete multiple files by paths');

      // Example storage paths - replace with actual paths from your storage
      const storagePaths = [
        'documents/user123/file1.pdf',
        'documents/user123/file2.docx',
        'documents/user456/file3.jpg',
      ];

      final result = await _deletionService.deleteMultipleFilesByPath(
        storagePaths,
        continueOnError: true, // Continue even if some files fail
      );

      debugPrint('📊 Batch deletion results:');
      debugPrint('   Total files: ${result.totalFiles}');
      debugPrint('   Successful: ${result.successCount}');
      debugPrint('   Failed: ${result.failureCount}');
      debugPrint('   Completed: ${result.completed}');

      // Show details for each file
      for (final fileResult in result.results) {
        if (fileResult.success) {
          debugPrint('✅ ${fileResult.fileName}: ${fileResult.message}');
        } else {
          debugPrint('❌ ${fileResult.path}: ${fileResult.message}');
        }
      }

    } catch (e) {
      debugPrint('❌ Example 2 failed: $e');
    }
  }

  /// Example 3: Delete files by filename pattern
  Future<void> deleteFilesByPatternExample() async {
    try {
      debugPrint('📝 Example 3: Delete files by filename pattern');

      // Search for files containing "temp" in their name
      const filenamePattern = 'temp';
      const searchPath = 'documents'; // Search in documents folder

      final result = await _deletionService.deleteFilesByPattern(
        filenamePattern,
        searchPath: searchPath,
        exactMatch: false, // Partial match
      );

      debugPrint('🔍 Pattern deletion results for "$filenamePattern":');
      debugPrint('   Total files found: ${result.totalFiles}');
      debugPrint('   Successfully deleted: ${result.successCount}');
      debugPrint('   Failed to delete: ${result.failureCount}');

      // Show which files were found and deleted
      for (final fileResult in result.results) {
        debugPrint('📄 ${fileResult.path}: ${fileResult.success ? "✅" : "❌"}');
      }

    } catch (e) {
      debugPrint('❌ Example 3 failed: $e');
    }
  }

  /// Example 4: Get file information without deleting
  Future<void> getFileInfoExample() async {
    try {
      debugPrint('📝 Example 4: Get file information');

      const storagePath = 'documents/user123/sample-document.pdf';

      final fileInfo = await _deletionService.getFileInfo(storagePath);

      if (fileInfo.success) {
        debugPrint('📄 File Information:');
        debugPrint('   Name: ${fileInfo.name}');
        debugPrint('   Size: ${fileInfo.formattedSize}');
        debugPrint('   Type: ${fileInfo.contentType}');
        debugPrint('   Created: ${fileInfo.timeCreated}');
        debugPrint('   Path: ${fileInfo.path}');
        
        if (fileInfo.customMetadata?.isNotEmpty == true) {
          debugPrint('   Metadata: ${fileInfo.customMetadata}');
        }
      } else {
        debugPrint('❌ Failed to get file info: ${fileInfo.message}');
        debugPrint('🔍 Error code: ${fileInfo.errorCode}');
      }

    } catch (e) {
      debugPrint('❌ Example 4 failed: $e');
    }
  }

  /// Example 5: Handle different error scenarios
  Future<void> errorHandlingExample() async {
    try {
      debugPrint('📝 Example 5: Error handling scenarios');

      // Test with non-existent file
      debugPrint('🔍 Testing with non-existent file...');
      final nonExistentResult = await _deletionService.deleteFileByPath(
        'documents/non-existent-file.pdf'
      );
      debugPrint('Result: ${nonExistentResult.success ? "Success" : "Failed"}');
      debugPrint('Message: ${nonExistentResult.message}');
      debugPrint('Error Code: ${nonExistentResult.errorCode}');

      // Test with invalid path
      debugPrint('\n🔍 Testing with invalid path...');
      final invalidPathResult = await _deletionService.deleteFileByPath(
        '/invalid/path/../file.pdf'
      );
      debugPrint('Result: ${invalidPathResult.success ? "Success" : "Failed"}');
      debugPrint('Message: ${invalidPathResult.message}');
      debugPrint('Error Code: ${invalidPathResult.errorCode}');

      // Test with empty path
      debugPrint('\n🔍 Testing with empty path...');
      final emptyPathResult = await _deletionService.deleteFileByPath('');
      debugPrint('Result: ${emptyPathResult.success ? "Success" : "Failed"}');
      debugPrint('Message: ${emptyPathResult.message}');
      debugPrint('Error Code: ${emptyPathResult.errorCode}');

    } catch (e) {
      debugPrint('❌ Example 5 failed: $e');
    }
  }

  /// Run all examples
  Future<void> runAllExamples() async {
    debugPrint('🚀 Starting Direct Storage Deletion Examples');
    debugPrint('=' * 50);

    await deleteSingleFileExample();
    debugPrint('\n' + '=' * 50);

    await deleteMultipleFilesExample();
    debugPrint('\n' + '=' * 50);

    await deleteFilesByPatternExample();
    debugPrint('\n' + '=' * 50);

    await getFileInfoExample();
    debugPrint('\n' + '=' * 50);

    await errorHandlingExample();
    debugPrint('\n' + '=' * 50);

    debugPrint('✅ All examples completed');
  }
}

/// Utility class for common storage path operations
class StoragePathUtils {
  /// Extract filename from storage path
  static String getFileName(String storagePath) {
    return storagePath.split('/').last;
  }

  /// Extract directory path from storage path
  static String getDirectoryPath(String storagePath) {
    final parts = storagePath.split('/');
    if (parts.length <= 1) return '';
    return parts.sublist(0, parts.length - 1).join('/');
  }

  /// Check if path is in documents folder
  static bool isInDocumentsFolder(String storagePath) {
    return storagePath.startsWith('documents/');
  }

  /// Get user ID from storage path (if following user-based structure)
  static String? getUserIdFromPath(String storagePath) {
    if (!isInDocumentsFolder(storagePath)) return null;
    
    final parts = storagePath.split('/');
    if (parts.length >= 2) {
      return parts[1]; // Assuming structure: documents/userId/filename
    }
    return null;
  }

  /// Build storage path for user document
  static String buildUserDocumentPath(String userId, String fileName) {
    return 'documents/$userId/$fileName';
  }

  /// Validate storage path format
  static bool isValidStoragePath(String storagePath) {
    if (storagePath.isEmpty) return false;
    if (storagePath.startsWith('/') || storagePath.endsWith('/')) return false;
    if (storagePath.contains('..')) return false;
    if (!storagePath.contains('.')) return false; // Should have file extension
    return true;
  }
}
