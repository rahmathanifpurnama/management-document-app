import 'package:flutter/foundation.dart';
import '../utils/filename_utils.dart';
import '../models/document_model.dart';

/// Service to handle consistent filename display across the application
/// 
/// This service ensures that users see clean, readable filenames while
/// maintaining the timestamp-based storage paths for uniqueness
class FilenameDisplayService {
  
  /// Get display filename for a document
  /// 
  /// This is the primary method for showing filenames to users
  static String getDisplayName(DocumentModel document) {
    try {
      // First try to get clean display name from fileName field
      if (document.fileName.isNotEmpty) {
        final cleanName = FilenameUtils.getDisplayFileName(document.fileName);
        if (cleanName != document.fileName) {
          // fileName already contains timestamp, clean it
          return cleanName;
        }
        // fileName is already clean
        return document.fileName;
      }
      
      // Fallback to extracting from filePath
      if (document.filePath.isNotEmpty) {
        return FilenameUtils.getDisplayFileName(document.filePath);
      }
      
      // Last resort fallback
      return 'Unknown File';
    } catch (e) {
      debugPrint('❌ Error getting display name for document ${document.id}: $e');
      return 'Unknown File';
    }
  }
  
  /// Get user-friendly display name for UI
  /// 
  /// Converts technical filenames to readable format
  static String getUserFriendlyName(DocumentModel document) {
    try {
      final displayName = getDisplayName(document);
      return FilenameUtils.getUserFriendlyName(displayName);
    } catch (e) {
      debugPrint('❌ Error getting user-friendly name for document ${document.id}: $e');
      return getDisplayName(document);
    }
  }
  
  /// Get filename for search and filtering
  /// 
  /// Returns clean filename suitable for search operations
  static String getSearchableName(DocumentModel document) {
    final displayName = getDisplayName(document);
    return displayName.toLowerCase().replaceAll(RegExp(r'[^\w\s\.]'), ' ');
  }
  
  /// Check if document filename needs cleaning
  /// 
  /// Useful for identifying documents that were created with timestamp prefixes
  static bool needsCleaning(DocumentModel document) {
    return FilenameUtils.hasTimestampPrefix(document.fileName);
  }
  
  /// Get storage filename (with timestamp)
  /// 
  /// Returns the actual storage filename for backend operations
  static String getStorageName(DocumentModel document) {
    // For storage operations, use the filePath or fileName as-is
    if (document.filePath.isNotEmpty) {
      return document.filePath.split('/').last;
    }
    return document.fileName;
  }
  
  /// Format filename for display with length limit
  /// 
  /// Truncates long filenames intelligently for UI display
  static String formatForDisplay(DocumentModel document, {int? maxLength}) {
    final displayName = getDisplayName(document);
    
    if (maxLength == null) return displayName;
    
    return FilenameUtils.formatForDisplay(displayName, maxLength: maxLength);
  }
  
  /// Get file extension from document
  /// 
  /// Returns clean file extension for display
  static String getFileExtension(DocumentModel document) {
    final displayName = getDisplayName(document);
    return FilenameUtils.getFileExtension(displayName);
  }
  
  /// Get filename without extension
  /// 
  /// Returns clean filename without extension for display
  static String getNameWithoutExtension(DocumentModel document) {
    final displayName = getDisplayName(document);
    return FilenameUtils.getFileNameWithoutExtension(displayName);
  }
  
  /// Batch process multiple documents for display
  /// 
  /// Efficiently processes multiple documents for list display
  static Map<String, String> batchGetDisplayNames(List<DocumentModel> documents) {
    final result = <String, String>{};
    
    for (final document in documents) {
      try {
        result[document.id] = getDisplayName(document);
      } catch (e) {
        debugPrint('❌ Error processing document ${document.id} in batch: $e');
        result[document.id] = 'Unknown File';
      }
    }
    
    return result;
  }
  
  /// Get filename statistics for debugging
  /// 
  /// Returns information about filename patterns in a list of documents
  static Map<String, dynamic> getFilenameStats(List<DocumentModel> documents) {
    int withTimestamp = 0;
    int withoutTimestamp = 0;
    int longNames = 0;
    final extensions = <String, int>{};
    
    for (final document in documents) {
      if (needsCleaning(document)) {
        withTimestamp++;
      } else {
        withoutTimestamp++;
      }
      
      final displayName = getDisplayName(document);
      if (displayName.length > 50) {
        longNames++;
      }
      
      final extension = getFileExtension(document);
      extensions[extension] = (extensions[extension] ?? 0) + 1;
    }
    
    return {
      'total': documents.length,
      'withTimestamp': withTimestamp,
      'withoutTimestamp': withoutTimestamp,
      'longNames': longNames,
      'extensions': extensions,
    };
  }
}
