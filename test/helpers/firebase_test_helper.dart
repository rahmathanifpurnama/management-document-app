import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

/// Firebase test helper for mocking Firebase services
class FirebaseTestHelper {
  static bool _initialized = false;
  static late MockFirebaseAuth _mockAuth;
  static late FakeFirebaseFirestore _mockFirestore;
  static late MockFirebaseStorage _mockStorage;

  /// Initialize Firebase mocks for testing
  static Future<void> initializeMocks() async {
    if (_initialized) return;

    try {
      // Initialize Firebase with test configuration
      await Firebase.initializeApp(
        options: const FirebaseOptions(
          apiKey: 'test-api-key',
          appId: 'test-app-id',
          messagingSenderId: 'test-sender-id',
          projectId: 'test-project-id',
          storageBucket: 'test-project-id.appspot.com',
        ),
      );

      // Initialize mocks
      _mockAuth = MockFirebaseAuth();
      _mockFirestore = FakeFirebaseFirestore();
      _mockStorage = MockFirebaseStorage();

      _initialized = true;
      debugPrint('✅ Firebase mocks initialized for testing');
    } catch (e) {
      if (e.toString().contains('already exists')) {
        _initialized = true;
        debugPrint('✅ Firebase already initialized for testing');
      } else {
        debugPrint('❌ Failed to initialize Firebase mocks: $e');
        // Don't rethrow in test environment, just log the error
      }
    }
  }

  /// Setup Firebase mocks for test group
  static void setupFirebaseMocks() {
    setUpAll(() async {
      await initializeMocks();
    });
  }

  /// Get mock Firebase Auth instance
  static MockFirebaseAuth get mockAuth {
    if (!_initialized) {
      throw StateError(
        'Firebase mocks not initialized. Call initializeMocks() first.',
      );
    }
    return _mockAuth;
  }

  /// Get mock Firestore instance
  static FakeFirebaseFirestore get mockFirestore {
    if (!_initialized) {
      throw StateError(
        'Firebase mocks not initialized. Call initializeMocks() first.',
      );
    }
    return _mockFirestore;
  }

  /// Get mock Firebase Storage instance
  static MockFirebaseStorage get mockStorage {
    if (!_initialized) {
      throw StateError(
        'Firebase mocks not initialized. Call initializeMocks() first.',
      );
    }
    return _mockStorage;
  }

  /// Create test user in mock auth
  static Future<void> createTestUser({
    String email = 'test@example.com',
    String uid = 'test-uid-123',
    String displayName = 'Test User',
  }) async {
    await initializeMocks();

    // Mock user is automatically created when signing in with MockFirebaseAuth
    await _mockAuth.signInWithEmailAndPassword(
      email: email,
      password: 'test-password',
    );
  }

  /// Add test document to mock Firestore
  static Future<void> addTestDocument({
    required String collection,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    await initializeMocks();
    await _mockFirestore.collection(collection).doc(documentId).set(data);
  }

  /// Add test file to mock Storage
  static Future<void> addTestFile({
    required String path,
    required List<int> data,
  }) async {
    await initializeMocks();
    await _mockStorage.ref(path).putData(Uint8List.fromList(data));
  }

  /// Clear all mock data
  static Future<void> clearMockData() async {
    if (!_initialized) return;

    // Clear Firestore data
    final collections = await _mockFirestore.collection('test').get();
    for (final doc in collections.docs) {
      await doc.reference.delete();
    }

    // Clear Storage data (MockFirebaseStorage doesn't have a clear method)
    // So we'll just reinitialize it
    _mockStorage = MockFirebaseStorage();

    // Sign out from auth
    if (_mockAuth.currentUser != null) {
      await _mockAuth.signOut();
    }
  }

  /// Setup test data for common scenarios
  static Future<void> setupTestData() async {
    await initializeMocks();

    // Create test user
    await createTestUser();

    // Add test documents
    await addTestDocument(
      collection: 'documents',
      documentId: 'test-doc-1',
      data: {
        'fileName': 'test-document.pdf',
        'fileSize': 1024000,
        'fileType': 'pdf',
        'filePath': 'documents/test-document.pdf',
        'uploadedBy': 'test-uid-123',
        'uploadedAt': DateTime.now().toIso8601String(),
        'category': 'test-category',
        'isActive': true,
        'permissions': ['test-uid-123'],
        'metadata': {
          'description': 'Test document for sharing',
          'tags': ['test', 'document'],
        },
      },
    );

    // Add test categories
    await addTestDocument(
      collection: 'categories',
      documentId: 'test-category',
      data: {
        'name': 'Test Category',
        'description': 'Category for testing',
        'createdBy': 'test-uid-123',
        'createdAt': DateTime.now().toIso8601String(),
        'isActive': true,
      },
    );

    // Add test file to storage
    await addTestFile(
      path: 'documents/test-document.pdf',
      data: List.generate(1024, (index) => index % 256),
    );
  }

  /// Cleanup after tests
  static Future<void> cleanup() async {
    if (!_initialized) return;

    await clearMockData();
    debugPrint('✅ Firebase test data cleaned up');
  }

  /// Check if Firebase is initialized for testing
  static bool get isInitialized => _initialized;

  /// Reset initialization state (for testing purposes)
  static void resetInitialization() {
    _initialized = false;
  }
}
