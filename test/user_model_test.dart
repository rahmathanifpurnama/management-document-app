import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:management_document_app/models/user_model.dart';

void main() {
  group('UserModel Tests', () {
    test('should handle empty fullName in fromFirestore', () {
      // Mock document data with empty fullName
      final mockData = {
        'fullName': '',
        'email': 'test.user@example.com',
        'role': 'user',
        'status': 'active',
        'permissions': {
          'documents': ['view'],
          'categories': [],
          'system': [],
        },
      };

      // Create a mock DocumentSnapshot
      final mockDoc = MockDocumentSnapshot('test-id', mockData);
      
      // Test that UserModel.fromFirestore handles empty fullName
      final user = UserModel.fromFirestore(mockDoc);
      
      expect(user.fullName, isNot(isEmpty));
      expect(user.fullName, equals('Test User')); // Should extract from email
      expect(user.email, equals('test.user@example.com'));
    });

    test('should handle empty fullName and email in fromFirestore', () {
      // Mock document data with empty fullName and email
      final mockData = {
        'fullName': '',
        'email': '',
        'role': 'user',
        'status': 'active',
        'permissions': {
          'documents': ['view'],
          'categories': [],
          'system': [],
        },
      };

      final mockDoc = MockDocumentSnapshot('test-id', mockData);
      final user = UserModel.fromFirestore(mockDoc);
      
      expect(user.fullName, equals('Unknown User')); // Should use fallback
      expect(user.email, isEmpty);
    });

    test('should preserve valid fullName', () {
      final mockData = {
        'fullName': 'John Doe',
        'email': 'john.doe@example.com',
        'role': 'admin',
        'status': 'active',
        'permissions': {
          'documents': ['view', 'upload', 'delete'],
          'categories': [],
          'system': ['user_management'],
        },
      };

      final mockDoc = MockDocumentSnapshot('test-id', mockData);
      final user = UserModel.fromFirestore(mockDoc);
      
      expect(user.fullName, equals('John Doe'));
      expect(user.email, equals('john.doe@example.com'));
      expect(user.role, equals('admin'));
    });
  });
}

// Mock DocumentSnapshot for testing
class MockDocumentSnapshot implements DocumentSnapshot<Map<String, dynamic>> {
  final String _id;
  final Map<String, dynamic> _data;

  MockDocumentSnapshot(this._id, this._data);

  @override
  String get id => _id;

  @override
  Map<String, dynamic>? data() => _data;

  @override
  bool get exists => true;

  // Implement other required methods with minimal implementations
  @override
  DocumentReference<Map<String, dynamic>> get reference => throw UnimplementedError();

  @override
  SnapshotMetadata get metadata => throw UnimplementedError();

  @override
  dynamic operator [](Object field) => _data[field];

  @override
  dynamic get(Object field) => _data[field];
}
