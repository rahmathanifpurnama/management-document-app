import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'activity_model.dart';
import 'activity_types.dart';

/// Factory class for creating polymorphic activity instances
class ActivityFactory {
  /// Create activity instance from Firestore document
  static BaseActivity fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return fromMap(doc.id, data);
  }

  /// Create activity instance from Map data
  static BaseActivity fromMap(String id, Map<String, dynamic> data) {
    final type = data['type'] ?? data['action'] ?? '';
    final userId = data['userId'] ?? '';
    final description = data['description'] ?? data['resource'] ?? '';
    final timestamp = _parseTimestamp(data['timestamp']);
    final userName = data['userName'];
    final userEmail = data['userEmail'];
    final isSuspicious = data['isSuspicious'] ?? false;
    final ipAddress = data['ipAddress'];
    final userAgent = data['userAgent'];
    final details = _parseDetails(data['details']);

    // Create specific activity type based on type string
    switch (type.toLowerCase()) {
      case 'login':
        return LoginActivity(
          id: id,
          userId: userId,
          timestamp: timestamp,
          userName: userName,
          userEmail: userEmail,
          isSuspicious: isSuspicious,
          ipAddress: ipAddress,
          userAgent: userAgent,
          details: details,
          deviceInfo: details['deviceInfo'],
          sessionId: details['sessionId'],
          isSuccessful: details['isSuccessful'] ?? true,
          failureReason: details['failureReason'],
        );

      case 'logout':
        return LogoutActivity(
          id: id,
          userId: userId,
          timestamp: timestamp,
          userName: userName,
          userEmail: userEmail,
          isSuspicious: isSuspicious,
          ipAddress: ipAddress,
          userAgent: userAgent,
          details: details,
          deviceInfo: details['deviceInfo'],
          sessionId: details['sessionId'],
          reason: details['reason'],
        );

      case 'upload':
      case 'file_uploaded':
        return FileUploadActivity(
          id: id,
          userId: userId,
          timestamp: timestamp,
          userName: userName,
          userEmail: userEmail,
          isSuspicious: isSuspicious,
          ipAddress: ipAddress,
          userAgent: userAgent,
          details: details,
          documentId: data['documentId'],
          fileName: details['fileName'],
          fileSize: details['fileSize'],
          fileType: details['fileType'],
          filePath: details['filePath'],
          categoryId: data['categoryId'],
          uploadPath: details['uploadPath'],
          isSuccessful: details['isSuccessful'] ?? true,
          errorMessage: details['errorMessage'],
        );

      case 'download':
        return FileDownloadActivity(
          id: id,
          userId: userId,
          timestamp: timestamp,
          userName: userName,
          userEmail: userEmail,
          isSuspicious: isSuspicious,
          ipAddress: ipAddress,
          userAgent: userAgent,
          details: details,
          documentId: data['documentId'],
          fileName: details['fileName'],
          fileSize: details['fileSize'],
          fileType: details['fileType'],
          filePath: details['filePath'],
          downloadPath: details['downloadPath'],
          isSuccessful: details['isSuccessful'] ?? true,
          errorMessage: details['errorMessage'],
        );

      // For backward compatibility and unknown types, use legacy ActivityModel
      default:
        return ActivityModel(
          id: id,
          userId: userId,
          type: type,
          description: description,
          timestamp: timestamp,
          userName: userName,
          userEmail: userEmail,
          documentId: data['documentId'],
          categoryId: data['categoryId'],
          isSuspicious: isSuspicious,
          ipAddress: ipAddress,
          userAgent: userAgent,
          details: details,
        );
    }
  }

  /// Parse details from various data types
  static Map<String, dynamic> _parseDetails(dynamic details) {
    if (details == null) return {};
    if (details is Map<String, dynamic>) return details;
    if (details is Map) {
      return Map<String, dynamic>.from(details);
    }
    if (details is String) {
      return {'description': details};
    }
    return {'value': details.toString()};
  }

  /// Create activity from JSON (for API responses)
  static BaseActivity fromJson(Map<String, dynamic> json) {
    // Convert timestamp string to DateTime if needed
    if (json['timestamp'] is String) {
      json['timestamp'] = Timestamp.fromDate(DateTime.parse(json['timestamp']));
    }

    return fromMap(json['id'] ?? '', json);
  }

  /// Get all supported activity types
  static List<String> getSupportedTypes() {
    return [
      'login',
      'logout',
      'upload',
      'file_uploaded',
      'download',
      'delete',
      'view',
      'create',
      'update',
      'share',
      'copy',
      'move',
      'rename',
      'create_user',
      'update_user',
      'delete_user',
      'category_create',
      'category_update',
      'category_delete',
      'suspicious_activity',
      'security',
      'sync',
      'backup',
      'restore',
    ];
  }

  /// Check if a type is supported for polymorphic creation
  static bool isPolymorphicType(String type) {
    return [
      'login',
      'logout',
      'upload',
      'file_uploaded',
      'download',
    ].contains(type.toLowerCase());
  }

  /// Create a basic activity for unsupported types
  static ActivityModel createBasicActivity({
    required String id,
    required String userId,
    required String type,
    required String description,
    required DateTime timestamp,
    String? userName,
    String? userEmail,
    String? documentId,
    String? categoryId,
    bool isSuspicious = false,
    String? ipAddress,
    String? userAgent,
    Map<String, dynamic> details = const {},
  }) {
    return ActivityModel(
      id: id,
      userId: userId,
      type: type,
      description: description,
      timestamp: timestamp,
      userName: userName,
      userEmail: userEmail,
      documentId: documentId,
      categoryId: categoryId,
      isSuspicious: isSuspicious,
      ipAddress: ipAddress,
      userAgent: userAgent,
      details: details,
    );
  }

  /// Parse timestamp from various formats (Firestore Timestamp, String ISO 8601, etc.)
  static DateTime _parseTimestamp(dynamic timestampData) {
    if (timestampData == null) {
      return DateTime.now();
    }

    // Handle Firestore Timestamp
    if (timestampData is Timestamp) {
      return timestampData.toDate();
    }

    // Handle String (ISO 8601 format from Cloud Functions)
    if (timestampData is String) {
      try {
        return DateTime.parse(timestampData);
      } catch (e) {
        // Try parsing with different formats
        try {
          // Handle format like "2024-01-15T10:30:00.000Z"
          return DateTime.parse(timestampData.replaceAll('Z', ''));
        } catch (e2) {
          // Handle Unix timestamp as string
          try {
            final unixTimestamp = int.parse(timestampData);
            return DateTime.fromMillisecondsSinceEpoch(unixTimestamp);
          } catch (e3) {
            debugPrint(
              'Error parsing timestamp string: $timestampData, error: $e3',
            );
            return DateTime.now();
          }
        }
      }
    }

    // Handle int (Unix timestamp)
    if (timestampData is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestampData);
    }

    // Handle Map (Firestore Timestamp as Map)
    if (timestampData is Map) {
      try {
        final seconds = timestampData['_seconds'] ?? timestampData['seconds'];
        final nanoseconds =
            timestampData['_nanoseconds'] ?? timestampData['nanoseconds'] ?? 0;
        if (seconds != null) {
          return DateTime.fromMillisecondsSinceEpoch(
            (seconds * 1000) + (nanoseconds / 1000000).round(),
          );
        }
      } catch (e) {
        debugPrint('Error parsing timestamp map: $timestampData, error: $e');
      }
    }

    debugPrint(
      'Unknown timestamp format: $timestampData (${timestampData.runtimeType})',
    );
    return DateTime.now();
  }
}

/// Extension methods for activity collections
extension ActivityListExtensions on List<BaseActivity> {
  /// Filter activities by type
  List<BaseActivity> filterByType(String type) {
    return where(
      (activity) => activity.type.toLowerCase() == type.toLowerCase(),
    ).toList();
  }

  /// Filter activities by user
  List<BaseActivity> filterByUser(String userId) {
    return where((activity) => activity.userId == userId).toList();
  }

  /// Filter suspicious activities
  List<BaseActivity> filterSuspicious() {
    return where((activity) => activity.isSuspicious).toList();
  }

  /// Get activities within date range
  List<BaseActivity> filterByDateRange(DateTime start, DateTime end) {
    return where(
      (activity) =>
          activity.timestamp.isAfter(start) && activity.timestamp.isBefore(end),
    ).toList();
  }

  /// Group activities by type
  Map<String, List<BaseActivity>> groupByType() {
    final Map<String, List<BaseActivity>> grouped = {};
    for (final activity in this) {
      grouped.putIfAbsent(activity.type, () => []).add(activity);
    }
    return grouped;
  }

  /// Group activities by user
  Map<String, List<BaseActivity>> groupByUser() {
    final Map<String, List<BaseActivity>> grouped = {};
    for (final activity in this) {
      final key = activity.userName ?? activity.userEmail ?? activity.userId;
      grouped.putIfAbsent(key, () => []).add(activity);
    }
    return grouped;
  }
}
