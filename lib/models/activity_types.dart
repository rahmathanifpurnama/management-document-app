import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'activity_model.dart';

/// Authentication-related activities
abstract class AuthActivity extends BaseActivity {
  final String? deviceInfo;
  final String? sessionId;

  const AuthActivity({
    required super.id,
    required super.userId,
    required super.type,
    required super.description,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    this.deviceInfo,
    this.sessionId,
  });

  @override
  bool get hasContext => ipAddress != null || deviceInfo != null;

  @override
  List<String> get contextInfo {
    final info = <String>[];
    if (ipAddress != null) info.add('IP: $ipAddress');
    if (deviceInfo != null) info.add('Device: $deviceInfo');
    if (sessionId != null) info.add('Session: $sessionId');
    return info;
  }
}

/// Login activity
class LoginActivity extends AuthActivity {
  final bool isSuccessful;
  final String? failureReason;

  const LoginActivity({
    required super.id,
    required super.userId,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    super.deviceInfo,
    super.sessionId,
    this.isSuccessful = true,
    this.failureReason,
  }) : super(type: 'login', description: 'User Login');

  @override
  ActivityType get activityType => ActivityType.login;

  @override
  String get displayTitle => isSuccessful ? 'Successful Login' : 'Failed Login';

  @override
  String get displaySubtitle => userName ?? userEmail ?? 'Unknown User';

  @override
  List<String> get contextInfo {
    final info = super.contextInfo;
    if (!isSuccessful && failureReason != null) {
      info.add('Reason: $failureReason');
    }
    return info;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userName': userName,
      'userEmail': userEmail,
      'isSuspicious': isSuspicious,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'details': {
        ...details,
        'deviceInfo': deviceInfo,
        'sessionId': sessionId,
        'isSuccessful': isSuccessful,
        'failureReason': failureReason,
      },
    };
  }

  @override
  LoginActivity copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  }) {
    return LoginActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
      deviceInfo: deviceInfo,
      sessionId: sessionId,
      isSuccessful: isSuccessful,
      failureReason: failureReason,
    );
  }
}

/// Logout activity
class LogoutActivity extends AuthActivity {
  final String? reason;

  const LogoutActivity({
    required super.id,
    required super.userId,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    super.deviceInfo,
    super.sessionId,
    this.reason,
  }) : super(type: 'logout', description: 'User Logout');

  @override
  ActivityType get activityType => ActivityType.logout;

  @override
  String get displayTitle => 'User Logout';

  @override
  String get displaySubtitle => userName ?? userEmail ?? 'Unknown User';

  @override
  List<String> get contextInfo {
    final info = super.contextInfo;
    if (reason != null) info.add('Reason: $reason');
    return info;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userName': userName,
      'userEmail': userEmail,
      'isSuspicious': isSuspicious,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'details': {
        ...details,
        'deviceInfo': deviceInfo,
        'sessionId': sessionId,
        'reason': reason,
      },
    };
  }

  @override
  LogoutActivity copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  }) {
    return LogoutActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
      deviceInfo: deviceInfo,
      sessionId: sessionId,
      reason: reason,
    );
  }
}

/// File-related activities
abstract class FileActivity extends BaseActivity {
  final String? documentId;
  final String? fileName;
  final int? fileSize;
  final String? fileType;
  final String? filePath;

  const FileActivity({
    required super.id,
    required super.userId,
    required super.type,
    required super.description,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    this.documentId,
    this.fileName,
    this.fileSize,
    this.fileType,
    this.filePath,
  });

  @override
  bool get hasContext => documentId != null || fileName != null;

  @override
  List<String> get contextInfo {
    final info = <String>[];
    if (fileName != null) info.add('File: $fileName');
    if (fileSize != null) info.add('Size: ${_formatFileSize(fileSize!)}');
    if (fileType != null) info.add('Type: $fileType');
    if (documentId != null) info.add('ID: $documentId');
    return info;
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}

/// File upload activity
class FileUploadActivity extends FileActivity {
  final String? categoryId;
  final String? uploadPath;
  final bool isSuccessful;
  final String? errorMessage;

  const FileUploadActivity({
    required super.id,
    required super.userId,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    super.documentId,
    super.fileName,
    super.fileSize,
    super.fileType,
    super.filePath,
    this.categoryId,
    this.uploadPath,
    this.isSuccessful = true,
    this.errorMessage,
  }) : super(type: 'upload', description: 'File Upload');

  @override
  ActivityType get activityType => ActivityType.upload;

  @override
  String get displayTitle => isSuccessful
      ? 'File Uploaded: ${fileName ?? 'Unknown'}'
      : 'Upload Failed: ${fileName ?? 'Unknown'}';

  @override
  String get displaySubtitle => userName ?? userEmail ?? 'Unknown User';

  @override
  List<String> get contextInfo {
    final info = super.contextInfo;
    if (categoryId != null) info.add('Category: $categoryId');
    if (!isSuccessful && errorMessage != null) info.add('Error: $errorMessage');
    return info;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userName': userName,
      'userEmail': userEmail,
      'documentId': documentId,
      'categoryId': categoryId,
      'isSuspicious': isSuspicious,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'details': {
        ...details,
        'fileName': fileName,
        'fileSize': fileSize,
        'fileType': fileType,
        'filePath': filePath,
        'uploadPath': uploadPath,
        'isSuccessful': isSuccessful,
        'errorMessage': errorMessage,
      },
    };
  }

  @override
  FileUploadActivity copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  }) {
    return FileUploadActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
      documentId: documentId,
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      filePath: filePath,
      categoryId: categoryId,
      uploadPath: uploadPath,
      isSuccessful: isSuccessful,
      errorMessage: errorMessage,
    );
  }
}

/// File download activity
class FileDownloadActivity extends FileActivity {
  final String? downloadPath;
  final bool isSuccessful;
  final String? errorMessage;

  const FileDownloadActivity({
    required super.id,
    required super.userId,
    required super.timestamp,
    super.userName,
    super.userEmail,
    super.isSuspicious = false,
    super.ipAddress,
    super.userAgent,
    super.details = const {},
    super.documentId,
    super.fileName,
    super.fileSize,
    super.fileType,
    super.filePath,
    this.downloadPath,
    this.isSuccessful = true,
    this.errorMessage,
  }) : super(type: 'download', description: 'File Download');

  @override
  ActivityType get activityType => ActivityType.download;

  @override
  String get displayTitle => isSuccessful
      ? 'File Downloaded: ${fileName ?? 'Unknown'}'
      : 'Download Failed: ${fileName ?? 'Unknown'}';

  @override
  String get displaySubtitle => userName ?? userEmail ?? 'Unknown User';

  @override
  List<String> get contextInfo {
    final info = super.contextInfo;
    if (downloadPath != null) info.add('Downloaded to: $downloadPath');
    if (!isSuccessful && errorMessage != null) info.add('Error: $errorMessage');
    return info;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'type': type,
      'description': description,
      'timestamp': Timestamp.fromDate(timestamp),
      'userName': userName,
      'userEmail': userEmail,
      'documentId': documentId,
      'isSuspicious': isSuspicious,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
      'details': {
        ...details,
        'fileName': fileName,
        'fileSize': fileSize,
        'fileType': fileType,
        'filePath': filePath,
        'downloadPath': downloadPath,
        'isSuccessful': isSuccessful,
        'errorMessage': errorMessage,
      },
    };
  }

  @override
  FileDownloadActivity copyWith({
    String? id,
    String? userId,
    String? type,
    String? description,
    DateTime? timestamp,
    String? userName,
    String? userEmail,
    bool? isSuspicious,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic>? details,
  }) {
    return FileDownloadActivity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      isSuspicious: isSuspicious ?? this.isSuspicious,
      ipAddress: ipAddress ?? this.ipAddress,
      userAgent: userAgent ?? this.userAgent,
      details: details ?? this.details,
      documentId: documentId,
      fileName: fileName,
      fileSize: fileSize,
      fileType: fileType,
      filePath: filePath,
      downloadPath: downloadPath,
      isSuccessful: isSuccessful,
      errorMessage: errorMessage,
    );
  }
}
