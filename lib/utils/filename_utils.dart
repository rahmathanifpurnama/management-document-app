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
  /// Creates clean storage paths using secure filename for storage
  static String generateStoragePath({
    required String originalFileName,
    required String userId,
    String? categoryId,
  }) {
    final secureFileName = _createSecureStoragePath(originalFileName);

    if (categoryId != null && categoryId.isNotEmpty) {
      return 'documents/categories/$categoryId/$secureFileName';
    } else {
      return 'documents/$secureFileName';
    }
  }

  /// Sanitize filename for display with preserved spaces
  ///
  /// Removes dangerous characters while preserving spaces for readability
  static String sanitizeForDisplay(String fileName) {
    return fileName.replaceAll(RegExp(r'[^\w\s\-\.]'), '_').trim();
  }

  /// Create secure storage path from filename
  ///
  /// Replaces spaces and special characters for secure storage paths
  static String _createSecureStoragePath(String fileName) {
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

  /// Format filename for display in UI
  ///
  /// Ensures consistent display formatting across the app
  static String formatForDisplay(String fileName, {int? maxLength}) {
    final cleanName = getDisplayFileName(fileName);

    if (maxLength != null && cleanName.length > maxLength) {
      final extension = getFileExtension(cleanName);
      final nameWithoutExt = getFileNameWithoutExtension(cleanName);

      if (extension.isNotEmpty) {
        final maxNameLength =
            maxLength - extension.length - 4; // Account for "..." and "."
        if (maxNameLength > 0) {
          return '${nameWithoutExt.substring(0, maxNameLength)}...$extension';
        }
      }

      return '${cleanName.substring(0, maxLength - 3)}...';
    }

    return cleanName;
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
