# Activities Data Structure

## Overview
The activities system tracks user-initiated actions only, excluding system-generated operations for cleaner activity timelines.

## Firestore Collection Structure

### Collection Name: `activities`

### Document Structure

```json
{
  "id": "auto-generated-document-id",
  "type": "login|logout|upload|download|delete|view|create|edit|share|copy|move|rename|create_user|update_user|delete_user|category_create|category_update|category_delete|suspicious_activity|security",
  "description": "Human-readable description of the activity",
  "userId": "firebase-auth-user-id",
  "userName": "User's display name (prioritized over email)",
  "userEmail": "user@example.com",
  "userRole": "admin|user",
  "timestamp": "Firestore ServerTimestamp",
  "isSuspicious": false,
  "ipAddress": "192.168.1.1 (optional)",
  "userAgent": "Flutter App (optional)",
  
  // Optional context fields
  "documentId": "document-id-if-applicable",
  "categoryId": "category-id-if-applicable",
  
  // Additional metadata
  "details": {
    "fileName": "example.pdf",
    "fileSize": 1024000,
    "platform": "Mobile",
    "deviceInfo": "Android 12",
    "sessionId": "session-123",
    "reason": "User requested logout",
    "additionalData": {}
  }
}
```

## Activity Types (Enum)

### Authentication Activities
- `login` - User login
- `logout` - User logout

### File Operations
- `upload` - File upload
- `download` - File download
- `delete` - File deletion
- `view` - File view/access
- `share` - File sharing
- `copy` - File copy
- `move` - File move
- `rename` - File rename

### Document Management
- `create` - Document creation
- `update` - Document update/edit

### User Management (Admin only)
- `create_user` - User creation
- `update_user` - User update
- `delete_user` - User deletion

### Category Management
- `category_create` - Category creation
- `category_update` - Category update
- `category_delete` - Category deletion

### Security & Monitoring
- `suspicious_activity` - Suspicious activity detected
- `security` - Security-related actions

## Flutter Model Classes

### Base Activity Model
```dart
abstract class BaseActivity {
  final String id;
  final String userId;
  final String type;
  final String description;
  final DateTime timestamp;
  final String? userName;
  final String? userEmail;
  final bool isSuspicious;
  final String? ipAddress;
  final String? userAgent;
  final Map<String, dynamic> details;
}
```

### Activity Model (Legacy Compatible)
```dart
class ActivityModel extends BaseActivity {
  final String? documentId;
  final String? categoryId;
  
  // Factory constructors
  factory ActivityModel.fromFirestore(DocumentSnapshot doc);
  factory ActivityModel.fromMap(Map<String, dynamic> map);
  
  // Methods
  Map<String, dynamic> toMap();
  ActivityModel copyWith({...});
}
```

## Specialized Activity Types

### Authentication Activities
```dart
class LoginActivity extends AuthActivity {
  final String? deviceInfo;
  final String? sessionId;
}

class LogoutActivity extends AuthActivity {
  final String? reason;
}
```

### File Activities
```dart
class FileActivity extends BaseActivity {
  final String fileName;
  final int? fileSize;
  final String? contentType;
  final String? filePath;
}

class UploadActivity extends FileActivity;
class DownloadActivity extends FileActivity;
class DeleteActivity extends FileActivity;
```

### Document Activities
```dart
class DocumentActivity extends BaseActivity {
  final String documentId;
  final String? documentName;
  final String? categoryId;
}
```

### User Management Activities
```dart
class UserManagementActivity extends BaseActivity {
  final String targetUserId;
  final String? targetUserEmail;
  final String? targetUserRole;
  final String? createdBy;
}
```

## Firestore Security Rules

```javascript
match /activities/{activityId} {
  // Allow single document read for active users
  allow get: if isActiveUser();
  
  // Allow collection queries with pagination
  allow list: if isActiveUser() && request.query.limit <= 50;
  
  // Allow unlimited queries for admin
  allow list: if isAdmin();
  
  // Allow create for active users with validation
  allow create: if isActiveUser()
    && request.resource.data.keys().hasAll(['type', 'userId', 'timestamp'])
    && request.resource.data.userId == request.auth.uid
    && request.resource.data.type is string
    && request.resource.data.type.size() > 0;
  
  // Admin-only delete
  allow delete: if isAdmin();
}
```

## Usage Examples

### Logging Activities
```dart
// Via ActivityService
await ActivityService().logActivity(
  type: 'upload',
  description: 'File uploaded: document.pdf',
  documentId: 'doc123',
  additionalData: {
    'fileName': 'document.pdf',
    'fileSize': 1024000,
    'platform': 'Mobile',
  },
);

// Via Cloud Functions
await CloudFunctionsService().logActivity(
  type: 'login',
  description: 'User login successful',
  additionalData: {
    'deviceInfo': 'Android 12',
    'sessionId': 'session-123',
  },
);
```

### Querying Activities
```dart
// Get recent activities with pagination
final activities = await FirebaseFirestore.instance
  .collection('activities')
  .orderBy('timestamp', descending: true)
  .limit(25)
  .get();

// Get user-specific activities
final userActivities = await FirebaseFirestore.instance
  .collection('activities')
  .where('userId', isEqualTo: currentUserId)
  .orderBy('timestamp', descending: true)
  .limit(50)
  .get();
```

## Activity Display Icons

### Icon Mapping
```dart
Map<String, IconData> activityIcons = {
  'login': Icons.login,
  'logout': Icons.logout,
  'upload': Icons.cloud_upload,
  'download': Icons.cloud_download,
  'delete': Icons.delete,
  'view': Icons.visibility,
  'create': Icons.add_circle,
  'edit': Icons.edit,
  'share': Icons.share,
  'copy': Icons.copy,
  'move': Icons.drive_file_move,
  'rename': Icons.drive_file_rename_outline,
  'create_user': Icons.person_add,
  'update_user': Icons.person_outline,
  'delete_user': Icons.person_remove,
  'category_create': Icons.create_new_folder,
  'category_update': Icons.folder_open,
  'category_delete': Icons.folder_delete,
  'suspicious_activity': Icons.warning,
  'security': Icons.security,
};
```

### Color Coding
```dart
Map<String, Color> activityColors = {
  'login': Colors.green,
  'logout': Colors.orange,
  'upload': Colors.blue,
  'download': Colors.indigo,
  'delete': Colors.red,
  'view': Colors.grey,
  'create': Colors.green,
  'edit': Colors.amber,
  'suspicious_activity': Colors.red,
  'security': Colors.purple,
};
```

## Performance Considerations

1. **Pagination**: Always use limit (max 50 for users, unlimited for admin)
2. **Indexing**: Create composite indexes for common queries
3. **Cleanup**: Admin can delete old activities for maintenance
4. **Lazy Loading**: Implement infinite scroll for activity lists
5. **Caching**: Cache recent activities for better performance

## Best Practices

1. **User-Initiated Only**: Only log user-initiated actions
2. **Meaningful Descriptions**: Use clear, human-readable descriptions
3. **Context Information**: Include relevant document/category IDs
4. **Error Handling**: Don't fail operations if activity logging fails
5. **Privacy**: Don't log sensitive information in details
6. **Cleanup**: Implement periodic cleanup of old activities
