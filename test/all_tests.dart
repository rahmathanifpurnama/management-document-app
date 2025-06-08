import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'services/file_hash_service_test.dart' as file_hash_tests;
import 'services/duplicate_detection_service_test.dart' as duplicate_detection_tests;
import 'services/cloud_functions_integration_test.dart' as cloud_functions_tests;
import 'services/upload_integration_test.dart' as upload_integration_tests;

void main() {
  group('All Tests Suite', () {
    group('File Hash Service Tests', () {
      file_hash_tests.main();
    });

    group('Duplicate Detection Service Tests', () {
      duplicate_detection_tests.main();
    });

    group('Cloud Functions Integration Tests', () {
      cloud_functions_tests.main();
    });

    group('Upload Integration Tests', () {
      upload_integration_tests.main();
    });
  });
}
