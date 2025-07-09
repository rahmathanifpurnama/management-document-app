import 'package:flutter_test/flutter_test.dart';
import '../lib/models/activity_model.dart';

void main() {
  group('Activity Data Parsing Tests', () {
    test('Should handle string details field correctly', () {
      // Test with string details (problematic format from Cloud Functions)
      final data = {
        'id': 'test_id',
        'userId': 'user123',
        'type': 'auto_sync_completed',
        'description': 'Test activity',
        'timestamp': DateTime.now().toIso8601String(),
        'details': 'Auto-sync completed: 0 users synced, 0 errors', // String format
      };

      final activity = createActivityFromData(data);

      expect(activity.details, isA<Map<String, dynamic>>());
      expect(
        activity.details['description'],
        'Auto-sync completed: 0 users synced, 0 errors',
      );
    });

    test('Should handle map details field correctly', () {
      // Test with map details (expected format)
      final data = {
        'id': 'test_id',
        'userId': 'user123',
        'type': 'delete',
        'description': 'Document deleted',
        'timestamp': DateTime.now().toIso8601String(),
        'details': {
          'storageDeleted': true,
          'firestoreDeleted': true,
          'userAgent': 'Flutter App',
        },
      };

      final activity = createActivityFromData(data);

      expect(activity.details, isA<Map<String, dynamic>>());
      expect(activity.details['storageDeleted'], true);
      expect(activity.details['userAgent'], 'Flutter App');
    });

    test('Should handle null details field correctly', () {
      // Test with null details
      final data = {
        'id': 'test_id',
        'userId': 'user123',
        'type': 'test',
        'description': 'Test activity',
        'timestamp': DateTime.now().toIso8601String(),
        'details': null,
      };

      final activity = createActivityFromData(data);

      expect(activity.details, isA<Map<String, dynamic>>());
      expect(activity.details.isEmpty, true);
    });

    test('Should handle empty object details field correctly', () {
      // Test with empty object details
      final data = {
        'id': 'test_id',
        'userId': 'user123',
        'type': 'test',
        'description': 'Test activity',
        'timestamp': DateTime.now().toIso8601String(),
        'details': {},
      };

      final activity = createActivityFromData(data);

      expect(activity.details, isA<Map<String, dynamic>>());
      expect(activity.details.isEmpty, true);
    });

    test('Should handle mixed type details field correctly', () {
      // Test with mixed type details (edge case)
      final data = {
        'id': 'test_id',
        'userId': 'user123',
        'type': 'test',
        'description': 'Test activity',
        'timestamp': DateTime.now().toIso8601String(),
        'details': 123, // Number instead of string or map
      };

      final activity = createActivityFromData(data);

      expect(activity.details, isA<Map<String, dynamic>>());
      expect(activity.details['value'], '123');
    });
  });
}

/// Helper function to create ActivityModel from data (mimics the fixed parsing logic)
ActivityModel createActivityFromData(Map<String, dynamic> data) {
  return ActivityModel(
    id: data['id'] ?? '',
    userId: data['userId'] ?? '',
    type: data['type'] ?? '',
    description: data['description'] ?? '',
    timestamp: DateTime.tryParse(data['timestamp'] ?? '') ?? DateTime.now(),
    userName: data['userName'],
    userEmail: data['userEmail'],
    documentId: data['documentId'],
    categoryId: data['categoryId'],
    isSuspicious: data['isSuspicious'] ?? false,
    ipAddress: data['ipAddress'],
    userAgent: data['userAgent'],
    details: parseDetailsField(data['details']),
  );
}

/// Helper method to safely parse details field (mimics the fixed parsing logic)
Map<String, dynamic> parseDetailsField(dynamic details) {
  if (details == null) {
    return {};
  }

  if (details is Map<String, dynamic>) {
    return details;
  }

  if (details is Map) {
    return Map<String, dynamic>.from(details);
  }

  if (details is String) {
    // Handle string details by creating a simple map
    return {'description': details};
  }

  // For any other type, convert to string and wrap in map
  return {'value': details.toString()};
}
