import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

/// Service for Google Drive integration
class GoogleDriveService {
  static final GoogleDriveService _instance = GoogleDriveService._internal();
  factory GoogleDriveService() => _instance;
  GoogleDriveService._internal();

  static const List<String> _scopes = [drive.DriveApi.driveFileScope];

  GoogleSignIn? _googleSignIn;
  drive.DriveApi? _driveApi;
  bool _isInitialized = false;

  /// Initialize Google Drive service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _googleSignIn = GoogleSignIn(scopes: _scopes);
      _isInitialized = true;
      debugPrint('✅ Google Drive service initialized');
    } catch (e) {
      debugPrint('❌ Failed to initialize Google Drive service: $e');
      rethrow;
    }
  }

  /// Sign in to Google Drive
  Future<bool> signIn() async {
    try {
      if (_googleSignIn == null) {
        await initialize();
      }

      final GoogleSignInAccount? account = await _googleSignIn!.signIn();
      if (account == null) {
        debugPrint('❌ Google Sign-In cancelled by user');
        return false;
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final client = GoogleAuthClient(auth.accessToken!);
      _driveApi = drive.DriveApi(client);

      debugPrint('✅ Google Drive signed in successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Google Drive sign-in failed: $e');
      return false;
    }
  }

  /// Check if user is signed in to Google Drive
  bool get isSignedIn => _driveApi != null;

  /// Upload file to Google Drive
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

  /// Sign out from Google Drive
  Future<void> signOut() async {
    try {
      await _googleSignIn?.signOut();
      _driveApi = null;
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
