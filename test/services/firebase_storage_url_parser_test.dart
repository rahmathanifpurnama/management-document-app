import 'package:flutter_test/flutter_test.dart';
import 'package:managementdoc/utils/firebase_storage_url_parser.dart';

void main() {
  group('FirebaseStorageUrlParser', () {
    const exampleFirebaseUrl = 'https://firebasestorage.googleapis.com/v0/b/document-management-c5a96.firebasestorage.app/o/documents%2F1750138299562_penerapan_convolutional_neural_network_untuk_identifikasi_otomatis_spesies_burung_hama_pemakan_biji_part11.pdf?alt=media&token=4304c9f9-7d13-4e74-84e7-8b69dfb3e5ae';
    const exampleGoogleStorageUrl = 'https://storage.googleapis.com/document-management-c5a96/documents/test_file.pdf';
    const expectedStoragePath = 'documents/1750138299562_penerapan_convolutional_neural_network_untuk_identifikasi_otomatis_spesies_burung_hama_pemakan_biji_part11.pdf';
    const expectedFileName = '1750138299562_penerapan_convolutional_neural_network_untuk_identifikasi_otomatis_spesies_burung_hama_pemakan_biji_part11.pdf';

    group('extractStoragePathFromUrl', () {
      test('should extract storage path from Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(exampleFirebaseUrl);
        expect(result, equals(expectedStoragePath));
      });

      test('should extract storage path from Google Storage URL', () {
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(exampleGoogleStorageUrl);
        expect(result, equals('documents/test_file.pdf'));
      });

      test('should return null for invalid URL', () {
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl('invalid-url');
        expect(result, isNull);
      });

      test('should return null for empty URL', () {
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl('');
        expect(result, isNull);
      });

      test('should return null for non-Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl('https://example.com/file.pdf');
        expect(result, isNull);
      });

      test('should handle URL with special characters', () {
        const urlWithSpecialChars = 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Ffile%20with%20spaces.pdf?alt=media';
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(urlWithSpecialChars);
        expect(result, equals('documents/file with spaces.pdf'));
      });
    });

    group('isFirebaseStorageUrl', () {
      test('should return true for Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.isFirebaseStorageUrl(exampleFirebaseUrl);
        expect(result, isTrue);
      });

      test('should return true for Google Storage URL', () {
        final result = FirebaseStorageUrlParser.isFirebaseStorageUrl(exampleGoogleStorageUrl);
        expect(result, isTrue);
      });

      test('should return false for non-Firebase URL', () {
        final result = FirebaseStorageUrlParser.isFirebaseStorageUrl('https://example.com/file.pdf');
        expect(result, isFalse);
      });

      test('should return false for empty URL', () {
        final result = FirebaseStorageUrlParser.isFirebaseStorageUrl('');
        expect(result, isFalse);
      });

      test('should return false for invalid URL', () {
        final result = FirebaseStorageUrlParser.isFirebaseStorageUrl('invalid-url');
        expect(result, isFalse);
      });
    });

    group('extractBucketName', () {
      test('should extract bucket name from Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.extractBucketName(exampleFirebaseUrl);
        expect(result, equals('document-management-c5a96.firebasestorage.app'));
      });

      test('should extract bucket name from Google Storage URL', () {
        final result = FirebaseStorageUrlParser.extractBucketName(exampleGoogleStorageUrl);
        expect(result, equals('document-management-c5a96'));
      });

      test('should return null for invalid URL', () {
        final result = FirebaseStorageUrlParser.extractBucketName('invalid-url');
        expect(result, isNull);
      });

      test('should return null for empty URL', () {
        final result = FirebaseStorageUrlParser.extractBucketName('');
        expect(result, isNull);
      });
    });

    group('getFileName', () {
      test('should extract filename from storage path', () {
        final result = FirebaseStorageUrlParser.getFileName('documents/test_file.pdf');
        expect(result, equals('test_file.pdf'));
      });

      test('should extract filename from Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.getFileName(exampleFirebaseUrl);
        expect(result, equals(expectedFileName));
      });

      test('should return null for empty path', () {
        final result = FirebaseStorageUrlParser.getFileName('');
        expect(result, isNull);
      });

      test('should handle single filename without path', () {
        final result = FirebaseStorageUrlParser.getFileName('test_file.pdf');
        expect(result, equals('test_file.pdf'));
      });
    });

    group('getDirectoryPath', () {
      test('should extract directory path from storage path', () {
        final result = FirebaseStorageUrlParser.getDirectoryPath('documents/category/test_file.pdf');
        expect(result, equals('documents/category'));
      });

      test('should extract directory path from Firebase Storage URL', () {
        final result = FirebaseStorageUrlParser.getDirectoryPath(exampleFirebaseUrl);
        expect(result, equals('documents'));
      });

      test('should return empty string for single filename', () {
        final result = FirebaseStorageUrlParser.getDirectoryPath('test_file.pdf');
        expect(result, equals(''));
      });

      test('should return null for empty path', () {
        final result = FirebaseStorageUrlParser.getDirectoryPath('');
        expect(result, isNull);
      });
    });

    group('isInDocumentsFolder', () {
      test('should return true for documents folder path', () {
        final result = FirebaseStorageUrlParser.isInDocumentsFolder('documents/test_file.pdf');
        expect(result, isTrue);
      });

      test('should return true for Firebase Storage URL in documents folder', () {
        final result = FirebaseStorageUrlParser.isInDocumentsFolder(exampleFirebaseUrl);
        expect(result, isTrue);
      });

      test('should return false for non-documents folder path', () {
        final result = FirebaseStorageUrlParser.isInDocumentsFolder('uploads/test_file.pdf');
        expect(result, isFalse);
      });

      test('should return false for empty path', () {
        final result = FirebaseStorageUrlParser.isInDocumentsFolder('');
        expect(result, isFalse);
      });
    });

    group('isValidStoragePath', () {
      test('should return true for valid storage path', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('documents/test_file.pdf');
        expect(result, isTrue);
      });

      test('should return false for empty path', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('');
        expect(result, isFalse);
      });

      test('should return false for path starting with slash', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('/documents/test_file.pdf');
        expect(result, isFalse);
      });

      test('should return false for path ending with slash', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('documents/test_file.pdf/');
        expect(result, isFalse);
      });

      test('should return false for path with double dots', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('documents/../test_file.pdf');
        expect(result, isFalse);
      });

      test('should return false for path without file extension', () {
        final result = FirebaseStorageUrlParser.isValidStoragePath('documents/test_file');
        expect(result, isFalse);
      });
    });

    group('Edge Cases', () {
      test('should handle URL with multiple query parameters', () {
        const urlWithMultipleParams = 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Ftest.pdf?alt=media&token=abc123&download=true';
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(urlWithMultipleParams);
        expect(result, equals('documents/test.pdf'));
      });

      test('should handle deeply nested paths', () {
        const deepPath = 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Fcategories%2Fsubcategory%2Fdeep%2Ftest.pdf?alt=media';
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(deepPath);
        expect(result, equals('documents/categories/subcategory/deep/test.pdf'));
      });

      test('should handle URL with encoded special characters', () {
        const encodedUrl = 'https://firebasestorage.googleapis.com/v0/b/test-bucket/o/documents%2Ffile%2Bwith%2Bplus.pdf?alt=media';
        final result = FirebaseStorageUrlParser.extractStoragePathFromUrl(encodedUrl);
        expect(result, equals('documents/file+with+plus.pdf'));
      });
    });

    group('Real World Example', () {
      test('should correctly parse the provided example URL', () {
        // Test with the actual URL provided in the user's request
        final storagePath = FirebaseStorageUrlParser.extractStoragePathFromUrl(exampleFirebaseUrl);
        final bucketName = FirebaseStorageUrlParser.extractBucketName(exampleFirebaseUrl);
        final fileName = FirebaseStorageUrlParser.getFileName(exampleFirebaseUrl);
        final directoryPath = FirebaseStorageUrlParser.getDirectoryPath(exampleFirebaseUrl);
        final isInDocuments = FirebaseStorageUrlParser.isInDocumentsFolder(exampleFirebaseUrl);
        final isValid = storagePath != null ? FirebaseStorageUrlParser.isValidStoragePath(storagePath) : false;

        expect(storagePath, equals(expectedStoragePath));
        expect(bucketName, equals('document-management-c5a96.firebasestorage.app'));
        expect(fileName, equals(expectedFileName));
        expect(directoryPath, equals('documents'));
        expect(isInDocuments, isTrue);
        expect(isValid, isTrue);
      });
    });
  });
}
