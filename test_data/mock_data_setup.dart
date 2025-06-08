import 'dart:convert';
import 'dart:typed_data';

/// Mock data setup for Firebase Test Lab integration tests
class MockDataSetup {
  /// Mock user data for testing
  static const Map<String, dynamic> mockUsers = {
    'admin_user': {
      'id': 'admin_123',
      'email': 'admin@testlab.com',
      'name': 'Test Admin',
      'role': 'admin',
      'createdAt': '2024-01-01T00:00:00Z',
      'isActive': true,
    },
    'regular_user': {
      'id': 'user_456',
      'email': 'user@testlab.com',
      'name': 'Test User',
      'role': 'user',
      'createdAt': '2024-01-01T00:00:00Z',
      'isActive': true,
    },
    'test_user': {
      'id': 'test_789',
      'email': 'test@example.com',
      'name': 'Test User',
      'role': 'user',
      'createdAt': '2024-01-01T00:00:00Z',
      'isActive': true,
    },
  };

  /// Mock document data for testing
  static const Map<String, dynamic> mockDocuments = {
    'document_1': {
      'id': 'doc_001',
      'title': 'Test Document 1',
      'description': 'This is a test document for Firebase Test Lab',
      'fileName': 'test_document_1.pdf',
      'fileSize': 1024000,
      'mimeType': 'application/pdf',
      'categoryId': 'cat_001',
      'uploadedBy': 'user_456',
      'uploadedAt': '2024-01-01T00:00:00Z',
      'isPublic': false,
      'tags': ['test', 'document', 'pdf'],
      'downloadCount': 5,
    },
    'document_2': {
      'id': 'doc_002',
      'title': 'Sample Image',
      'description': 'Test image file for testing',
      'fileName': 'sample_image.jpg',
      'fileSize': 512000,
      'mimeType': 'image/jpeg',
      'categoryId': 'cat_002',
      'uploadedBy': 'admin_123',
      'uploadedAt': '2024-01-02T00:00:00Z',
      'isPublic': true,
      'tags': ['test', 'image', 'jpg'],
      'downloadCount': 12,
    },
    'document_3': {
      'id': 'doc_003',
      'title': 'Test Spreadsheet',
      'description': 'Excel file for testing',
      'fileName': 'test_data.xlsx',
      'fileSize': 256000,
      'mimeType': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      'categoryId': 'cat_001',
      'uploadedBy': 'user_456',
      'uploadedAt': '2024-01-03T00:00:00Z',
      'isPublic': false,
      'tags': ['test', 'spreadsheet', 'excel'],
      'downloadCount': 3,
    },
  };

  /// Mock category data for testing
  static const Map<String, dynamic> mockCategories = {
    'category_1': {
      'id': 'cat_001',
      'name': 'Documents',
      'description': 'General documents category',
      'color': '#2196F3',
      'icon': 'folder',
      'createdBy': 'admin_123',
      'createdAt': '2024-01-01T00:00:00Z',
      'documentCount': 15,
      'isActive': true,
    },
    'category_2': {
      'id': 'cat_002',
      'name': 'Images',
      'description': 'Image files category',
      'color': '#4CAF50',
      'icon': 'image',
      'createdBy': 'admin_123',
      'createdAt': '2024-01-01T00:00:00Z',
      'documentCount': 8,
      'isActive': true,
    },
    'category_3': {
      'id': 'cat_003',
      'name': 'Spreadsheets',
      'description': 'Excel and CSV files',
      'color': '#FF9800',
      'icon': 'table_chart',
      'createdBy': 'admin_123',
      'createdAt': '2024-01-01T00:00:00Z',
      'documentCount': 5,
      'isActive': true,
    },
  };

  /// Mock activity data for testing
  static const Map<String, dynamic> mockActivities = {
    'activity_1': {
      'id': 'act_001',
      'type': 'document_upload',
      'description': 'User uploaded a document',
      'userId': 'user_456',
      'documentId': 'doc_001',
      'timestamp': '2024-01-01T10:00:00Z',
      'metadata': {
        'fileName': 'test_document_1.pdf',
        'fileSize': 1024000,
      },
    },
    'activity_2': {
      'id': 'act_002',
      'type': 'document_download',
      'description': 'User downloaded a document',
      'userId': 'user_456',
      'documentId': 'doc_002',
      'timestamp': '2024-01-01T11:00:00Z',
      'metadata': {
        'fileName': 'sample_image.jpg',
      },
    },
    'activity_3': {
      'id': 'act_003',
      'type': 'category_created',
      'description': 'Admin created a new category',
      'userId': 'admin_123',
      'categoryId': 'cat_003',
      'timestamp': '2024-01-01T12:00:00Z',
      'metadata': {
        'categoryName': 'Spreadsheets',
      },
    },
  };

  /// Test file content for different file types
  static const Map<String, String> testFileContents = {
    'text': '''
This is a test text file for Firebase Test Lab integration testing.
It contains multiple lines of text to simulate a real document.
Line 3: Testing special characters: àáâãäåæçèéêë
Line 4: Testing numbers: 1234567890
Line 5: Testing symbols: !@#\$%^&*()_+-=[]{}|;:,.<>?
''',
    'csv': '''
Name,Email,Role,Department,Salary
John Doe,john@example.com,Developer,IT,75000
Jane Smith,jane@example.com,Designer,Marketing,65000
Bob Johnson,bob@example.com,Manager,Sales,85000
Alice Brown,alice@example.com,Analyst,Finance,70000
''',
    'json': '''
{
  "testData": {
    "users": [
      {"id": 1, "name": "Test User 1", "active": true},
      {"id": 2, "name": "Test User 2", "active": false}
    ],
    "settings": {
      "theme": "light",
      "language": "en",
      "notifications": true
    }
  }
}
''',
  };

  /// Generate test file data
  static Uint8List generateTestFileData(String type, int sizeInBytes) {
    switch (type) {
      case 'text':
        return _generateTextFile(sizeInBytes);
      case 'binary':
        return _generateBinaryFile(sizeInBytes);
      case 'image':
        return _generateImageFile(sizeInBytes);
      default:
        return _generateRandomFile(sizeInBytes);
    }
  }

  /// Generate text file data
  static Uint8List _generateTextFile(int sizeInBytes) {
    const baseContent = 'This is test content for Firebase Test Lab. ';
    final buffer = StringBuffer();
    
    while (buffer.length < sizeInBytes) {
      buffer.write(baseContent);
      buffer.write('Line ${buffer.length ~/ baseContent.length}: ');
      buffer.write('Random data ${DateTime.now().millisecondsSinceEpoch}\n');
    }
    
    final content = buffer.toString().substring(0, sizeInBytes);
    return Uint8List.fromList(utf8.encode(content));
  }

  /// Generate binary file data
  static Uint8List _generateBinaryFile(int sizeInBytes) {
    final data = Uint8List(sizeInBytes);
    for (int i = 0; i < sizeInBytes; i++) {
      data[i] = i % 256;
    }
    return data;
  }

  /// Generate mock image file data (simple bitmap header + data)
  static Uint8List _generateImageFile(int sizeInBytes) {
    // Simple BMP header (54 bytes) + pixel data
    final data = Uint8List(sizeInBytes);
    
    // BMP file header
    data[0] = 0x42; // 'B'
    data[1] = 0x4D; // 'M'
    
    // File size (little endian)
    final fileSize = sizeInBytes;
    data[2] = fileSize & 0xFF;
    data[3] = (fileSize >> 8) & 0xFF;
    data[4] = (fileSize >> 16) & 0xFF;
    data[5] = (fileSize >> 24) & 0xFF;
    
    // Fill rest with pattern
    for (int i = 54; i < sizeInBytes; i++) {
      data[i] = ((i - 54) % 256);
    }
    
    return data;
  }

  /// Generate random file data
  static Uint8List _generateRandomFile(int sizeInBytes) {
    final data = Uint8List(sizeInBytes);
    final random = DateTime.now().millisecondsSinceEpoch;
    
    for (int i = 0; i < sizeInBytes; i++) {
      data[i] = ((random + i) % 256);
    }
    
    return data;
  }

  /// Get mock data as JSON string
  static String getMockDataAsJson(String dataType) {
    switch (dataType) {
      case 'users':
        return jsonEncode(mockUsers);
      case 'documents':
        return jsonEncode(mockDocuments);
      case 'categories':
        return jsonEncode(mockCategories);
      case 'activities':
        return jsonEncode(mockActivities);
      default:
        return '{}';
    }
  }

  /// Test credentials for different user types
  static const Map<String, Map<String, String>> testCredentials = {
    'admin': {
      'email': 'admin@testlab.com',
      'password': 'AdminTest123!',
      'name': 'Test Admin',
      'role': 'admin',
    },
    'user': {
      'email': 'user@testlab.com',
      'password': 'UserTest123!',
      'name': 'Test User',
      'role': 'user',
    },
    'test': {
      'email': 'test@example.com',
      'password': 'testPassword123',
      'name': 'Test User',
      'role': 'user',
    },
  };

  /// Performance test data
  static const Map<String, dynamic> performanceTestData = {
    'small_file_size': 1024, // 1KB
    'medium_file_size': 1024 * 1024, // 1MB
    'large_file_size': 10 * 1024 * 1024, // 10MB
    'very_large_file_size': 100 * 1024 * 1024, // 100MB
    'max_upload_time_seconds': 120,
    'max_download_time_seconds': 60,
    'max_startup_time_seconds': 10,
    'target_fps': 60,
    'max_memory_usage_mb': 200,
  };

  /// Error simulation data
  static const Map<String, dynamic> errorSimulationData = {
    'network_errors': [
      'Connection timeout',
      'Network unreachable',
      'DNS resolution failed',
      'SSL handshake failed',
    ],
    'auth_errors': [
      'Invalid credentials',
      'Account disabled',
      'Token expired',
      'Permission denied',
    ],
    'file_errors': [
      'File not found',
      'File too large',
      'Invalid file type',
      'Corrupted file',
    ],
  };

  /// Test environment configuration
  static const Map<String, dynamic> testEnvironmentConfig = {
    'firebase_project_id': 'your-test-project-id',
    'test_timeout_minutes': 30,
    'max_retry_attempts': 3,
    'screenshot_on_failure': true,
    'video_recording': true,
    'performance_monitoring': true,
    'debug_logging': true,
  };
}
