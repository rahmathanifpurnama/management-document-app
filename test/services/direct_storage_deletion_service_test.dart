import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../lib/services/direct_storage_deletion_service.dart';
import '../../lib/core/services/firebase_service.dart';
import '../../lib/services/admin_permission_service.dart';

// Generate mocks
@GenerateMocks([
  FirebaseService,
  AdminPermissionService,
  FirebaseStorage,
  Reference,
  FullMetadata,
])
import 'direct_storage_deletion_service_test.mocks.dart';

void main() {
  group('DirectStorageDeletionService', () {
    late DirectStorageDeletionService service;
    late MockFirebaseService mockFirebaseService;
    late MockAdminPermissionService mockAdminService;
    late MockFirebaseStorage mockStorage;
    late MockReference mockReference;

    setUp(() {
      mockFirebaseService = MockFirebaseService();
      mockAdminService = MockAdminPermissionService();
      mockStorage = MockFirebaseStorage();
      mockReference = MockReference();
      
      service = DirectStorageDeletionService.instance;
    });

    group('Path Validation', () {
      test('should validate correct storage path', () {
        const validPath = 'documents/user123/file.pdf';
        final result = service._validateStoragePath(validPath);
        expect(result.isValid, isTrue);
      });

      test('should reject empty path', () {
        const emptyPath = '';
        final result = service._validateStoragePath(emptyPath);
        expect(result.isValid, isFalse);
        expect(result.message, contains('empty'));
      });

      test('should reject path with leading slash', () {
        const invalidPath = '/documents/file.pdf';
        final result = service._validateStoragePath(invalidPath);
        expect(result.isValid, isFalse);
        expect(result.message, contains('forward slash'));
      });

      test('should reject path with trailing slash', () {
        const invalidPath = 'documents/file.pdf/';
        final result = service._validateStoragePath(invalidPath);
        expect(result.isValid, isFalse);
        expect(result.message, contains('forward slash'));
      });

      test('should reject path with double dots', () {
        const invalidPath = 'documents/../file.pdf';
        final result = service._validateStoragePath(invalidPath);
        expect(result.isValid, isFalse);
        expect(result.message, contains('invalid characters'));
      });

      test('should reject path without file extension', () {
        const invalidPath = 'documents/file';
        final result = service._validateStoragePath(invalidPath);
        expect(result.isValid, isFalse);
        expect(result.message, contains('file extension'));
      });
    });

    group('Result Classes', () {
      test('StorageDeletionResult.success should create successful result', () {
        final result = StorageDeletionResult.success(
          path: 'test/file.pdf',
          message: 'Success',
          fileName: 'file.pdf',
          fileSize: 1024,
        );

        expect(result.success, isTrue);
        expect(result.path, equals('test/file.pdf'));
        expect(result.message, equals('Success'));
        expect(result.fileName, equals('file.pdf'));
        expect(result.fileSize, equals(1024));
        expect(result.errorCode, isNull);
      });

      test('StorageDeletionResult.error should create error result', () {
        final result = StorageDeletionResult.error(
          path: 'test/file.pdf',
          message: 'Error occurred',
          errorCode: 'TEST_ERROR',
        );

        expect(result.success, isFalse);
        expect(result.path, equals('test/file.pdf'));
        expect(result.message, equals('Error occurred'));
        expect(result.errorCode, equals('TEST_ERROR'));
        expect(result.fileName, isNull);
        expect(result.fileSize, isNull);
      });

      test('StorageDeletionResult.unauthorized should create unauthorized result', () {
        final result = StorageDeletionResult.unauthorized(
          path: 'test/file.pdf',
          message: 'Not authorized',
        );

        expect(result.success, isFalse);
        expect(result.path, equals('test/file.pdf'));
        expect(result.message, equals('Not authorized'));
        expect(result.errorCode, equals('UNAUTHORIZED'));
      });

      test('StorageDeletionResult.notFound should create not found result', () {
        final result = StorageDeletionResult.notFound(
          path: 'test/file.pdf',
          message: 'File not found',
        );

        expect(result.success, isFalse);
        expect(result.path, equals('test/file.pdf'));
        expect(result.message, equals('File not found'));
        expect(result.errorCode, equals('NOT_FOUND'));
      });
    });

    group('BatchDeletionResult', () {
      test('should calculate success status correctly', () {
        final successResult = StorageDeletionResult.success(
          path: 'test1.pdf',
          message: 'Success',
        );
        final errorResult = StorageDeletionResult.error(
          path: 'test2.pdf',
          message: 'Error',
        );

        final batchResult = BatchDeletionResult(
          results: [successResult, errorResult],
          totalFiles: 2,
          successCount: 1,
          failureCount: 1,
          completed: true,
        );

        expect(batchResult.success, isFalse); // Has failures
        expect(batchResult.successfulDeletions.length, equals(1));
        expect(batchResult.failedDeletions.length, equals(1));
      });

      test('should create unauthorized batch result', () {
        final result = BatchDeletionResult.unauthorized(
          paths: ['test1.pdf', 'test2.pdf'],
          message: 'Not authorized',
        );

        expect(result.success, isFalse);
        expect(result.totalFiles, equals(2));
        expect(result.successCount, equals(0));
        expect(result.failureCount, equals(2));
        expect(result.completed, isFalse);
        expect(result.errorMessage, equals('Not authorized'));
      });
    });

    group('StorageFileInfo', () {
      test('should format file size correctly', () {
        final fileInfo = StorageFileInfo.success(
          path: 'test.pdf',
          name: 'test.pdf',
          size: 1536, // 1.5 KB
          contentType: 'application/pdf',
        );

        expect(fileInfo.formattedSize, equals('1.5 KB'));
      });

      test('should handle unknown file size', () {
        final fileInfo = StorageFileInfo.success(
          path: 'test.pdf',
          name: 'test.pdf',
          size: null,
          contentType: 'application/pdf',
        );

        expect(fileInfo.formattedSize, equals('Unknown'));
      });

      test('should format large file sizes correctly', () {
        final fileInfo = StorageFileInfo.success(
          path: 'test.pdf',
          name: 'test.pdf',
          size: 1073741824, // 1 GB
          contentType: 'application/pdf',
        );

        expect(fileInfo.formattedSize, equals('1.0 GB'));
      });
    });

    group('AdminPermissionResult', () {
      test('should create authorized result', () {
        final result = AdminPermissionResult(
          isAuthorized: true,
          message: 'Admin verified',
          userId: 'user123',
        );

        expect(result.isAuthorized, isTrue);
        expect(result.message, equals('Admin verified'));
        expect(result.userId, equals('user123'));
      });

      test('should create unauthorized result', () {
        final result = AdminPermissionResult(
          isAuthorized: false,
          message: 'Not admin',
        );

        expect(result.isAuthorized, isFalse);
        expect(result.message, equals('Not admin'));
        expect(result.userId, isNull);
      });
    });

    group('PathValidationResult', () {
      test('should create valid result', () {
        final result = PathValidationResult(
          isValid: true,
          message: 'Path is valid',
        );

        expect(result.isValid, isTrue);
        expect(result.message, equals('Path is valid'));
      });

      test('should create invalid result', () {
        final result = PathValidationResult(
          isValid: false,
          message: 'Path is invalid',
        );

        expect(result.isValid, isFalse);
        expect(result.message, equals('Path is invalid'));
      });
    });

    group('FileExistenceResult', () {
      test('should create exists result', () {
        final result = FileExistenceResult(
          exists: true,
          message: 'File exists',
        );

        expect(result.exists, isTrue);
        expect(result.message, equals('File exists'));
      });

      test('should create not exists result', () {
        final result = FileExistenceResult(
          exists: false,
          message: 'File does not exist',
        );

        expect(result.exists, isFalse);
        expect(result.message, equals('File does not exist'));
      });
    });
  });
}
