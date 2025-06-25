import 'package:flutter/material.dart';

/// Utility class for handling filename operations and display formatting
///
/// This utility provides clean filename handling without timestamp prefixes
/// for better user experience and simplified file management.
class FilenameUtils {
  /// Get clean display filename from storage path
  ///
  /// Simply extracts filename from path without timestamp processing
  /// Example: "documents/user123/document.pdf" -> "document.pdf"
  static String getDisplayFileName(String storageFileName) {
    if (storageFileName.isEmpty) return '';

    // Extract just the filename from full path
    final fileName = storageFileName.split('/').last;

    // Return the filename as-is (no timestamp processing needed)
    return fileName;
  }

  /// Get user-friendly display name for UI
  ///
  /// Converts storage filename to a clean, readable format
  /// Example: "penerapan_cnn_untuk_identifikasi.pdf" -> "Penerapan CNN Untuk Identifikasi.pdf"
  static String getUserFriendlyName(String storageFileName) {
    final cleanName = getDisplayFileName(storageFileName);

    // Split filename and extension
    final parts = cleanName.split('.');
    final extension = parts.length > 1 ? parts.last : '';
    final nameWithoutExt = parts.length > 1
        ? parts.sublist(0, parts.length - 1).join('.')
        : cleanName;

    // Convert underscores to spaces and capitalize words
    final friendlyName = nameWithoutExt
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
              : word,
        )
        .join(' ')
        .trim();

    return extension.isNotEmpty ? '$friendlyName.$extension' : friendlyName;
  }

  /// Generate storage path without timestamp
  ///
  /// Creates clean storage paths using original filename
  static String generateStoragePath({
    required String originalFileName,
    required String userId,
    String? categoryId,
  }) {
    final sanitizedFileName = _sanitizeFileName(originalFileName);

    if (categoryId != null && categoryId.isNotEmpty) {
      return 'documents/categories/$categoryId/$sanitizedFileName';
    } else {
      return 'documents/$sanitizedFileName';
    }
  }

  /// Sanitize filename for safe storage
  ///
  /// Removes or replaces dangerous characters while preserving readability
  static String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\s\-\.]'), '_')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  /// Get file extension from filename
  ///
  /// Returns lowercase extension without dot
  static String getFileExtension(String fileName) {
    final cleanFileName = getDisplayFileName(fileName);
    final parts = cleanFileName.split('.');

    if (parts.length > 1) {
      return parts.last.toLowerCase();
    }

    return '';
  }

  /// Get filename without extension
  ///
  /// Returns clean filename without extension
  static String getFileNameWithoutExtension(String fileName) {
    final cleanFileName = getDisplayFileName(fileName);
    final parts = cleanFileName.split('.');

    if (parts.length > 1) {
      return parts.sublist(0, parts.length - 1).join('.');
    }

    return cleanFileName;
  }

  /// Validate filename for upload
  ///
  /// Checks if filename is valid for upload operations
  static bool isValidFileName(String fileName) {
    if (fileName.isEmpty) return false;

    // Check for dangerous patterns
    if (fileName.contains('..') ||
        fileName.contains('/') ||
        fileName.contains('\\')) {
      return false;
    }

    // Check length
    if (fileName.length > 255) return false;

    // Check for reserved names (Windows)
    final reservedNames = [
      'CON',
      'PRN',
      'AUX',
      'NUL',
      'COM1',
      'COM2',
      'COM3',
      'COM4',
      'COM5',
      'COM6',
      'COM7',
      'COM8',
      'COM9',
      'LPT1',
      'LPT2',
      'LPT3',
      'LPT4',
      'LPT5',
      'LPT6',
      'LPT7',
      'LPT8',
      'LPT9',
    ];

    final nameWithoutExt = getFileNameWithoutExtension(fileName).toUpperCase();
    if (reservedNames.contains(nameWithoutExt)) return false;

    return true;
  }

  /// Format filename for display in UI with smart truncation
  ///
  /// Ensures consistent display formatting across the app
  /// Automatically adds extensions to truncated names for better UX
  static String formatForDisplay(String fileName, {int? maxLength}) {
    final cleanName = getDisplayFileName(fileName);

    if (maxLength != null && cleanName.length > maxLength) {
      final extension = getFileExtension(cleanName);
      final nameWithoutExt = getFileNameWithoutExtension(cleanName);

      if (extension.isNotEmpty) {
        // Account for "..." (3) + "." (1) + extension length
        final maxNameLength = maxLength - extension.length - 4;
        if (maxNameLength > 0) {
          return '${nameWithoutExt.substring(0, maxNameLength)}....$extension';
        }
      }

      return '${cleanName.substring(0, maxLength - 3)}...';
    }

    return cleanName;
  }

  /// Smart format for display that detects truncation automatically
  ///
  /// Uses Text widget constraints to determine if truncation is needed
  /// This is more accurate than fixed character limits
  static String formatForDisplaySmart(
    String fileName, {
    required double availableWidth,
    required TextStyle textStyle,
    int maxLines = 1,
  }) {
    final cleanName = getDisplayFileName(fileName);

    // Create a TextPainter to measure text width
    final textPainter = TextPainter(
      text: TextSpan(text: cleanName, style: textStyle),
      maxLines: maxLines,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: availableWidth);

    // If text fits, return as-is
    if (!textPainter.didExceedMaxLines) {
      return cleanName;
    }

    // Text is truncated, add extension if available
    final extension = getFileExtension(cleanName);
    final nameWithoutExt = getFileNameWithoutExtension(cleanName);

    if (extension.isNotEmpty) {
      // Try to fit name with extension
      final ellipsisText = '....$extension';
      final ellipsisWidth = TextPainter(
        text: TextSpan(text: ellipsisText, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final availableForName = availableWidth - ellipsisWidth.width;

      if (availableForName > 0) {
        // Binary search to find optimal truncation point
        int left = 1;
        int right = nameWithoutExt.length;
        String bestFit = nameWithoutExt;

        while (left <= right) {
          final mid = (left + right) ~/ 2;
          final testText = nameWithoutExt.substring(0, mid);

          final testPainter = TextPainter(
            text: TextSpan(text: testText, style: textStyle),
            textDirection: TextDirection.ltr,
          )..layout();

          if (testPainter.width <= availableForName) {
            bestFit = testText;
            left = mid + 1;
          } else {
            right = mid - 1;
          }
        }

        if (bestFit.isNotEmpty) {
          return '$bestFit....$extension';
        }
      }
    }

    // Fallback to simple truncation
    return formatForDisplay(cleanName, maxLength: 20);
  }

  /// Create unique filename to avoid conflicts
  ///
  /// Adds counter suffix if filename already exists
  static String createUniqueFileName(
    String fileName,
    List<String> existingNames,
  ) {
    final cleanName = getDisplayFileName(fileName);

    if (!existingNames.contains(cleanName)) {
      return cleanName;
    }

    final extension = getFileExtension(cleanName);
    final nameWithoutExt = getFileNameWithoutExtension(cleanName);

    int counter = 1;
    String uniqueName;

    do {
      if (extension.isNotEmpty) {
        uniqueName = '${nameWithoutExt}_$counter.$extension';
      } else {
        uniqueName = '${nameWithoutExt}_$counter';
      }
      counter++;
    } while (existingNames.contains(uniqueName));

    return uniqueName;
  }
}
