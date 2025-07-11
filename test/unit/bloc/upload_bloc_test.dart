import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:managementdoc/features/upload/bloc/upload_bloc.dart';
import 'package:managementdoc/features/upload/bloc/upload_state.dart';
import 'package:managementdoc/features/upload/bloc/upload_event.dart'
    as upload_events;
import 'package:managementdoc/features/upload/repositories/upload_repository.dart';
import 'package:managementdoc/features/upload/models/upload_file_model.dart';
import 'package:managementdoc/models/upload_result_model.dart';

import 'upload_bloc_test.mocks.dart';

@GenerateMocks([UploadRepository])
void main() {
  group('UploadBloc Tests', () {
    late UploadBloc uploadBloc;
    late MockUploadRepository mockRepository;

    setUp(() {
      mockRepository = MockUploadRepository();
      uploadBloc = UploadBloc(repository: mockRepository);
    });

    tearDown(() {
      uploadBloc.close();
    });

    test('initial state is UploadInitial', () {
      expect(uploadBloc.state, equals(const UploadState.initial()));
    });

    blocTest<UploadBloc, UploadState>(
      'emits [uploading, success] when StartUpload is added with valid files',
      build: () {
        when(
          mockRepository.uploadFiles(argThat(isA<List<UploadFileModel>>())),
        ).thenAnswer((_) async => [_createMockUploadResult()]);
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(files: [_createMockUploadFile()]),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadSuccess>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits [uploading, error] when repository throws exception',
      build: () {
        when(
          mockRepository.uploadFiles(argThat(isA<List<UploadFileModel>>())),
        ).thenThrow(Exception('Upload failed'));
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(files: [_createMockUploadFile()]),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadError>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'emits progress updates during upload',
      build: () {
        final mockFile = _createMockUploadFile();
        when(
          mockRepository.uploadFilesWithProgress([mockFile]),
        ).thenAnswer((_) async => [_createMockUploadResult()]);
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(files: [_createMockUploadFile()]),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadSuccess>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'handles multiple file uploads correctly',
      build: () {
        when(
          mockRepository.uploadFiles(argThat(isA<List<UploadFileModel>>())),
        ).thenAnswer(
          (_) async => [
            _createMockUploadResult(fileName: 'file1.pdf'),
            _createMockUploadResult(fileName: 'file2.docx'),
          ],
        );
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(
          files: [
            _createMockUploadFile(fileName: 'file1.pdf'),
            _createMockUploadFile(fileName: 'file2.docx'),
          ],
        ),
      ),
      expect: () => [
        UploadState.uploading(
          files: [
            _createMockUploadFile(fileName: 'file1.pdf'),
            _createMockUploadFile(fileName: 'file2.docx'),
          ],
          activeUploads: 2,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 2,
          overallProgress: 0.0,
        ),
        isA<UploadSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as UploadSuccess;
        expect(state.uploadedFiles.length, 2);
      },
    );

    blocTest<UploadBloc, UploadState>(
      'cancels upload when CancelUpload is added',
      build: () {
        when(
          mockRepository.cancelUpload('test-file-id'),
        ).thenAnswer((_) async => {});
        return uploadBloc;
      },
      act: (bloc) => bloc
        ..add(
          upload_events.UploadEvent.startUpload(
            files: [_createMockUploadFile()],
          ),
        )
        ..add(const upload_events.UploadEvent.cancelUpload()),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        UploadState.cancelled(
          files: [_createMockUploadFile()],
          completedFiles: 0,
          cancelledFiles: 1,
        ),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'validates files before upload',
      build: () => uploadBloc,
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.validateFiles(
          files: [], // Empty list for validation test
        ),
      ),
      expect: () => [isA<UploadValidationError>()],
    );

    blocTest<UploadBloc, UploadState>(
      'retries failed uploads when RetryUpload is added',
      build: () {
        when(
          mockRepository.retryFailedUploads(any),
        ).thenAnswer((_) async => [_createMockUploadResult()]);
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.retryUpload(
          failedFiles: [_createMockUploadFile()],
        ),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadSuccess>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'handles partial upload failures correctly',
      build: () {
        when(mockRepository.uploadFiles(any)).thenAnswer(
          (_) async => [
            _createMockUploadResult(fileName: 'file1.pdf', success: true),
            _createMockUploadResult(fileName: 'file2.docx', success: false),
          ],
        );
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(
          files: [
            _createMockUploadFile(fileName: 'file1.pdf'),
            _createMockUploadFile(fileName: 'file2.docx'),
          ],
        ),
      ),
      expect: () => [
        UploadState.uploading(
          files: [
            _createMockUploadFile(fileName: 'file1.pdf'),
            _createMockUploadFile(fileName: 'file2.docx'),
          ],
          activeUploads: 2,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 2,
          overallProgress: 0.0,
        ),
        isA<UploadPartialSuccess>(),
      ],
      verify: (bloc) {
        final state = bloc.state as UploadPartialSuccess;
        expect(state.successfulFiles.length, 1);
        expect(state.failedFiles.length, 1);
      },
    );

    blocTest<UploadBloc, UploadState>(
      'clears upload state when ClearUploadState is added',
      build: () => uploadBloc,
      act: (bloc) =>
          bloc.add(const upload_events.UploadEvent.clearUploadState()),
      expect: () => [const UploadState.initial()],
    );

    blocTest<UploadBloc, UploadState>(
      'handles network connectivity issues',
      build: () {
        when(
          mockRepository.uploadFiles(any),
        ).thenThrow(NetworkException('No internet connection'));
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(files: [_createMockUploadFile()]),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadNetworkError>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'handles storage quota exceeded',
      build: () {
        when(
          mockRepository.uploadFiles(any),
        ).thenThrow(StorageException('Storage quota exceeded'));
        return uploadBloc;
      },
      act: (bloc) => bloc.add(
        upload_events.UploadEvent.startUpload(files: [_createMockUploadFile()]),
      ),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        isA<UploadStorageError>(),
      ],
    );

    blocTest<UploadBloc, UploadState>(
      'pauses and resumes upload correctly',
      build: () {
        when(mockRepository.pauseUpload(any)).thenAnswer((_) async {});
        when(mockRepository.resumeUpload(any)).thenAnswer((_) async {});
        return uploadBloc;
      },
      act: (bloc) => bloc
        ..add(
          upload_events.UploadEvent.startUpload(
            files: [_createMockUploadFile()],
          ),
        )
        ..add(upload_events.UploadEvent.pauseUpload())
        ..add(upload_events.UploadEvent.resumeUpload()),
      expect: () => [
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
        UploadState.paused(
          files: [_createMockUploadFile()],
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
          pausedFiles: 1,
        ),
        UploadState.uploading(
          files: [_createMockUploadFile()],
          activeUploads: 1,
          completedFiles: 0,
          failedFiles: 0,
          totalFiles: 1,
          overallProgress: 0.0,
        ),
      ],
    );
  });
}

UploadFileModel _createMockUploadFile({String? fileName, int? fileSize}) {
  return UploadFileModel(
    id: 'test-upload-id',
    fileName: fileName ?? 'test.pdf',
    fileSize: fileSize ?? 1024,
    fileType: 'pdf',
    mimeType: 'application/pdf',
  );
}

UploadResult _createMockUploadResult({String? fileName, bool? success}) {
  return UploadResult(
    fileName: fileName ?? 'test.pdf',
    success: success ?? true,
    fileId: 'uploaded-file-id',
    downloadUrl: 'https://example.com/file.pdf',
    error: success == false ? 'Upload failed' : null,
  );
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class StorageException implements Exception {
  final String message;
  StorageException(this.message);
}
