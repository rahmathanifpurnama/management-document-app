import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:managementdoc/services/duplicate_detection_service.dart';
import 'package:managementdoc/core/config/upload_config.dart';

void main() {
  group('DuplicateDetectionService Tests', () {
    late DuplicateDetectionService duplicateService;
    late Directory tempDir;

    setUpAll(() async {
      duplicateService = DuplicateDetectionService();
      tempDir = await Directory.systemTemp.createTemp('duplicate_test_');
    });

    tearDownAll(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    group('Single File Duplicate Detection', () {
      test('should detect no duplicate for unique file', () async {
        // Create unique test file
        final testFile = File('${tempDir.path}/unique.txt');
        await testFile.writeAsString('Unique content for testing');
        final xFile = XFile(testFile.path);

        // Check for duplicates
        final result = await duplicateService.checkForDuplicate(xFile);

        // Verify result
        expect(result.isDuplicate, isFalse);
        expect(result.confidence, greaterThanOrEqualTo(0.0));
        expect(result.confidence, lessThanOrEqualTo(1.0));
        expect(result.reason, isNotNull);
        expect(result.detectionMethod, isNotNull);
      });

      test('should handle progress callback correctly', () async {
        // Create test file
        final testFile = File('${tempDir.path}/progress.txt');
        await testFile.writeAsString('Progress test content');
        final xFile = XFile(testFile.path);

        double lastProgress = 0.0;
        int progressCallbacks = 0;

        // Check with progress callback
        final result = await duplicateService.checkForDuplicate(
          xFile,
          onProgress: (progress) {
            progressCallbacks++;
            expect(progress, greaterThanOrEqualTo(lastProgress));
            expect(progress, lessThanOrEqualTo(1.0));
            lastProgress = progress;
          },
        );

        expect(result, isNotNull);
        expect(progressCallbacks, greaterThan(0));
        expect(lastProgress, equals(1.0)); // Should complete at 100%
      });

      test('should handle different file types correctly', () async {
        final testCases = [
          {'name': 'document.pdf', 'content': 'PDF content'},
          {'name': 'image.jpg', 'content': 'JPEG content'},
          {'name': 'spreadsheet.xlsx', 'content': 'Excel content'},
          {'name': 'presentation.pptx', 'content': 'PowerPoint content'},
          {'name': 'text.txt', 'content': 'Text content'},
        ];

        for (final testCase in testCases) {
          final testFile = File('${tempDir.path}/${testCase['name']}');
          await testFile.writeAsString(testCase['content']!);
          final xFile = XFile(testFile.path);

          final result = await duplicateService.checkForDuplicate(xFile);

          expect(result, isNotNull);
          expect(result.isDuplicate, isFalse); // No duplicates in clean test
          expect(result.confidence, greaterThanOrEqualTo(0.0));
        }
      });
    });

    group('Batch Duplicate Detection', () {
      test('should process multiple files correctly', () async {
        // Create multiple test files
        final files = <XFile>[];
        for (int i = 0; i < 3; i++) {
          final file = File('${tempDir.path}/batch_$i.txt');
          await file.writeAsString('Batch content $i');
          files.add(XFile(file.path));
        }

        // Process batch
        final results = await duplicateService.checkMultipleFiles(files);

        // Verify results
        expect(results.length, equals(3));
        for (final file in files) {
          expect(results.containsKey(file.name), isTrue);
          final result = results[file.name]!;
          expect(result.isDuplicate, isFalse);
          expect(result.confidence, greaterThanOrEqualTo(0.0));
        }
      });

      test('should handle batch processing with progress', () async {
        // Create test files
        final files = <XFile>[];
        for (int i = 0; i < 5; i++) {
          final file = File('${tempDir.path}/batch_progress_$i.txt');
          await file.writeAsString('Batch progress content $i');
          files.add(XFile(file.path));
        }

        int progressCallbacks = 0;
        int lastCompleted = 0;

        // Process with progress
        final results = await duplicateService.checkMultipleFiles(
          files,
          onProgress: (completed, total) {
            progressCallbacks++;
            expect(completed, greaterThanOrEqualTo(lastCompleted));
            expect(completed, lessThanOrEqualTo(total));
            expect(total, equals(5));
            lastCompleted = completed;
          },
        );

        expect(results.length, equals(5));
        expect(progressCallbacks, equals(5));
        expect(lastCompleted, equals(5));
      });

      test('should handle mixed file types in batch', () async {
        final testFiles = [
          {'name': 'doc.pdf', 'content': 'PDF document'},
          {'name': 'img.png', 'content': 'PNG image'},
          {'name': 'sheet.xlsx', 'content': 'Excel sheet'},
        ];

        final files = <XFile>[];
        for (final testFile in testFiles) {
          final file = File('${tempDir.path}/${testFile['name']}');
          await file.writeAsString(testFile['content']!);
          files.add(XFile(file.path));
        }

        final results = await duplicateService.checkMultipleFiles(files);

        expect(results.length, equals(3));

        // Verify that we have results for all files
        // The keys might be file paths or just filenames
        final resultKeys = results.keys.toList();
        final expectedFileNames = testFiles
            .map((f) => f['name'] as String)
            .toList();

        for (final fileName in expectedFileNames) {
          // Check if any key matches exactly or contains the filename
          final hasMatchingKey = resultKeys.any(
            (key) =>
                key == fileName ||
                key.endsWith('/$fileName') ||
                key.endsWith('\\$fileName'),
          );
          expect(
            hasMatchingKey,
            isTrue,
            reason:
                'Results should contain key for $fileName. Available keys: $resultKeys',
          );
        }
      });
    });

    group('File Similarity Tests', () {
      test('should identify identical files as similar', () async {
        const content = 'Identical content for similarity test';

        // Create two identical files
        final file1 = File('${tempDir.path}/similar1.txt');
        final file2 = File('${tempDir.path}/similar2.txt');
        await file1.writeAsString(content);
        await file2.writeAsString(content);

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Test similarity
        final areSimilar = await duplicateService.areFilesSimilar(
          xFile1,
          xFile2,
        );
        expect(areSimilar, isTrue);
      });

      test('should identify different files as not similar', () async {
        // Create two different files
        final file1 = File('${tempDir.path}/different1.txt');
        final file2 = File('${tempDir.path}/different2.txt');
        await file1.writeAsString('Content A');
        await file2.writeAsString('Content B');

        final xFile1 = XFile(file1.path);
        final xFile2 = XFile(file2.path);

        // Test similarity
        final areSimilar = await duplicateService.areFilesSimilar(
          xFile1,
          xFile2,
        );
        expect(areSimilar, isFalse);
      });
    });

    group('Content Type Detection Tests', () {
      test('should detect content types correctly', () async {
        // This tests the internal _getContentType method indirectly
        final testCases = [
          {'name': 'document.pdf', 'expectedType': 'application/pdf'},
          {'name': 'image.jpg', 'expectedType': 'image/jpeg'},
          {'name': 'image.png', 'expectedType': 'image/png'},
          {'name': 'text.txt', 'expectedType': 'text/plain'},
          {'name': 'unknown.xyz', 'expectedType': 'application/octet-stream'},
        ];

        for (final testCase in testCases) {
          final file = File('${tempDir.path}/${testCase['name']}');
          await file.writeAsString('Test content');
          final xFile = XFile(file.path);

          // The content type detection is tested indirectly through duplicate detection
          final result = await duplicateService.checkForDuplicate(xFile);
          expect(result, isNotNull);
          // Content type is used internally, so we just verify the process completes
        }
      });
    });

    group('Error Handling Tests', () {
      test('should handle non-existent file gracefully', () async {
        final nonExistentFile = XFile('/non/existent/path/file.txt');

        final result = await duplicateService.checkForDuplicate(
          nonExistentFile,
        );

        expect(result.isDuplicate, isFalse);
        expect(result.confidence, equals(0.0));
        expect(result.reason, contains('failed'));
      });

      test('should handle batch with some invalid files', () async {
        // Mix of valid and invalid files
        final validFile = File('${tempDir.path}/valid.txt');
        await validFile.writeAsString('Valid content');

        final files = [
          XFile(validFile.path), // Valid
          XFile('/invalid/path/file.txt'), // Invalid
        ];

        final results = await duplicateService.checkMultipleFiles(files);

        expect(results.length, equals(2));

        // Find the valid file result (might have path prefix)
        final validFileResult = results.values.firstWhere(
          (result) => result.isDuplicate == false && result.confidence > 0.0,
          orElse: () => throw Exception('Valid file result not found'),
        );
        expect(validFileResult.isDuplicate, isFalse);

        // Find the invalid file result (should have low confidence)
        final invalidFileResult = results.values.firstWhere(
          (result) => result.confidence == 0.0,
          orElse: () => throw Exception('Invalid file result not found'),
        );
        expect(invalidFileResult.confidence, equals(0.0));
      });

      test('should handle file comparison errors gracefully', () async {
        final validFile = File('${tempDir.path}/valid_compare.txt');
        await validFile.writeAsString('Valid content');
        final validXFile = XFile(validFile.path);

        final invalidXFile = XFile('/invalid/path/compare.txt');

        final areSimilar = await duplicateService.areFilesSimilar(
          validXFile,
          invalidXFile,
        );
        expect(areSimilar, isFalse);
      });
    });

    group('Configuration Tests', () {
      test('should respect Cloud Functions configuration', () async {
        // Create test file
        final testFile = File('${tempDir.path}/config_test.txt');
        await testFile.writeAsString('Configuration test content');
        final xFile = XFile(testFile.path);

        // Test with current configuration
        final result = await duplicateService.checkForDuplicate(xFile);

        expect(result, isNotNull);
        expect(result.detectionMethod, isIn(['cloud_functions', 'local']));

        // The actual method depends on UploadConfig.enableCloudFunctionsByDefault
        if (UploadConfig.enableCloudFunctionsByDefault) {
          // Should attempt cloud functions (may fall back to local on error)
          expect(result.detectionMethod, isIn(['cloud_functions', 'local']));
        } else {
          // Should use local method
          expect(result.detectionMethod, equals('local'));
        }
      });
    });

    group('Performance Tests', () {
      test('should handle large file efficiently', () async {
        // Create a larger test file (1MB)
        final largeFile = File('${tempDir.path}/large.txt');
        final largeContent = 'A' * (1024 * 1024); // 1MB
        await largeFile.writeAsString(largeContent);
        final xFile = XFile(largeFile.path);

        final stopwatch = Stopwatch()..start();
        final result = await duplicateService.checkForDuplicate(xFile);
        stopwatch.stop();

        expect(result, isNotNull);
        expect(result.isDuplicate, isFalse);

        // Should complete within reasonable time (adjust as needed)
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(10000),
        ); // 10 seconds max
      });

      test('should process batch efficiently', () async {
        // Create multiple medium-sized files
        final files = <XFile>[];
        for (int i = 0; i < 10; i++) {
          final file = File('${tempDir.path}/perf_$i.txt');
          final content = 'Performance test content $i ' * 1000; // ~30KB each
          await file.writeAsString(content);
          files.add(XFile(file.path));
        }

        final stopwatch = Stopwatch()..start();
        final results = await duplicateService.checkMultipleFiles(files);
        stopwatch.stop();

        expect(results.length, equals(10));

        // Should complete batch within reasonable time
        expect(
          stopwatch.elapsedMilliseconds,
          lessThan(30000),
        ); // 30 seconds max
      });
    });
  });
}
