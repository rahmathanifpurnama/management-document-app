import '../config/firebase_config.dart';

/// Smart caching service to optimize Firebase calls without sacrificing UI responsiveness
class SmartCacheService {
  static SmartCacheService? _instance;
  static SmartCacheService get instance => _instance ??= SmartCacheService._();

  SmartCacheService._();

  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  // Cache durations for different data types
  static const Duration _documentsCacheDuration = Duration(minutes: 5);
  static const Duration _usersCacheDuration = Duration(minutes: 10);
  static const Duration _categoriesCacheDuration = Duration(minutes: 15);
  static const Duration _activitiesCacheDuration = Duration(minutes: 2);

  /// Check if cached data is still valid
  bool isCacheValid(String key, Duration maxAge) {
    if (!_cacheTimestamps.containsKey(key)) return false;

    final cacheTime = _cacheTimestamps[key]!;
    final now = DateTime.now();
    return now.difference(cacheTime) < maxAge;
  }

  /// Get cached data if valid, null otherwise
  T? getCachedData<T>(String key, Duration maxAge) {
    if (!isCacheValid(key, maxAge)) return null;
    return _memoryCache[key] as T?;
  }

  /// Cache data with timestamp
  void cacheData(String key, dynamic data) {
    _memoryCache[key] = data;
    _cacheTimestamps[key] = DateTime.now();
  }

  /// Clear specific cache entry
  void clearCache(String key) {
    _memoryCache.remove(key);
    _cacheTimestamps.remove(key);
  }

  /// Clear all cache
  void clearAllCache() {
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }

  /// Get cache duration for specific data type
  Duration getCacheDuration(String dataType) {
    switch (dataType) {
      case 'documents':
        return _documentsCacheDuration;
      case 'users':
        return _usersCacheDuration;
      case 'categories':
        return _categoriesCacheDuration;
      case 'activities':
        return _activitiesCacheDuration;
      default:
        return const Duration(minutes: 5);
    }
  }

  /// Check if we should fetch fresh data
  bool shouldFetchFreshData(String key, String dataType) {
    // Always fetch if cache is invalid
    if (!isCacheValid(key, getCacheDuration(dataType))) {
      return true;
    }

    // For critical data, fetch more frequently
    if (dataType == 'documents' && FirebaseConfig.shouldEnableRealtimeSync) {
      return !isCacheValid(key, const Duration(minutes: 2));
    }

    return false;
  }

  /// Get cache statistics for debugging
  Map<String, dynamic> getCacheStats() {
    return {
      'totalCachedItems': _memoryCache.length,
      'cacheKeys': _memoryCache.keys.toList(),
      'oldestCache': _cacheTimestamps.values.isEmpty
          ? null
          : _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b),
      'newestCache': _cacheTimestamps.values.isEmpty
          ? null
          : _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b),
    };
  }
}
