import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../models/document_model.dart';
import '../core/services/optimized_file_service.dart';
import '../core/config/google_drive_config.dart';

/// Enhanced Google Drive Service for file upload integration
class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  static final List<String> _scopes = GoogleDriveConfig.requiredScopes;

  GoogleSignIn? _googleSignIn;
  drive.DriveApi? _driveApi;
  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;

  // File service for downloading from Firebase Storage
  final OptimizedFileService _fileService = OptimizedFileService.instance;

  /// Initialize Google Drive service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Validate configuration first
      if (!GoogleDriveConfig.validateConfiguration()) {
        throw Exception('Invalid Google Drive configuration');
      }

      if (GoogleDriveConfig.enableDebugLogging) {
        GoogleDriveConfig.printConfiguration();
      }

      _googleSignIn = GoogleSignIn(
        scopes: _scopes,
        // Use the client ID from google-services.json for Android
        // For web, you would need to add the web client ID here
      );

      // Check if user is already signed in
      _currentUser = await _googleSignIn!.signInSilently();
      if (_currentUser != null) {
        await _setupDriveApi(_currentUser!);
        debugPrint('✅ Google Drive service initialized with existing user');
      } else {
        debugPrint('✅ Google Drive service initialized (no existing user)');
      }

      _isInitialized = true;
    } catch (e) {
      debugPrint('❌ Failed to initialize Google Drive service: $e');
      rethrow;
    }
  }

  /// Sign in to Google Drive with enhanced error handling
  Future<bool> signIn() async {
    try {
      if (_googleSignIn == null) {
        await initialize();
      }

      // If already signed in, just setup API
      if (_currentUser != null) {
        await _setupDriveApi(_currentUser!);
        return true;
      }

      final GoogleSignInAccount? account = await _googleSignIn!.signIn();
      if (account == null) {
        debugPrint('❌ Google Sign-In cancelled by user');
        return false;
      }

      _currentUser = account;
      await _setupDriveApi(account);

      debugPrint('✅ Google Drive signed in successfully: ${account.email}');
      return true;
    } catch (e) {
      debugPrint('❌ Google Drive sign-in failed: $e');
      return false;
    }
  }

  /// Setup Drive API with authenticated user
  Future<void> _setupDriveApi(GoogleSignInAccount account) async {
    final GoogleSignInAuthentication auth = await account.authentication;
    if (auth.accessToken == null) {
      throw Exception('Failed to get access token');
    }

    final client = GoogleAuthClient(auth.accessToken!);
    _driveApi = drive.DriveApi(client);
  }

  /// Check if user is signed in to Google Drive
  bool get isSignedIn => _driveApi != null && _currentUser != null;

  /// Get current user info
  GoogleSignInAccount? get currentUser => _currentUser;

  /// Upload DocumentModel file to Google Drive
  Future<String?> uploadDocumentToGoogleDrive(
    DocumentModel document, {
    String? folderId,
    Function(double progress)? onProgress,
  }) async {
    try {
      debugPrint('🔄 Starting Google Drive upload for: ${document.fileName}');

      if (!isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Google Drive');
        }
      }

      // Step 1: Download file from Firebase Storage
      onProgress?.call(0.1);
      debugPrint(
        '📥 Downloading file from Firebase Storage: ${document.filePath}',
      );

      final fileData = await _fileService.downloadFileOptimized(
        document.filePath,
        onProgress: (downloadProgress) {
          // Map download progress to 10-50% of total progress
          onProgress?.call(0.1 + (downloadProgress * 0.4));
        },
      );

      if (fileData == null) {
        throw Exception('Failed to download file from Firebase Storage');
      }

      onProgress?.call(0.5);
      debugPrint(
        '✅ File downloaded from Firebase Storage (${fileData.length} bytes)',
      );

      // Step 2: Create temporary file for upload
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${document.displayFileName}');
      await tempFile.writeAsBytes(fileData);

      onProgress?.call(0.6);

      // Step 3: Upload to Google Drive
      debugPrint('📤 Uploading to Google Drive: ${document.displayFileName}');

      final driveFile = drive.File()
        ..name = document
            .displayFileName // Use clean filename without timestamps
        ..parents = folderId != null ? [folderId] : null
        ..description = 'Uploaded from Management Document App';

      final media = drive.Media(tempFile.openRead(), tempFile.lengthSync());

      onProgress?.call(0.7);

      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      onProgress?.call(0.9);

      // Step 4: Make file publicly accessible and cleanup
      if (result.id != null) {
        await _makeFilePublic(result.id!);

        // Cleanup temporary file
        try {
          await tempFile.delete();
        } catch (e) {
          debugPrint('⚠️ Failed to delete temporary file: $e');
        }

        onProgress?.call(1.0);
        debugPrint(
          '✅ File uploaded to Google Drive successfully: ${result.id}',
        );
        return result.id;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Failed to upload document to Google Drive: $e');
      rethrow;
    }
  }

  /// Upload file to Google Drive (legacy method for backward compatibility)
  Future<String?> uploadFile({
    required File file,
    required String fileName,
    String? folderId,
  }) async {
    try {
      if (!isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Google Drive');
        }
      }

      final driveFile = drive.File()
        ..name = fileName
        ..parents = folderId != null ? [folderId] : null;

      final media = drive.Media(file.openRead(), file.lengthSync());

      final result = await _driveApi!.files.create(
        driveFile,
        uploadMedia: media,
      );

      if (result.id != null) {
        // Make file publicly accessible
        await _makeFilePublic(result.id!);
        debugPrint('✅ File uploaded to Google Drive: ${result.id}');
        return result.id;
      }

      return null;
    } catch (e) {
      debugPrint('❌ Failed to upload file to Google Drive: $e');
      rethrow;
    }
  }

  /// Make file publicly accessible
  Future<void> _makeFilePublic(String fileId) async {
    try {
      final permission = drive.Permission()
        ..type = 'anyone'
        ..role = 'reader';

      await _driveApi!.permissions.create(permission, fileId);
      debugPrint('✅ File made publicly accessible: $fileId');
    } catch (e) {
      debugPrint('❌ Failed to make file public: $e');
      // Don't rethrow as this is not critical
    }
  }

  /// Get shareable link for Google Drive file
  String getShareableLink(String fileId) {
    return 'https://drive.google.com/file/d/$fileId/view?usp=sharing';
  }

  /// Get download link for Google Drive file
  String getDownloadLink(String fileId) {
    return 'https://drive.google.com/uc?export=download&id=$fileId';
  }

  /// Get file metadata from Google Drive
  Future<drive.File?> getFileMetadata(String fileId) async {
    try {
      if (!isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) return null;
      }

      final result = await _driveApi!.files.get(fileId);
      return result as drive.File?;
    } catch (e) {
      debugPrint('❌ Failed to get file metadata: $e');
      return null;
    }
  }

  /// Delete file from Google Drive
  Future<bool> deleteFile(String fileId) async {
    try {
      if (!isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) return false;
      }

      await _driveApi!.files.delete(fileId);
      debugPrint('✅ File deleted from Google Drive: $fileId');
      return true;
    } catch (e) {
      debugPrint('❌ Failed to delete file from Google Drive: $e');
      return false;
    }
  }

  /// Upload multiple documents to Google Drive
  Future<List<String>> uploadMultipleDocuments(
    List<DocumentModel> documents, {
    String? folderId,
    Function(int completed, int total, String currentFile)? onProgress,
  }) async {
    final uploadedIds = <String>[];

    try {
      debugPrint(
        '🔄 Starting bulk Google Drive upload for ${documents.length} files',
      );

      if (!isSignedIn) {
        final signedIn = await signIn();
        if (!signedIn) {
          throw Exception('Failed to sign in to Google Drive');
        }
      }

      for (int i = 0; i < documents.length; i++) {
        final document = documents[i];
        onProgress?.call(i, documents.length, document.fileName);

        try {
          final fileId = await uploadDocumentToGoogleDrive(
            document,
            folderId: folderId,
          );

          if (fileId != null) {
            uploadedIds.add(fileId);
            debugPrint(
              '✅ Uploaded ${i + 1}/${documents.length}: ${document.fileName}',
            );
          } else {
            debugPrint(
              '⚠️ Failed to upload ${document.fileName}: No file ID returned',
            );
          }
        } catch (e) {
          debugPrint('❌ Failed to upload ${document.fileName}: $e');
          // Continue with next file instead of stopping the entire process
        }
      }

      onProgress?.call(documents.length, documents.length, 'Complete');
      debugPrint(
        '✅ Bulk upload completed: ${uploadedIds.length}/${documents.length} files uploaded',
      );

      return uploadedIds;
    } catch (e) {
      debugPrint('❌ Bulk upload failed: $e');
      rethrow;
    }
  }

  /// Sign out from Google Drive
  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      _driveApi = null;
      _currentUser = null;
      debugPrint('✅ Signed out from Google Drive');
    } catch (e) {
      debugPrint('❌ Failed to sign out from Google Drive: $e');
    }
  }
}

/// HTTP client for Google API authentication
class GoogleAuthClient extends http.BaseClient {
  final String _accessToken;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._accessToken);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = 'Bearer $_accessToken';
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}
