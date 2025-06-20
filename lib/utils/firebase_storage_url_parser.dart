import 'dart:developer' as dev;

/// Utility class for parsing Firebase Storage URLs and extracting storage paths
class FirebaseStorageUrlParser {
  /// Extract storage path from Firebase Storage download URL
  ///
  /// Supports both formats:
  /// - https://firebasestorage.googleapis.com/v0/b/bucket/o/path%2Ffile.pdf?alt=media&token=...
  /// - https://storage.googleapis.com/bucket/path/file.pdf
  ///
  /// Returns null if URL cannot be parsed or is not a valid Firebase Storage URL
  static String? extractStoragePathFromUrl(String downloadUrl) {
    try {
      if (downloadUrl.isEmpty) return null;

      final uri = Uri.parse(downloadUrl);

      // Handle firebasestorage.googleapis.com format
      if (uri.host == 'firebasestorage.googleapis.com') {
        return _extractFromFirebaseStorageUrl(uri);
      }

      // Handle storage.googleapis.com format
      if (uri.host == 'storage.googleapis.com') {
        return _extractFromGoogleStorageUrl(uri);
      }

      dev.log(
        '⚠️ Unsupported storage URL format: ${uri.host}',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    } catch (e) {
      dev.log(
        '❌ Error parsing storage URL: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Extract path from firebasestorage.googleapis.com URL format
  static String? _extractFromFirebaseStorageUrl(Uri uri) {
    try {
      final pathSegments = uri.pathSegments;

      // Expected format: /v0/b/{bucket}/o/{encoded_path}
      // Find the 'o' segment and extract the encoded path after it
      final oIndex = pathSegments.indexOf('o');
      if (oIndex != -1 && oIndex + 1 < pathSegments.length) {
        final encodedPath = pathSegments[oIndex + 1];
        final decodedPath = Uri.decodeComponent(encodedPath);

        dev.log(
          '✅ Extracted storage path: $decodedPath',
          name: 'FirebaseStorageUrlParser',
        );
        return decodedPath;
      }

      dev.log(
        '⚠️ Could not find object path in Firebase Storage URL',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    } catch (e) {
      dev.log(
        '❌ Error extracting from Firebase Storage URL: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Extract path from storage.googleapis.com URL format
  static String? _extractFromGoogleStorageUrl(Uri uri) {
    try {
      final pathSegments = uri.pathSegments;

      // Expected format: /{bucket}/{path}/{to}/{file}
      // Skip the first segment (bucket) and join the rest
      if (pathSegments.length >= 2) {
        final storagePath = pathSegments.skip(1).join('/');

        dev.log(
          '✅ Extracted storage path from Google Storage URL: $storagePath',
          name: 'FirebaseStorageUrlParser',
        );
        return storagePath;
      }

      dev.log(
        '⚠️ Invalid Google Storage URL format',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    } catch (e) {
      dev.log(
        '❌ Error extracting from Google Storage URL: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Validate if a URL is a Firebase Storage URL
  static bool isFirebaseStorageUrl(String url) {
    try {
      if (url.isEmpty) return false;

      final uri = Uri.parse(url);
      return uri.host == 'firebasestorage.googleapis.com' ||
          uri.host == 'storage.googleapis.com';
    } catch (e) {
      return false;
    }
  }

  /// Extract bucket name from Firebase Storage URL
  static String? extractBucketName(String downloadUrl) {
    try {
      if (downloadUrl.isEmpty) return null;

      final uri = Uri.parse(downloadUrl);

      if (uri.host == 'firebasestorage.googleapis.com') {
        // Format: /v0/b/{bucket}/o/{path}
        final pathSegments = uri.pathSegments;
        final bIndex = pathSegments.indexOf('b');
        if (bIndex != -1 && bIndex + 1 < pathSegments.length) {
          return pathSegments[bIndex + 1];
        }
      } else if (uri.host == 'storage.googleapis.com') {
        // Format: /{bucket}/{path}
        final pathSegments = uri.pathSegments;
        if (pathSegments.isNotEmpty) {
          return pathSegments.first;
        }
      }

      return null;
    } catch (e) {
      dev.log(
        '❌ Error extracting bucket name: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Get filename from storage path or URL
  static String? getFileName(String pathOrUrl) {
    try {
      String path;

      // If it's a URL, extract the storage path first
      if (pathOrUrl.startsWith('http')) {
        path = extractStoragePathFromUrl(pathOrUrl) ?? pathOrUrl;
      } else {
        path = pathOrUrl;
      }

      if (path.isEmpty) return null;

      // Extract filename from path
      final parts = path.split('/');
      return parts.isNotEmpty ? parts.last : null;
    } catch (e) {
      dev.log(
        '❌ Error extracting filename: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Get directory path from storage path or URL
  static String? getDirectoryPath(String pathOrUrl) {
    try {
      String path;

      // If it's a URL, extract the storage path first
      if (pathOrUrl.startsWith('http')) {
        path = extractStoragePathFromUrl(pathOrUrl) ?? pathOrUrl;
      } else {
        path = pathOrUrl;
      }

      if (path.isEmpty) return null;

      // Extract directory from path
      final parts = path.split('/');
      if (parts.length <= 1) return '';

      return parts.sublist(0, parts.length - 1).join('/');
    } catch (e) {
      dev.log(
        '❌ Error extracting directory path: $e',
        name: 'FirebaseStorageUrlParser',
      );
      return null;
    }
  }

  /// Check if storage path is in documents folder
  static bool isInDocumentsFolder(String pathOrUrl) {
    try {
      String path;

      // If it's a URL, extract the storage path first
      if (pathOrUrl.startsWith('http')) {
        path = extractStoragePathFromUrl(pathOrUrl) ?? pathOrUrl;
      } else {
        path = pathOrUrl;
      }

      return path.startsWith('documents/');
    } catch (e) {
      return false;
    }
  }

  /// Validate storage path format
  static bool isValidStoragePath(String path) {
    if (path.isEmpty) return false;
    if (path.startsWith('/') || path.endsWith('/')) return false;
    if (path.contains('..')) return false;
    if (!path.contains('.')) return false; // Should have file extension

    return true;
  }

  /// Create a test method to validate the parser with the provided example URL
  static void testWithExampleUrl() {
    const exampleUrl =
        'https://firebasestorage.googleapis.com/v0/b/document-management-c5a96.firebasestorage.app/o/documents%2F1750138299562_penerapan_convolutional_neural_network_untuk_identifikasi_otomatis_spesies_burung_hama_pemakan_biji_part11.pdf?alt=media&token=4304c9f9-7d13-4e74-84e7-8b69dfb3e5ae';

    print('🧪 Testing Firebase Storage URL Parser');
    print('📄 Example URL: $exampleUrl');

    final storagePath = extractStoragePathFromUrl(exampleUrl);
    print('📁 Extracted storage path: $storagePath');

    final bucketName = extractBucketName(exampleUrl);
    print('🪣 Extracted bucket: $bucketName');

    final fileName = getFileName(exampleUrl);
    print('📄 Extracted filename: $fileName');

    final directoryPath = getDirectoryPath(exampleUrl);
    print('📁 Extracted directory: $directoryPath');

    final isDocuments = isInDocumentsFolder(exampleUrl);
    print('📂 Is in documents folder: $isDocuments');

    final isValid = storagePath != null
        ? isValidStoragePath(storagePath)
        : false;
    print('✅ Is valid storage path: $isValid');
  }
}
