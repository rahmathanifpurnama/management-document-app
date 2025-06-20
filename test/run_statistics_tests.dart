import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'services/statistics_notification_service_test.dart' as service_tests;
import 'widgets/home_dashboard_stats_test.dart' as widget_tests;
import 'integration/statistics_integration_test.dart' as integration_tests;

void main() {
  group('All Statistics Tests', () {
    group('Service Tests', () {
      service_tests.main();
    });

    group('Widget Tests', () {
      widget_tests.main();
    });

    group('Integration Tests', () {
      integration_tests.main();
    });
  });
}
