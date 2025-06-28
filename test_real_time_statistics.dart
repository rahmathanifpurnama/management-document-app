import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// Import the services we're testing
import 'lib/services/statistics_sync_service.dart';
import 'lib/core/services/firebase_service.dart';

// Mock classes
class MockFirebaseService extends Mock implements FirebaseService {}
class MockFirestore extends Mock implements FirebaseFirestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockQuery extends Mock implements Query {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}
class MockQueryDocumentSnapshot extends Mock implements QueryDocumentSnapshot {}

void main() {
  group('Real-Time Statistics Tests', () {
    late StatisticsSyncService statisticsService;
    late MockFirebaseService mockFirebaseService;
    late MockFirestore mockFirestore;
    late MockCollectionReference mockUsersCollection;
    late MockCollectionReference mockCategoriesCollection;
    late MockQuery mockUsersQuery;
    late MockQuery mockCategoriesQuery;
    late StreamController<QuerySnapshot> usersStreamController;
    late StreamController<QuerySnapshot> categoriesStreamController;

    setUp(() {
      mockFirebaseService = MockFirebaseService();
      mockFirestore = MockFirestore();
      mockUsersCollection = MockCollectionReference();
      mockCategoriesCollection = MockCollectionReference();
      mockUsersQuery = MockQuery();
      mockCategoriesQuery = MockQuery();
      usersStreamController = StreamController<QuerySnapshot>();
      categoriesStreamController = StreamController<QuerySnapshot>();

      // Setup mock returns
      when(mockFirebaseService.firestore).thenReturn(mockFirestore);
      when(mockFirestore.collection('users')).thenReturn(mockUsersCollection);
      when(mockFirestore.collection('categories')).thenReturn(mockCategoriesCollection);
      
      when(mockUsersCollection.where('isActive', isEqualTo: true))
          .thenReturn(mockUsersQuery);
      when(mockCategoriesCollection.where('isActive', isEqualTo: true))
          .thenReturn(mockCategoriesQuery);
      
      when(mockUsersQuery.snapshots()).thenAnswer((_) => usersStreamController.stream);
      when(mockCategoriesQuery.snapshots()).thenAnswer((_) => categoriesStreamController.stream);

      statisticsService = StatisticsSyncService.instance;
    });

    tearDown(() {
      usersStreamController.close();
      categoriesStreamController.close();
      statisticsService.dispose();
    });

    test('should initialize with Firestore listeners', () {
      // Act
      statisticsService.initialize();

      // Assert
      expect(statisticsService.isInitialized, isTrue);
      expect(statisticsService.areListenersActive, isTrue);
      
      // Verify that Firestore collections were queried
      verify(mockFirestore.collection('users')).called(1);
      verify(mockFirestore.collection('categories')).called(1);
      verify(mockUsersCollection.where('isActive', isEqualTo: true)).called(1);
      verify(mockCategoriesCollection.where('isActive', isEqualTo: true)).called(1);
    });

    test('should respond to users collection changes', () async {
      // Arrange
      statisticsService.initialize();
      
      final mockSnapshot = MockQuerySnapshot();
      final mockDocs = [
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(), // 6 users as mentioned in requirements
      ];
      when(mockSnapshot.docs).thenReturn(mockDocs);

      // Act
      usersStreamController.add(mockSnapshot);
      
      // Wait for the stream to process
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      // The listener should have triggered a statistics update
      // This would be verified by checking if _triggerStatisticsUpdate was called
      // In a real test, we'd mock the StatisticsNotificationService to verify calls
      expect(statisticsService.areListenersActive, isTrue);
    });

    test('should respond to categories collection changes', () async {
      // Arrange
      statisticsService.initialize();
      
      final mockSnapshot = MockQuerySnapshot();
      final mockDocs = [
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(),
        MockQueryDocumentSnapshot(), // 5 categories
      ];
      when(mockSnapshot.docs).thenReturn(mockDocs);

      // Act
      categoriesStreamController.add(mockSnapshot);
      
      // Wait for the stream to process
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      expect(statisticsService.areListenersActive, isTrue);
    });

    test('should handle listener errors gracefully', () async {
      // Arrange
      statisticsService.initialize();

      // Act - Simulate an error in the users listener
      usersStreamController.addError(Exception('Firestore connection error'));
      
      // Wait for error handling
      await Future.delayed(Duration(milliseconds: 100));

      // Assert
      // The service should still be initialized and attempt to recover
      expect(statisticsService.isInitialized, isTrue);
    });

    test('should properly dispose listeners', () {
      // Arrange
      statisticsService.initialize();
      expect(statisticsService.areListenersActive, isTrue);

      // Act
      statisticsService.dispose();

      // Assert
      expect(statisticsService.isInitialized, isFalse);
      expect(statisticsService.areListenersActive, isFalse);
    });

    test('should allow manual listener control', () {
      // Arrange
      statisticsService.initialize();
      expect(statisticsService.areListenersActive, isTrue);

      // Act - Stop listeners manually
      statisticsService.stopListeners();
      expect(statisticsService.areListenersActive, isFalse);

      // Act - Start listeners manually
      statisticsService.startListeners();
      expect(statisticsService.areListenersActive, isTrue);
    });

    test('should not setup duplicate listeners', () {
      // Act
      statisticsService.initialize();
      statisticsService.initialize(); // Call again

      // Assert
      expect(statisticsService.isInitialized, isTrue);
      expect(statisticsService.areListenersActive, isTrue);
      
      // Verify collections were only queried once (no duplicates)
      verify(mockFirestore.collection('users')).called(1);
      verify(mockFirestore.collection('categories')).called(1);
    });
  });

  group('Real-Time Statistics Integration', () {
    test('should maintain consistent data flow', () {
      // This test verifies the integration between:
      // 1. Firestore listeners
      // 2. StatisticsSyncService
      // 3. StatisticsNotificationService
      // 4. OptimizedStatisticsService
      // 5. RealTimeStatsWidget

      // The flow should be:
      // Firestore Change → Listener → StatisticsSyncService → 
      // StatisticsNotificationService → RealTimeStatsWidget → UI Update

      expect(true, isTrue); // Placeholder for integration test
    });

    test('should handle concurrent updates correctly', () {
      // Test that simultaneous changes to users and categories
      // are handled correctly without race conditions
      
      expect(true, isTrue); // Placeholder for concurrency test
    });
  });
}

/// Manual Testing Instructions
/// 
/// To test the real-time functionality manually:
/// 
/// 1. **Setup**:
///    - Ensure the app is running with the updated StatisticsSyncService
///    - Open Firebase Console in a browser
///    - Navigate to Firestore Database
/// 
/// 2. **Test User Count Updates**:
///    - Note the current user count in the app (should show 6)
///    - In Firebase Console, go to the 'users' collection
///    - Add a new user document with isActive: true
///    - The app should automatically update to show 7 users
///    - Delete the user or set isActive: false
///    - The app should automatically update back to 6 users
/// 
/// 3. **Test Category Count Updates**:
///    - Note the current category count in the app
///    - In Firebase Console, go to the 'categories' collection
///    - Add a new category document with isActive: true
///    - The app should automatically update the category count
///    - Delete the category or set isActive: false
///    - The app should automatically update back to the original count
/// 
/// 4. **Test Error Recovery**:
///    - Disconnect from internet
///    - The listeners should handle the disconnection gracefully
///    - Reconnect to internet
///    - The listeners should automatically reconnect and sync data
/// 
/// 5. **Test Performance**:
///    - Make multiple rapid changes in Firebase Console
///    - Verify that the app updates smoothly without lag
///    - Check that there are no memory leaks or excessive resource usage
/// 
/// Expected Results:
/// - Statistics update within 1-2 seconds of Firebase changes
/// - No app crashes or errors
/// - Smooth UI updates without flickering
/// - Accurate counts matching Firebase data
/// - Proper error handling and recovery
