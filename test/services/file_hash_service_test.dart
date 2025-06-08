import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementdoc/services/file_hash_service.dart';

void main() {
  group('FileHashService Tests', () {
    late FileHashService fileHashService;
    late Directory tempDir;

    setUpAll(() async {
      fileHashService = FileHashService();
      tempDir = await Directory.systemTemp.createTemp('file_hash_test_');
    });

    tearDownAll(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Hash Calculation Tests', () {
      test('should calculate hash for small file correctly', () async {
        // Create a small test file
        final testFile = File('${tempDir.path}/small_test.txt');
        const testContent = 'Hello, World! This is a test file.';
        await testFile.writeAsString(testContent);

        // Calculate hash
        final hash = await fileHashService.calculateFileHash(testFile);

        // Verify hash format
        expect(hash, isNotNull);
        expect(hash.length, equals(64)); // SHA-256 hash length
        expect(fileHashService.isValidHash(hash), isTrue);
      });

      test('should calculate hash for XFile correctly', () async {
        // Create test file
        final testFile = File('${tempDir.path}/xfile_test.txt');
        const testContent = 'XFile test content for hash calculation.';
        await testFile.writeAsString(testContent);

        // Create XFile
        final xFile = XFile(testFile.path);

        // Calculate hash
        final hash = await fileHashService.calculateXFileHash(xFile);

        // Verify hash
        expect(hash, isNotNull);
        expect(hash.length, equals(64));
        expect(fileHashService.isValidHash(hash), isTrue);
      });

      test('should calculate same hash for identical content', () async {
        const testContent = 'Identical content for hash comparison.';

        // Create two files with identical content
        final file1 = File('${tempDir.path}/identical1.txt');
        final file2 = File('${tempDir.path}/identical2.txt');
        await file1.writeAsString(testContent);
        await file2.writeAsString(testContent);

        // Calculate hashes
        final hash1 = await fileHashService.calculateFileHash(file1);
        final hash2 = await fileHashService.calculateFileHash(file2);

        // Verify hashes are identical
        expect(hash1, equals(hash2));
      });

      test('should calculate different hash for different content', () async {
        // Create two files with different content
        final file1 = File('${tempDir.path}/different1.txt');
        final file2 = File('${tempDir.path}/different2.txt');
        await file1.writeAsString('Content A');
        await file2.writeAsString('Content B');

        // Calculate hashes
        final hash1 = await fileHashService.calculateFileHash(file1);
        final hash2 = await fileHashService.calculateFileHash(file2);

        // Verify hashes are different
        expect(hash1, isNot(equals(hash2)));
      });
    });

    group('Quick Hash Tests', () {
      test('should use correct strategy for small files', () async {
        // Create small file (< 5MB)
        final smallFile = File('${tempDir.path}/small.txt');
        final smallContent = 'A' * 1000; // 1KB
        await smallFile.writeAsString(smallContent);

        final xFile = XFile(smallFile.path);
        final hash = await fileHashService.calculateQuickHash(xFile);

        expect(hash, isNotNull);
        expect(hash.length, equals(64));
        expect(fileHashService.isValidHash(hash), isTrue);
      });

      test('should handle medium files correctly', () async {
        // Create medium file (1MB)
        final mediumFile = File('${tempDir.path}/medium.txt');
        final mediumContent = 'B' * (1024 * 1024); // 1MB
        await mediumFile.writeAsString(mediumContent);

        final xFile = XFile(mediumFile.path);
        final hash = await fileHashService.calculateQuickHash(xFile);

        expect(hash, isNotNull);
        expect(hash.length, equals(64));
        expect(fileHashService.isValidHash(hash), isTrue);
      });
    });

    group('File Comparison Tests', () {
      test('should identify identical files correctly', () async {
        const testContent = 'Content for file comparison test.';

        // Create two identical files
        final file1 = File('${tempDir.path}/compare1.txt');
        final file2 = File('${tempDir.path}/compare2.txt');
        await file1.writeAsString(testContent);
        await file2.writeAsString(testContent);

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Test file comparison
        final areIdentical = await fileHashService.areFilesIdentical(
          xFile1,
          xFile2,
        );
        expect(areIdentical, isTrue);
      });

      test('should identify different files correctly', () async {
        // Create two different files
        final file1 = File('${tempDir.path}/diff1.txt');
        final file2 = File('${tempDir.path}/diff2.txt');
        await file1.writeAsString('Content A');
        await file2.writeAsString('Content B');

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Test file comparison
        final areIdentical = await fileHashService.areFilesIdentical(
          xFile1,
          xFile2,
        );
        expect(areIdentical, isFalse);
      });

      test('should identify different sized files quickly', () async {
        // Create files with different sizes
        final file1 = File('${tempDir.path}/size1.txt');
        final file2 = File('${tempDir.path}/size2.txt');
        await file1.writeAsString('Short');
        await file2.writeAsString('Much longer content here');

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Test file comparison (should be fast due to size check)
        final areIdentical = await fileHashService.areFilesIdentical(
          xFile1,
          xFile2,
        );
        expect(areIdentical, isFalse);
      });
    });

    group('Batch Processing Tests', () {
      test('should calculate hashes for multiple files', () async {
        // Create multiple test files
        final files = <XFile>[];
        for (int i = 0; i < 3; i++) {
          final file = File('${tempDir.path}/batch_$i.txt');
          await file.writeAsString('Content for file $i');
          files.add(XFile(file.path));
        }

        // Calculate batch hashes
        final hashes = await fileHashService.calculateBatchHashes(files);

        // Verify results
        expect(hashes.length, equals(3));
        for (final file in files) {
          expect(hashes.containsKey(file.name), isTrue);
          expect(fileHashService.isValidHash(hashes[file.name]!), isTrue);
        }
      });

      test('should handle batch processing with progress callback', () async {
        // Create test files
        final files = <XFile>[];
        for (int i = 0; i < 3; i++) {
          // Reduce to 3 files to avoid concurrency issues
          final file = File('${tempDir.path}/progress_$i.txt');
          await file.writeAsString('Progress test content $i');
          files.add(XFile(file.path));
        }

        final progressValues = <int>[];
        final hashes = await fileHashService.calculateBatchHashes(
          files,
          maxConcurrency:
              1, // Force sequential processing to avoid race conditions
          onProgress: (completed, total) {
            progressValues.add(completed);
            expect(completed, lessThanOrEqualTo(total));
            expect(total, equals(3));
          },
        );

        expect(hashes.length, equals(3));
        expect(progressValues.isNotEmpty, isTrue);
        expect(progressValues.last, equals(3)); // Should complete all files

        // Verify progress values are reasonable
        expect(progressValues.first, greaterThan(0));
        expect(progressValues.last, equals(3));
      });
    });

    group('Utility Functions Tests', () {
      test('should validate hash format correctly', () async {
        // Valid SHA-256 hash
        const validHash =
            'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3';
        expect(fileHashService.isValidHash(validHash), isTrue);

        // Invalid hashes
        expect(fileHashService.isValidHash('invalid'), isFalse);
        expect(fileHashService.isValidHash(''), isFalse);
        expect(
          fileHashService.isValidHash(
            'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae',
          ),
          isFalse,
        ); // Too short
        expect(
          fileHashService.isValidHash(
            'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae33',
          ),
          isFalse,
        ); // Too long
      });

      test('should generate file fingerprint correctly', () async {
        const hash =
            'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3';
        const fileName = 'test.txt';
        const fileSize = 1024;
        const contentType = 'text/plain';

        final fingerprint = fileHashService.generateFileFingerprint(
          hash: hash,
          fileName: fileName,
          fileSize: fileSize,
          contentType: contentType,
        );

        expect(fingerprint, isNotNull);
        expect(fingerprint.contains('_'), isTrue);
        expect(fingerprint.startsWith(hash.substring(0, 32)), isTrue);
      });

      test('should create cache key correctly', () async {
        const hash =
            'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3';
        const operation = 'upload';

        final cacheKey = fileHashService.createCacheKey(hash, operation);

        expect(cacheKey, equals('upload_a665a45920422f9d'));
        expect(cacheKey.startsWith(operation), isTrue);
        expect(cacheKey.contains(hash.substring(0, 16)), isTrue);
      });

      test('should categorize file sizes correctly', () async {
        expect(
          fileHashService.getFileSizeCategory(500 * 1024),
          equals('small'),
        ); // 500KB
        expect(
          fileHashService.getFileSizeCategory(5 * 1024 * 1024),
          equals('medium'),
        ); // 5MB
        expect(
          fileHashService.getFileSizeCategory(50 * 1024 * 1024),
          equals('large'),
        ); // 50MB
        expect(
          fileHashService.getFileSizeCategory(150 * 1024 * 1024),
          equals('very_large'),
        ); // 150MB
      });
    });

    group('Error Handling Tests', () {
      test('should handle non-existent file gracefully', () async {
        final nonExistentFile = File('${tempDir.path}/non_existent.txt');

        expect(
          () => fileHashService.calculateFileHash(nonExistentFile),
          throwsA(isA<FileSystemException>()),
        );
      });

      test('should handle invalid XFile gracefully', () async {
        final invalidXFile = XFile('/invalid/path/file.txt');

        expect(
          () => fileHashService.calculateXFileHash(invalidXFile),
          throwsA(isA<Exception>()),
        );
      });
    });
  });
}
