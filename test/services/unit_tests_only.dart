import 'package:flutter_test/flutter_test.dart';

// Import only the tests that don't require Firebase
import 'file_hash_service_test.dart' as file_hash_tests;
import 'duplicate_detection_service_test.dart' as duplicate_detection_tests;

void main() {
  group('Unit Tests Only (No Firebase)', () {
    group('File Hash Service Tests', () {
      file_hash_tests.main();
    });

    group('Duplicate Detection Service Tests', () {
      duplicate_detection_tests.main();
    });
  });
}
