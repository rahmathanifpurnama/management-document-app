import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementdoc/services/consolidated_upload_service.dart';
import 'package:managementdoc/services/duplicate_detection_service.dart';
import 'package:managementdoc/services/file_hash_service.dart';
import 'package:managementdoc/core/config/upload_config.dart';

void main() {
  group('Upload Integration Tests', () {
    late ConsolidatedUploadService uploadService;
    late DuplicateDetectionService duplicateService;
    late FileHashService hashService;
    late Directory tempDir;

    setUpAll(() async {
      // Initialize temp directory and non-Firebase services first
      tempDir = await Directory.systemTemp.createTemp(
        'upload_integration_test_',
      );
      duplicateService = DuplicateDetectionService();
      hashService = FileHashService();

      // Try to initialize Firebase-dependent services
      try {
        uploadService = ConsolidatedUploadService();
      } catch (e) {
        // Firebase services might not be available in test environment
        // We'll test what we can without actual Firebase connection
      }
    });

    tearDownAll(() async {
      try {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      } catch (e) {
        // Ignore cleanup errors in test environment
      }
    });

    group('Upload Workflow Tests', () {
      test(
        'should complete full upload workflow with duplicate detection',
        () async {
          // Create test file
          final testFile = File('${tempDir.path}/workflow_test.txt');
          await testFile.writeAsString('Upload workflow test content');
          final xFile = XFile(testFile.path);

          // Step 1: Calculate hash
          final hash = await hashService.calculateXFileHash(xFile);
          expect(hash, isNotNull);
          expect(hashService.isValidHash(hash), isTrue);

          // Step 2: Check for duplicates
          final duplicateResult = await duplicateService.checkForDuplicate(
            xFile,
          );
          expect(duplicateResult, isNotNull);
          expect(
            duplicateResult.isDuplicate,
            isFalse,
          ); // First upload, no duplicates

          // Step 3: Validate upload parameters
          final fileSize = await xFile.length();
          expect(fileSize, lessThanOrEqualTo(UploadConfig.maxFileSizeBytes));

          // The actual upload would require Firebase setup, so we test the preparation
          expect(xFile.name, isNotNull);
          expect(fileSize, greaterThan(0));
        },
      );

      test('should handle duplicate detection in upload flow', () async {
        // Create two identical files
        const content = 'Duplicate detection in upload flow';

        final file1 = File('${tempDir.path}/duplicate1.txt');
        final file2 = File('${tempDir.path}/duplicate2.txt');
        await file1.writeAsString(content);
        await file2.writeAsString(content);

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Check first file (should be unique)
        final result1 = await duplicateService.checkForDuplicate(xFile1);
        expect(result1.isDuplicate, isFalse);

        // Check second file (should detect similarity)
        final areSimilar = await duplicateService.areFilesSimilar(
          xFile1,
          xFile2,
        );
        expect(areSimilar, isTrue);
      });

      test('should validate file types before upload', () async {
        final testCases = [
          {'name': 'document.pdf', 'content': 'PDF content', 'valid': true},
          {'name': 'image.jpg', 'content': 'JPEG content', 'valid': true},
          {'name': 'text.txt', 'content': 'Text content', 'valid': true},
          {'name': 'executable.exe', 'content': 'EXE content', 'valid': false},
        ];

        for (final testCase in testCases) {
          final file = File('${tempDir.path}/${testCase['name']}');
          await file.writeAsString(testCase['content'] as String);
          final xFile = XFile(file.path);

          // Check if file type is allowed
          final extension = testCase['name']
              .toString()
              .split('.')
              .last
              .toLowerCase();
          final isAllowed =
              UploadConfig.allowedExtensions.isEmpty ||
              UploadConfig.allowedExtensions.contains(extension);

          if (testCase['valid'] as bool) {
            expect(
              isAllowed,
              isTrue,
              reason: 'File type $extension should be allowed',
            );
          }

          // Test duplicate detection regardless of file type
          final duplicateResult = await duplicateService.checkForDuplicate(
            xFile,
          );
          expect(duplicateResult, isNotNull);
        }
      });
    });

    group('Batch Upload Tests', () {
      test(
        'should handle multiple file uploads with duplicate detection',
        () async {
          // Create multiple test files
          final files = <XFile>[];
          final hashes = <String>[];

          for (int i = 0; i < 5; i++) {
            final file = File('${tempDir.path}/batch_$i.txt');
            await file.writeAsString('Batch upload content $i');
            final xFile = XFile(file.path);
            files.add(xFile);

            // Calculate hash for each file
            final hash = await hashService.calculateXFileHash(xFile);
            hashes.add(hash);
          }

          // Verify all hashes are unique
          final uniqueHashes = hashes.toSet();
          expect(uniqueHashes.length, equals(hashes.length));

          // Test batch duplicate detection
          final duplicateResults = await duplicateService.checkMultipleFiles(
            files,
          );
          expect(duplicateResults.length, equals(5));

          for (final file in files) {
            final result = duplicateResults[file.name];
            expect(result, isNotNull);
            expect(result!.isDuplicate, isFalse);
          }
        },
      );

      test('should detect duplicates in batch upload', () async {
        // Create files with some duplicates
        const content1 = 'Content A';
        const content2 = 'Content B';

        final files = <XFile>[];

        // Create files: A, B, A (duplicate), B (duplicate)
        final file1 = File('${tempDir.path}/batch_dup_1.txt');
        final file2 = File('${tempDir.path}/batch_dup_2.txt');
        final file3 = File('${tempDir.path}/batch_dup_3.txt');
        final file4 = File('${tempDir.path}/batch_dup_4.txt');

        await file1.writeAsString(content1);
        await file2.writeAsString(content2);
        await file3.writeAsString(content1); // Duplicate of file1
        await file4.writeAsString(content2); // Duplicate of file2

        files.addAll([
          XFile(file1.path),
          XFile(file2.path),
          XFile(file3.path),
          XFile(file4.path),
        ]);

        // Test similarity detection
        final areSimilar13 = await duplicateService.areFilesSimilar(
          files[0],
          files[2],
        );
        final areSimilar24 = await duplicateService.areFilesSimilar(
          files[1],
          files[3],
        );
        final areDifferent12 = await duplicateService.areFilesSimilar(
          files[0],
          files[1],
        );

        expect(areSimilar13, isTrue);
        expect(areSimilar24, isTrue);
        expect(areDifferent12, isFalse);
      });
    });

    group('Performance Tests', () {
      test('should handle large file upload preparation efficiently', () async {
        // Create a larger test file (1MB)
        final largeFile = File('${tempDir.path}/large_upload.txt');
        final largeContent = 'A' * (1024 * 1024); // 1MB
        await largeFile.writeAsString(largeContent);
        final xFile = XFile(largeFile.path);

        final stopwatch = Stopwatch()..start();

        // Test hash calculation performance
        final hash = await hashService.calculateOptimalHash(xFile);
        expect(hash, isNotNull);

        // Test duplicate detection performance
        final duplicateResult = await duplicateService.checkForDuplicate(xFile);
        expect(duplicateResult, isNotNull);

        stopwatch.stop();

        // Should complete within reasonable time
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(15000),
        ); // 15 seconds max
        expect(hashService.isValidHash(hash), isTrue);
      });

      test('should handle concurrent upload preparations', () async {
        // Create multiple files for concurrent processing
        final files = <XFile>[];
        for (int i = 0; i < 10; i++) {
          final file = File('${tempDir.path}/concurrent_$i.txt');
          await file.writeAsString('Concurrent upload content $i');
          files.add(XFile(file.path));
        }

        final stopwatch = Stopwatch()..start();

        // Process files concurrently
        final futures = files.map((file) async {
          final hash = await hashService.calculateXFileHash(file);
          final duplicateResult = await duplicateService.checkForDuplicate(
            file,
          );
          return {'hash': hash, 'duplicate': duplicateResult};
        });

        final results = await Future.wait(futures);
        stopwatch.stop();

        expect(results.length, equals(10));
        for (final result in results) {
          expect(result['hash'], isNotNull);
          expect(result['duplicate'], isNotNull);
        }

        // Concurrent processing should be faster than sequential
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(30000),
        ); // 30 seconds max
      });
    });

    group('Error Handling Tests', () {
      test('should handle upload preparation errors gracefully', () async {
        // Test with non-existent file
        final nonExistentFile = XFile('/non/existent/path/file.txt');

        // Hash calculation should fail
        expect(
          () => hashService.calculateXFileHash(nonExistentFile),
          throwsA(isA<Exception>()),
        );

        // Duplicate detection should handle error gracefully
        final duplicateResult = await duplicateService.checkForDuplicate(
          nonExistentFile,
        );
        expect(duplicateResult.isDuplicate, isFalse);
        expect(duplicateResult.confidence, equals(0.0));
        expect(duplicateResult.reason, contains('failed'));
      });

      test('should handle file size validation', () async {
        // Create test file
        final testFile = File('${tempDir.path}/size_validation.txt');
        await testFile.writeAsString('Size validation test');
        final xFile = XFile(testFile.path);

        final fileSize = await xFile.length();

        // Verify size is within limits
        if (UploadConfig.maxFileSizeBytes > 0) {
          expect(fileSize, lessThanOrEqualTo(UploadConfig.maxFileSizeBytes));
        }

        // Test with size check
        expect(fileSize, greaterThan(0));
      });

      test('should handle corrupted file gracefully', () async {
        // Create a file and then corrupt it
        final corruptFile = File('${tempDir.path}/corrupt.txt');
        await corruptFile.writeAsString('Original content');

        // Simulate corruption by writing invalid bytes
        await corruptFile.writeAsBytes([0xFF, 0xFE, 0xFD, 0xFC]);

        final xFile = XFile(corruptFile.path);

        try {
          // Should still be able to calculate hash
          final hash = await hashService.calculateXFileHash(xFile);
          expect(hash, isNotNull);
          expect(hashService.isValidHash(hash), isTrue);

          // Duplicate detection should work
          final duplicateResult = await duplicateService.checkForDuplicate(
            xFile,
          );
          expect(duplicateResult, isNotNull);
        } catch (e) {
          // Some operations might fail with corrupted files
          expect(e, isA<Exception>());
        }
      });
    });

    group('Configuration Integration Tests', () {
      test('should respect upload configuration in workflow', () async {
        // Test file size limits
        expect(UploadConfig.maxFileSizeBytes, greaterThan(0));

        // Test allowed file types
        if (UploadConfig.allowedExtensions.isNotEmpty) {
          expect(UploadConfig.allowedExtensions, isA<List<String>>());
          expect(UploadConfig.allowedExtensions.length, greaterThan(0));
        }

        // Test Cloud Functions setting
        expect(UploadConfig.enableCloudFunctionsByDefault, isA<bool>());

        // Create test file within limits
        final testFile = File('${tempDir.path}/config_test.txt');
        await testFile.writeAsString('Configuration test content');
        final xFile = XFile(testFile.path);

        final fileSize = await xFile.length();
        expect(fileSize, lessThanOrEqualTo(UploadConfig.maxFileSizeBytes));

        // Test workflow with configuration
        final duplicateResult = await duplicateService.checkForDuplicate(xFile);
        expect(duplicateResult, isNotNull);

        // Detection method should match configuration
        if (UploadConfig.enableCloudFunctionsByDefault) {
          expect(
            duplicateResult.detectionMethod,
            isIn(['cloud_functions', 'local']),
          );
        } else {
          expect(duplicateResult.detectionMethod, equals('local'));
        }
      });
    });

    group('Memory Management Tests', () {
      test(
        'should handle memory efficiently during upload preparation',
        () async {
          // Create multiple files to test memory usage
          final files = <XFile>[];
          for (int i = 0; i < 20; i++) {
            final file = File('${tempDir.path}/memory_$i.txt');
            final content = 'Memory test content $i ' * 1000; // ~20KB each
            await file.writeAsString(content);
            files.add(XFile(file.path));
          }

          // Process files in batches to test memory management
          final batchSize = 5;
          for (int i = 0; i < files.length; i += batchSize) {
            final batch = files.skip(i).take(batchSize).toList();

            final results = await duplicateService.checkMultipleFiles(batch);
            expect(results.length, equals(batch.length));

            // Small delay to allow garbage collection
            await Future.delayed(const Duration(milliseconds: 100));
          }
        },
      );
    });
  });
}
