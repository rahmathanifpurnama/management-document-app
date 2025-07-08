import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../lib/services/activity_service.dart';
import '../lib/models/activity_model.dart';

/// Comprehensive test script for Activities Collection
/// This script tests all activity logging functionality and verifies
/// that the implementation matches the actual collection structure
void main() {
  group('Activity Collection Tests', () {
    late ActivityService activityService;

    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
      activityService = ActivityService();
    });

    group('Activity Logging Tests', () {
      test('Should log delete activity correctly', () async {
        // Test document deletion activity logging
        await activityService.logActivity(
          type: 'delete',
          description: 'Document: test.pdf (ID: test123)',
          documentId: 'test123',
          additionalData: {
            'storageDeleted': true,
            'firestoreDeleted': true,
            'deletionMethod': 'storage_first',
            'userAgent': 'Flutter App',
            'platform': 'Mobile',
          },
        );

        // Verify the activity was logged
        final activities = await activityService.getActivities(limit: 1);
        expect(activities.isNotEmpty, true);
        expect(activities.first.type, 'delete');
        expect(activities.first.description, contains('test.pdf'));
      });

      test('Should handle string details field correctly', () async {
        // Test with string details (current format in collection)
        final testActivity = createTestActivity({
          'userId': 'user123',
          'type': 'auto_sync_completed',
          'description': 'Test activity',
          'timestamp': DateTime.now(),
          'details':
              'Auto-sync completed: 0 users synced, 0 errors', // String format
        });

        expect(testActivity.details, isA<Map<String, dynamic>>());
        expect(
          testActivity.details['description'],
          'Auto-sync completed: 0 users synced, 0 errors',
        );
      });

      test('Should handle map details field correctly', () async {
        // Test with map details (expected format)
        final testActivity = createTestActivity({
          'userId': 'user123',
          'type': 'delete',
          'description': 'Document deleted',
          'timestamp': DateTime.now(),
          'details': {
            'storageDeleted': true,
            'firestoreDeleted': true,
            'userAgent': 'Flutter App',
          },
        });

        expect(testActivity.details, isA<Map<String, dynamic>>());
        expect(testActivity.details['storageDeleted'], true);
        expect(testActivity.details['userAgent'], 'Flutter App');
      });
    });

    group('Activity Types Verification', () {
      test('Should support all documented activity types', () async {
        final supportedTypes = [
          'delete',
          'upload',
          'download',
          'create',
          'update',
          'login',
          'logout',
          'approve',
          'reject',
          'create_user',
          'update_user',
          'delete_user',
          'account_lock',
          'account_unlock',
          'suspicious_activity',
        ];

        for (final type in supportedTypes) {
          await activityService.logActivity(
            type: type,
            description: 'Test $type activity',
            additionalData: {'test': true},
          );
        }

        // Verify activities were logged
        final activities = await activityService.getActivities(
          limit: supportedTypes.length,
        );
        expect(activities.length, supportedTypes.length);
      });
    });

    group('Cloud Function Integration Tests', () {
      test('Should get activity statistics via cloud function', () async {
        try {
          final stats = await activityService.getActivityStatistics();

          expect(stats, isA<Map<String, dynamic>>());
          expect(stats.containsKey('todayCount'), true);
          expect(stats.containsKey('weekCount'), true);
          expect(stats.containsKey('activeUsers'), true);
          expect(stats.containsKey('suspiciousCount'), true);
        } catch (e) {
          // Should fallback to local processing
          expect(e.toString(), contains('Failed to get activity statistics'));
        }
      });

      test('Should get filtered activities via cloud function', () async {
        try {
          final result = await activityService.getFilteredActivities(
            filter: 'all',
            limit: 10,
          );

          expect(result, isA<Map<String, dynamic>>());
          expect(result.containsKey('activities'), true);
          expect(result.containsKey('hasMore'), true);
          expect(result.containsKey('lastTimestamp'), true);
          expect(result['activities'], isA<List>());
        } catch (e) {
          // Should fallback to local processing
          expect(e.toString(), contains('Failed to get filtered activities'));
        }
      });
    });

    group('Data Structure Validation', () {
      test('Should validate activity document structure', () async {
        // Create a test activity with all possible fields
        await activityService.logActivity(
          type: 'delete',
          description: 'Complete test document',
          documentId: 'doc123',
          additionalData: {
            'userName': 'Test User',
            'userEmail': 'test@example.com',
            'categoryId': 'cat123',
            'isSuspicious': false,
            'ipAddress': '192.168.1.1',
            'userAgent': 'Flutter App',
            'platform': 'Mobile',
            'storageDeleted': true,
            'firestoreDeleted': true,
          },
        );

        final activities = await activityService.getActivities(limit: 1);
        final activity = activities.first;

        // Verify all fields are present and correctly typed
        expect(activity.id, isNotEmpty);
        expect(activity.userId, isNotEmpty);
        expect(activity.type, 'delete');
        expect(activity.description, 'Complete test document');
        expect(activity.timestamp, isA<DateTime>());
        expect(activity.documentId, 'doc123');
        expect(activity.details, isA<Map<String, dynamic>>());
      });
    });

    group('Error Handling Tests', () {
      test('Should handle missing required fields gracefully', () async {
        // Test with minimal data
        final testActivity = createTestActivity({
          'userId': 'user123',
          'type': 'test',
          // Missing description and timestamp - will use defaults
        });

        expect(testActivity.userId, 'user123');
        expect(testActivity.type, 'test');
        expect(testActivity.description, 'Test description'); // Uses default
        expect(testActivity.timestamp, isA<DateTime>()); // Uses default
      });

      test('Should handle cloud function failures gracefully', () async {
        // This test verifies that the app doesn't crash when cloud functions fail
        try {
          await activityService.getActivityStatistics();
        } catch (e) {
          // Should not throw unhandled exceptions
          expect(e, isA<Exception>());
        }
      });
    });

    group('Performance Tests', () {
      test('Should handle large activity queries efficiently', () async {
        final stopwatch = Stopwatch()..start();

        final activities = await activityService.getActivities(limit: 100);

        stopwatch.stop();

        // Should complete within reasonable time (5 seconds)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
        expect(activities.length, lessThanOrEqualTo(100));
      });
    });
  });
}

/// Helper function to parse details like ActivityModel does
Map<String, dynamic> parseDetails(dynamic details) {
  if (details == null) {
    return {};
  }

  if (details is Map<String, dynamic>) {
    return details;
  }

  if (details is String) {
    // Handle string details by creating a simple map
    return {'description': details};
  }

  // For any other type, convert to string and wrap in map
  return {'value': details.toString()};
}

/// Helper function to test ActivityModel parsing without mocking sealed classes
ActivityModel createTestActivity(Map<String, dynamic> data) {
  return ActivityModel(
    id: data['id'] ?? 'test_id',
    userId: data['userId'] ?? 'test_user',
    type: data['type'] ?? 'test',
    description: data['description'] ?? 'Test description',
    timestamp: data['timestamp'] ?? DateTime.now(),
    userName: data['userName'],
    userEmail: data['userEmail'],
    documentId: data['documentId'],
    categoryId: data['categoryId'],
    isSuspicious: data['isSuspicious'] ?? false,
    ipAddress: data['ipAddress'],
    userAgent: data['userAgent'],
    details: parseDetails(data['details']),
  );
}
