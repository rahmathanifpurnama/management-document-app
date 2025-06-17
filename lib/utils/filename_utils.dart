/// Utility class for handling filename operations and display formatting
///
/// This utility helps separate storage paths from display names to ensure
/// users see clean filenames without timestamps while maintaining unique
/// storage paths for Firebase Storage.
class FilenameUtils {
  /// Extract clean display filename from storage path
  ///
  /// Removes timestamp prefixes that are added during upload
  /// Example: "1748961795557_daftar_isi.pdf" -> "daftar_isi.pdf"
  static String getDisplayFileName(String storageFileName) {
    if (storageFileName.isEmpty) return '';

    // Extract just the filename from full path if needed
    final fileName = storageFileName.split('/').last;

    // IMPROVED: More robust timestamp detection
    // Check for timestamp prefix pattern (10-13 digits followed by underscore)
    final timestampPattern = RegExp(r'^\d{10,13}_(.+)$');
    final match = timestampPattern.firstMatch(fileName);

    if (match != null) {
      // Return filename without timestamp prefix
      final cleanName = match.group(1) ?? fileName;
      // Additional validation to ensure we have a valid filename
      if (cleanName.isNotEmpty && cleanName.contains('.')) {
        return cleanName;
      }
    }

    // Return original filename if no timestamp pattern found
    return fileName;
  }

  /// Get user-friendly display name for UI
  ///
  /// Converts storage filename to a clean, readable format
  /// Example: "1750128027374_penerapan_cnn_untuk_identifikasi.pdf" -> "Penerapan CNN Untuk Identifikasi.pdf"
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

  /// Generate storage path with timestamp for uniqueness
  ///
  /// Creates unique storage paths while preserving original filename
  /// for display purposes
  static String generateStoragePath({
    required String originalFileName,
    required String userId,
    String? categoryId,
  }) {
    final sanitizedFileName = _sanitizeFileName(originalFileName);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    if (categoryId != null && categoryId.isNotEmpty) {
      return 'documents/categories/$categoryId/${timestamp}_$sanitizedFileName';
    } else {
      return 'documents/${timestamp}_$sanitizedFileName';
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

  /// Check if filename has timestamp prefix
  ///
  /// Useful for identifying files that need display name cleaning
  static bool hasTimestampPrefix(String fileName) {
    final timestampPattern = RegExp(r'^\d+_');
    return timestampPattern.hasMatch(fileName);
  }

  /// Extract timestamp from filename if present
  ///
  /// Returns null if no timestamp prefix found
  static int? extractTimestamp(String fileName) {
    final timestampPattern = RegExp(r'^(\d+)_');
    final match = timestampPattern.firstMatch(fileName);

    if (match != null) {
      return int.tryParse(match.group(1) ?? '');
    }

    return null;
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
  /// Returns clean filename without extension and timestamp
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
