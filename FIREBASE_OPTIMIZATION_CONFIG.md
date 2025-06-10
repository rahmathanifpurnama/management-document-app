# Firebase Optimization Configuration

## 🔥 Firebase Settings untuk Mencegah ANR

Dokumen ini berisi konfigurasi Firebase yang dioptimalkan untuk mencegah ANR pada aplikasi management document.

## 📊 Firestore Rules (Optimized)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection with pagination support
    match /users/{userId} {
      allow read, write: if request.auth != null 
        && request.auth.uid == userId
        && request.query.limit <= 25; // Prevent large queries
      
      allow read: if request.auth != null 
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin'
        && request.query.limit <= 50; // Admin can query more
    }
    
    // Documents collection with optimized queries
    match /documents/{documentId} {
      allow read: if request.auth != null
        && request.query.limit <= 25; // Pagination limit
      
      allow write: if request.auth != null
        && request.auth.uid == resource.data.uploadedBy;
      
      allow create: if request.auth != null
        && request.auth.uid == request.resource.data.uploadedBy
        && request.resource.data.keys().hasAll(['fileName', 'uploadedAt', 'isActive']);
      
      // Batch operations with limits
      allow read: if request.auth != null
        && request.query.limit <= 10 // Smaller batch for mobile
        && 'isActive' in request.query.where
        && request.query.where.isActive == true;
    }
    
    // Categories collection
    match /categories/{categoryId} {
      allow read: if request.auth != null
        && request.query.limit <= 50; // Categories are usually fewer
      
      allow write: if request.auth != null
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // Activities collection with time-based cleanup
    match /activities/{activityId} {
      allow read: if request.auth != null
        && request.query.limit <= 20 // Recent activities only
        && request.query.orderBy == 'timestamp';
      
      allow create: if request.auth != null;
      
      // Auto-delete old activities (handled by Cloud Functions)
      allow delete: if request.auth != null
        && get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## 🗄️ Storage Rules (Optimized)

```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Documents storage with size limits
    match /documents/{allPaths=**} {
      allow read: if request.auth != null;
      
      allow write: if request.auth != null
        && resource.size < 15 * 1024 * 1024 // 15MB limit
        && request.resource.size < 15 * 1024 * 1024
        && request.resource.contentType.matches('application/pdf|image/.*|application/msword|application/vnd.openxmlformats-officedocument.*');
      
      allow delete: if request.auth != null
        && (request.auth.uid == resource.metadata.uploadedBy
        || get(/databases/(default)/documents/users/$(request.auth.uid)).data.role == 'admin');
    }
    
    // Profile images with stricter limits
    match /profile_images/{userId} {
      allow read, write: if request.auth != null
        && request.auth.uid == userId
        && resource.size < 5 * 1024 * 1024 // 5MB limit for images
        && request.resource.contentType.matches('image/.*');
    }
    
    // Temporary uploads (auto-cleanup after 24 hours)
    match /temp/{allPaths=**} {
      allow read, write: if request.auth != null
        && resource.size < 20 * 1024 * 1024 // 20MB for temp files
        && request.resource.timeCreated > timestamp.date(2024, 1, 1); // Prevent old uploads
    }
  }
}
```

## 📈 Firestore Indexes (Required)

### Composite Indexes

```javascript
// Collection: documents
// Fields: isActive (Ascending), uploadedAt (Descending)
// Query: documents.where('isActive', '==', true).orderBy('uploadedAt', 'desc').limit(10)

// Collection: documents  
// Fields: category (Ascending), uploadedAt (Descending)
// Query: documents.where('category', '==', categoryId).orderBy('uploadedAt', 'desc').limit(10)

// Collection: documents
// Fields: uploadedBy (Ascending), uploadedAt (Descending)  
// Query: documents.where('uploadedBy', '==', userId).orderBy('uploadedAt', 'desc').limit(10)

// Collection: documents
// Fields: status (Ascending), uploadedAt (Descending)
// Query: documents.where('status', '==', 'pending').orderBy('uploadedAt', 'desc').limit(10)

// Collection: activities
// Fields: userId (Ascending), timestamp (Descending)
// Query: activities.where('userId', '==', userId).orderBy('timestamp', 'desc').limit(20)

// Collection: users
// Fields: isActive (Ascending), createdAt (Descending)
// Query: users.where('isActive', '==', true).orderBy('createdAt', 'desc').limit(25)
```

### Single Field Indexes

```javascript
// Collection: documents
// Field: fileName (Ascending) - for search functionality
// Field: fileSize (Ascending) - for filtering by size
// Field: contentType (Ascending) - for filtering by type

// Collection: categories
// Field: name (Ascending) - for search and sorting
// Field: fileCount (Descending) - for sorting by popularity

// Collection: users
// Field: email (Ascending) - for user lookup
// Field: role (Ascending) - for role-based queries
```

## ⚙️ Firebase SDK Configuration

### Android Configuration (`android/app/build.gradle`)

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        // Optimize for performance
        multiDexEnabled true
        
        // Firebase performance
        manifestPlaceholders = [
            firebasePerformanceInstrumentationEnabled: true
        ]
    }
    
    buildTypes {
        release {
            // Enable R8 optimization
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
            
            // Firebase performance
            firebasePerformanceInstrumentationEnabled true
        }
        
        debug {
            // Disable performance monitoring in debug
            firebasePerformanceInstrumentationEnabled false
        }
    }
}

dependencies {
    // Optimized Firebase dependencies
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-firestore'
    implementation 'com.google.firebase:firebase-storage'
    implementation 'com.google.firebase:firebase-auth'
    implementation 'com.google.firebase:firebase-functions'
    implementation 'com.google.firebase:firebase-performance'
    
    // Performance optimization
    implementation 'androidx.multidex:multidex:2.0.1'
}
```

### iOS Configuration (`ios/Runner/Info.plist`)

```xml
<dict>
    <!-- Firebase Performance -->
    <key>firebase_performance_collection_enabled</key>
    <true/>
    
    <!-- Network optimization -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <false/>
        <key>NSExceptionDomains</key>
        <dict>
            <key>firebaseapp.com</key>
            <dict>
                <key>NSExceptionAllowsInsecureHTTPLoads</key>
                <true/>
                <key>NSExceptionMinimumTLSVersion</key>
                <string>TLSv1.0</string>
            </dict>
        </dict>
    </dict>
    
    <!-- Memory optimization -->
    <key>UIApplicationExitsOnSuspend</key>
    <false/>
</dict>
```

## 🔧 Cloud Functions Configuration

### Package.json (Optimized)

```json
{
  "name": "management-document-functions",
  "version": "1.0.0",
  "engines": {
    "node": "18"
  },
  "dependencies": {
    "firebase-admin": "^11.11.1",
    "firebase-functions": "^4.5.0"
  },
  "devDependencies": {
    "@typescript-eslint/eslint-plugin": "^5.12.0",
    "@typescript-eslint/parser": "^5.12.0",
    "eslint": "^8.9.0",
    "typescript": "^4.9.0"
  }
}
```

### Firebase.json (Optimized)

```json
{
  "functions": {
    "runtime": "nodejs18",
    "memory": "512MB",
    "timeout": "60s",
    "source": "functions",
    "predeploy": [
      "npm --prefix \"$RESOURCE_DIR\" run build"
    ],
    "env": {
      "FIRESTORE_EMULATOR_HOST": "localhost:8080",
      "FIREBASE_STORAGE_EMULATOR_HOST": "localhost:9199"
    }
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  },
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  },
  "performance": {
    "enabled": true
  }
}
```

## 📱 Flutter Firebase Configuration

### Pubspec.yaml Dependencies

```yaml
dependencies:
  # Firebase Core
  firebase_core: ^2.24.2
  firebase_auth: ^4.15.3
  cloud_firestore: ^4.13.6
  firebase_storage: ^11.5.6
  firebase_functions: ^4.5.7
  firebase_performance: ^0.9.3+8
  
  # Performance optimization
  cached_network_image: ^3.3.0
  flutter_cache_manager: ^3.3.1
  
  # Memory management
  flutter_native_splash: ^2.3.6
  
dev_dependencies:
  # Performance monitoring
  firebase_performance_web: ^0.1.4+8
```

### Main.dart Firebase Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with optimized settings
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configure Firestore for performance
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  
  // Configure Firebase Performance
  FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
  
  runApp(MyApp());
}
```

## 🎯 Performance Monitoring Setup

### Custom Performance Traces

```dart
// In your service files
class OptimizedDocumentService {
  Future<List<DocumentModel>> getAllDocuments() async {
    final trace = FirebasePerformance.instance.newTrace('get_all_documents');
    await trace.start();
    
    try {
      // Your optimized code here
      final result = await _performOptimizedQuery();
      
      trace.setMetric('document_count', result.length);
      trace.putAttribute('query_type', 'paginated');
      
      return result;
    } finally {
      await trace.stop();
    }
  }
}
```

## 🔍 Monitoring and Alerts

### Firebase Console Settings

1. **Performance Monitoring**
   - Enable automatic traces
   - Set up custom traces for critical operations
   - Monitor app start time and screen rendering

2. **Firestore Usage Monitoring**
   - Set up billing alerts
   - Monitor read/write operations
   - Track query performance

3. **Storage Monitoring**
   - Monitor bandwidth usage
   - Track file upload/download times
   - Set up storage quotas

### Recommended Alerts

```javascript
// Cloud Monitoring Alerts
{
  "displayName": "High Firestore Read Operations",
  "conditions": [
    {
      "displayName": "Firestore reads > 10000/hour",
      "conditionThreshold": {
        "filter": "resource.type=\"firestore_database\"",
        "comparison": "COMPARISON_GREATER_THAN",
        "thresholdValue": 10000,
        "duration": "3600s"
      }
    }
  ]
}
```

## 🚀 Deployment Optimization

### Production Deployment Checklist

- [ ] Enable Firestore offline persistence
- [ ] Configure appropriate cache sizes
- [ ] Set up performance monitoring
- [ ] Enable Firebase Performance SDK
- [ ] Configure proper indexes
- [ ] Set up security rules
- [ ] Enable compression for Cloud Functions
- [ ] Configure CDN for static assets
- [ ] Set up monitoring and alerts
- [ ] Test on low-end devices

### Environment-Specific Configuration

```dart
// config/firebase_config.dart
class FirebaseConfig {
  static const bool enablePerformanceMonitoring = bool.fromEnvironment('ENABLE_PERFORMANCE', defaultValue: false);
  static const bool enableOfflinePersistence = bool.fromEnvironment('ENABLE_OFFLINE', defaultValue: true);
  static const int cacheSize = int.fromEnvironment('CACHE_SIZE', defaultValue: 100);
  
  static void configure() {
    if (enablePerformanceMonitoring) {
      FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    }
    
    if (enableOfflinePersistence) {
      FirebaseFirestore.instance.enablePersistence();
    }
  }
}
```

## 📞 Troubleshooting

### Common Issues and Solutions

1. **Slow Firestore Queries**
   - Check if proper indexes are created
   - Verify query limits are set
   - Use pagination instead of large queries

2. **High Memory Usage**
   - Enable Firestore cache size limits
   - Implement proper image caching
   - Clean up listeners and subscriptions

3. **Network Timeouts**
   - Increase timeout values in ANRConfig
   - Implement retry logic
   - Use offline persistence

4. **ANR on File Operations**
   - Use chunked uploads/downloads
   - Implement background processing
   - Add progress indicators

### Debug Commands

```bash
# Check Firestore indexes
firebase firestore:indexes

# Monitor performance
firebase performance:monitoring

# Check security rules
firebase firestore:rules:get

# Test functions locally
firebase functions:shell
```
