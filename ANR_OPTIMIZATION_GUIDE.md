# ANR Optimization Guide

## 🚨 ANR Issues Fixed

This document outlines all the ANR (Application Not Responding) optimizations implemented in the management document app.

## 📊 High Priority Fixes (Implemented)

### 1. **Pagination Service** ✅
- **File**: `lib/core/services/pagination_service.dart`
- **Purpose**: Prevents ANR from loading large datasets
- **Features**:
  - Automatic pagination with configurable page sizes
  - Stream-based data loading
  - Background document parsing
  - Memory-efficient list management

```dart
// Usage Example
final paginationService = PaginationService<DocumentModel>(
  collectionName: 'documents',
  fromFirestore: DocumentModel.fromFirestore,
  pageSize: ANRConfig.defaultPageSize,
);
```

### 2. **Optimized File Service** ✅
- **File**: `lib/core/services/optimized_file_service.dart`
- **Purpose**: Prevents ANR from file operations
- **Features**:
  - Chunked file downloads for large files
  - Concurrent operation limiting
  - File caching with expiry
  - Background file processing

```dart
// Usage Example
final fileData = await OptimizedFileService.instance.downloadFileOptimized(
  'documents/large_file.pdf',
  onProgress: (progress) => print('Progress: ${(progress * 100).toInt()}%'),
);
```

### 3. **Optimized Network Service** ✅
- **File**: `lib/core/services/optimized_network_service.dart`
- **Purpose**: Prevents ANR from concurrent network operations
- **Features**:
  - Operation queue management
  - Priority-based execution
  - Concurrent operation limiting
  - Timeout handling

```dart
// Usage Example
final result = await OptimizedNetworkService.instance.executeFirestoreOperation(
  () => FirebaseFirestore.instance.collection('documents').get(),
  operationId: 'get_documents',
  priority: 3,
);
```

### 4. **Optimized UI Widgets** ✅
- **File**: `lib/core/widgets/optimized_ui_widgets.dart`
- **Purpose**: Prevents ANR from UI operations
- **Features**:
  - OptimizedListView with lazy loading
  - DebouncedTextField for search
  - ThrottledButton for rapid taps
  - OptimizedImageWidget with caching

```dart
// Usage Example
OptimizedListView(
  itemCount: documents.length,
  itemBuilder: (context, index) => DocumentTile(documents[index]),
  onLoadMore: () => loadMoreDocuments(),
  hasMore: hasMoreData,
)
```

## 📈 Medium Priority Fixes (Implemented)

### 5. **Memory Management Service** ✅
- **File**: `lib/core/services/memory_management_service.dart`
- **Purpose**: Prevents ANR from memory pressure
- **Features**:
  - Automatic memory monitoring
  - Resource tracking and cleanup
  - Cache management
  - Memory pressure handling

### 6. **Optimized Image Service** ✅
- **File**: `lib/core/services/optimized_image_service.dart`
- **Purpose**: Prevents ANR from image loading
- **Features**:
  - Image caching and preloading
  - Automatic image resizing
  - Background image processing
  - Memory-efficient rendering

### 7. **Enhanced Document Service** ✅
- **File**: `lib/core/services/document_service.dart`
- **Purpose**: Optimized document operations
- **Features**:
  - Paginated document queries
  - Batch document processing
  - Network operation optimization
  - Error handling improvements

## 📉 Low Priority Fixes (Implemented)

### 8. **Performance Monitoring Service** ✅
- **File**: `lib/core/services/performance_monitoring_service.dart`
- **Purpose**: Monitor and detect performance issues
- **Features**:
  - Frame rate monitoring
  - ANR detection
  - Operation performance tracking
  - Performance recommendations

## ⚙️ Configuration Updates

### 9. **Enhanced ANR Config** ✅
- **File**: `lib/core/config/anr_config.dart`
- **Updates**:
  - Reduced timeout values
  - Smaller batch sizes
  - Pagination settings
  - Concurrent operation limits
  - Memory management settings

```dart
// Key Configuration Values
static const Duration defaultTimeout = Duration(seconds: 2);
static const int defaultBatchSize = 5;
static const int defaultPageSize = 10;
static const int maxConcurrentFirebaseOps = 2;
```

## 🔧 Integration Points

### Main App Integration
- **File**: `lib/main.dart`
- **Changes**:
  - Initialize all optimization services
  - Set up error handling
  - Configure performance monitoring

### Service Integration
- **Files**: Various service files
- **Changes**:
  - Use OptimizedNetworkService for all network operations
  - Implement pagination in data loading
  - Add timeout and error handling

## 📱 Usage Guidelines

### For Developers

1. **Always use pagination** for large data sets:
```dart
// Good
final paginationService = PaginationService<DocumentModel>(...);
await paginationService.loadFirstPage();

// Bad
final allDocuments = await documentService.getAllDocuments();
```

2. **Use optimized widgets** for UI:
```dart
// Good
OptimizedListView(...)

// Bad
ListView.builder(...) // without optimization
```

3. **Implement proper error handling**:
```dart
// Good
final result = await ANRPrevention.executeWithTimeout(
  operation(),
  timeout: ANRConfig.defaultTimeout,
  operationName: 'My Operation',
);

// Bad
final result = await operation(); // no timeout
```

### For Firebase Operations

1. **Use OptimizedNetworkService**:
```dart
// Good
await OptimizedNetworkService.instance.executeFirestoreOperation(
  () => query.get(),
  operationId: 'unique_id',
  priority: 3,
);

// Bad
await query.get(); // direct call
```

2. **Implement pagination**:
```dart
// Good
query.limit(ANRConfig.defaultPageSize)

// Bad
query // no limit
```

## 🔍 Monitoring and Debugging

### Performance Monitoring
- Enable in debug mode: `PerformanceMonitoringService.instance.startMonitoring()`
- Check stats: `PerformanceMonitoringService.instance.getPerformanceStats()`
- Get recommendations: `PerformanceMonitoringService.instance.getPerformanceRecommendations()`

### Memory Monitoring
- Check memory stats: `MemoryManagementService.instance.getMemoryStats()`
- Force cleanup: `MemoryManagementService.instance.forceCleanup()`

### Network Monitoring
- Check network stats: `OptimizedNetworkService.instance.getStats()`
- Cancel operations: `OptimizedNetworkService.instance.cancelAllOperations()`

## 🚀 Performance Improvements

### Before Optimization
- Large data loads causing 5-10 second freezes
- Image loading blocking UI thread
- Concurrent Firebase operations overwhelming the system
- Memory leaks from uncleaned resources

### After Optimization
- Smooth pagination with 10-item pages
- Background image loading with caching
- Controlled concurrent operations (max 2-3)
- Automatic memory management and cleanup
- Aggressive timeout handling (2-8 seconds)

## 🔧 Firebase Configuration Recommendations

### Firestore Rules
```javascript
// Add pagination support
allow read: if request.query.limit <= 25;
```

### Storage Rules
```javascript
// Add file size limits
allow read, write: if resource.size < 15 * 1024 * 1024; // 15MB limit
```

### Indexes
Create composite indexes for:
- `isActive` + `uploadedAt` (for paginated document queries)
- `category` + `uploadedAt` (for category-specific pagination)
- `uploadedBy` + `uploadedAt` (for user-specific pagination)

## 📋 Testing Checklist

### ANR Prevention Testing
- [ ] Load large document lists (100+ items)
- [ ] Upload multiple files simultaneously
- [ ] Search with rapid typing
- [ ] Navigate between screens quickly
- [ ] Test on low-end devices
- [ ] Test with poor network conditions

### Performance Testing
- [ ] Monitor frame rate during heavy operations
- [ ] Check memory usage over time
- [ ] Verify timeout handling
- [ ] Test pagination functionality
- [ ] Validate cache cleanup

## 🔄 Maintenance

### Regular Tasks
1. **Monitor performance metrics** weekly
2. **Review ANR logs** for new issues
3. **Update timeout values** based on usage patterns
4. **Clean up unused cache entries** monthly
5. **Review and optimize slow operations** quarterly

### Configuration Tuning
- Adjust `ANRConfig` values based on user feedback
- Monitor Firebase usage and costs
- Update pagination sizes based on device capabilities
- Fine-tune cache sizes based on memory usage

## 📞 Support

For ANR-related issues:
1. Check performance monitoring logs
2. Review memory usage statistics
3. Verify network operation queues
4. Check Firebase operation timeouts
5. Monitor frame rate and UI responsiveness

## 🎯 Future Improvements

### Planned Enhancements
1. **Isolate-based processing** for heavy computations
2. **Advanced image compression** algorithms
3. **Predictive caching** based on user behavior
4. **Dynamic timeout adjustment** based on network conditions
5. **Machine learning-based** performance optimization
