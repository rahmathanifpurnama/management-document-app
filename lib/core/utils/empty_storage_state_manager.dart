import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Singleton class to manage empty storage state and prevent redundant checks
/// This ensures empty state is cached and persisted across app sessions
class EmptyStorageStateManager {
  static EmptyStorageStateManager? _instance;
  static EmptyStorageStateManager get instance => _instance ??= EmptyStorageStateManager._();
  
  EmptyStorageStateManager._();
  
  // State variables
  bool _isStorageEmpty = false;
  bool _isEmptyStateConfirmed = false;
  DateTime? _lastEmptyCheckTime;
  bool _hasCheckedThisSession = false;
  
  // Cache duration - how long to trust the empty state
  static const Duration _cacheValidDuration = Duration(minutes: 5);
  
  // Preference keys
  static const String _keyIsStorageEmpty = 'is_storage_empty';
  static const String _keyLastCheckTime = 'last_empty_check_time';
  static const String _keyEmptyStateConfirmed = 'empty_state_confirmed';
  
  /// Initialize from shared preferences
  Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isStorageEmpty = prefs.getBool(_keyIsStorageEmpty) ?? false;
      _isEmptyStateConfirmed = prefs.getBool(_keyEmptyStateConfirmed) ?? false;
      
      final lastCheckTimeMs = prefs.getInt(_keyLastCheckTime);
      if (lastCheckTimeMs != null) {
        _lastEmptyCheckTime = DateTime.fromMillisecondsSinceEpoch(lastCheckTimeMs);
      }
      
      // Check if cached state is still valid
      if (_lastEmptyCheckTime != null) {
        final cacheAge = DateTime.now().difference(_lastEmptyCheckTime!);
        if (cacheAge > _cacheValidDuration) {
          // Cache expired, reset state
          await _resetState();
        }
      }
      
      debugPrint('🗄️ EmptyStorageStateManager initialized: empty=$_isStorageEmpty, confirmed=$_isEmptyStateConfirmed');
    } catch (e) {
      debugPrint('❌ Failed to initialize EmptyStorageStateManager: $e');
      await _resetState();
    }
  }
  
  /// Check if storage is confirmed empty (cached result)
  bool get isStorageEmpty => _isStorageEmpty;
  
  /// Check if empty state has been confirmed and cached
  bool get isEmptyStateConfirmed => _isEmptyStateConfirmed;
  
  /// Check if we've already checked storage this session
  bool get hasCheckedThisSession => _hasCheckedThisSession;
  
  /// Get time of last empty check
  DateTime? get lastEmptyCheckTime => _lastEmptyCheckTime;
  
  /// Check if cached empty state is still valid
  bool get isCacheValid {
    if (_lastEmptyCheckTime == null) return false;
    final cacheAge = DateTime.now().difference(_lastEmptyCheckTime!);
    return cacheAge <= _cacheValidDuration;
  }
  
  /// Set storage as empty and cache the result
  Future<void> setStorageEmpty() async {
    if (_isStorageEmpty && _isEmptyStateConfirmed) {
      // Already set, no need to update
      return;
    }
    
    _isStorageEmpty = true;
    _isEmptyStateConfirmed = true;
    _hasCheckedThisSession = true;
    _lastEmptyCheckTime = DateTime.now();
    
    await _saveToPreferences();
    
    debugPrint('📁 EmptyStorageStateManager: Storage marked as empty and cached');
  }
  
  /// Set storage as not empty and clear cache
  Future<void> setStorageNotEmpty() async {
    _isStorageEmpty = false;
    _isEmptyStateConfirmed = false;
    _hasCheckedThisSession = true;
    _lastEmptyCheckTime = DateTime.now();
    
    await _saveToPreferences();
    
    debugPrint('📁 EmptyStorageStateManager: Storage marked as not empty');
  }
  
  /// Mark that we've checked storage this session
  void markCheckedThisSession() {
    _hasCheckedThisSession = true;
  }
  
  /// Reset empty state (for manual refresh or new uploads)
  Future<void> resetEmptyState() async {
    await _resetState();
    debugPrint('🔄 EmptyStorageStateManager: Empty state reset');
  }
  
  /// Check if we should skip loading operations
  bool shouldSkipLoading() {
    return _isEmptyStateConfirmed && isCacheValid;
  }
  
  /// Check if we should skip retry operations
  bool shouldSkipRetries() {
    return _isEmptyStateConfirmed && isCacheValid;
  }
  
  /// Check if we should show empty UI
  bool shouldShowEmptyUI() {
    return _isEmptyStateConfirmed;
  }
  
  /// Save state to shared preferences
  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_keyIsStorageEmpty, _isStorageEmpty);
      await prefs.setBool(_keyEmptyStateConfirmed, _isEmptyStateConfirmed);
      
      if (_lastEmptyCheckTime != null) {
        await prefs.setInt(_keyLastCheckTime, _lastEmptyCheckTime!.millisecondsSinceEpoch);
      }
    } catch (e) {
      debugPrint('❌ Failed to save EmptyStorageStateManager state: $e');
    }
  }
  
  /// Reset all state
  Future<void> _resetState() async {
    _isStorageEmpty = false;
    _isEmptyStateConfirmed = false;
    _hasCheckedThisSession = false;
    _lastEmptyCheckTime = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyIsStorageEmpty);
      await prefs.remove(_keyEmptyStateConfirmed);
      await prefs.remove(_keyLastCheckTime);
    } catch (e) {
      debugPrint('❌ Failed to reset EmptyStorageStateManager state: $e');
    }
  }
  
  /// Get debug information
  Map<String, dynamic> getDebugInfo() {
    return {
      'isStorageEmpty': _isStorageEmpty,
      'isEmptyStateConfirmed': _isEmptyStateConfirmed,
      'hasCheckedThisSession': _hasCheckedThisSession,
      'lastEmptyCheckTime': _lastEmptyCheckTime?.toIso8601String(),
      'isCacheValid': isCacheValid,
      'shouldSkipLoading': shouldSkipLoading(),
      'shouldSkipRetries': shouldSkipRetries(),
      'shouldShowEmptyUI': shouldShowEmptyUI(),
    };
  }
}
