import 'package:flutter/material.dart';
import '../models/activity_model.dart';
import '../models/activity_factory.dart';
import 'activity_service.dart';

/// Data manager that encapsulates activity data logic and provides clean interfaces for UI
class ActivityDataManager {
  final ActivityService _activityService = ActivityService();
  
  // Internal state
  List<BaseActivity> _activities = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  String? _lastTimestamp;
  String? _error;
  
  // Filter state
  String _selectedFilter = 'all';
  String _searchQuery = '';
  DateTimeRange? _dateRange;
  
  // Configuration
  static const int _defaultPageSize = 25;
  final int _pageSize;
  
  // Callbacks for UI updates
  VoidCallback? _onStateChanged;
  
  ActivityDataManager({int pageSize = _defaultPageSize}) : _pageSize = pageSize;
  
  // Public getters for UI
  List<BaseActivity> get activities => List.unmodifiable(_activities);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  String? get error => _error;
  String get selectedFilter => _selectedFilter;
  String get searchQuery => _searchQuery;
  DateTimeRange? get dateRange => _dateRange;
  bool get hasActiveFilters => _selectedFilter != 'all' || _searchQuery.isNotEmpty || _dateRange != null;
  
  /// Set callback for state changes
  void setStateChangeCallback(VoidCallback callback) {
    _onStateChanged = callback;
  }
  
  /// Notify UI of state changes
  void _notifyStateChanged() {
    _onStateChanged?.call();
  }
  
  /// Initialize data loading
  Future<void> initialize() async {
    await loadActivities(reset: true);
  }
  
  /// Load activities with optional reset
  Future<void> loadActivities({bool reset = false, bool showLoading = true}) async {
    if (reset) {
      _lastTimestamp = null;
      _hasMoreData = true;
      _error = null;
    }
    
    if (!_hasMoreData && !reset) return;
    
    if (showLoading) {
      _isLoading = reset;
      _isLoadingMore = !reset;
      _notifyStateChanged();
    }
    
    try {
      final result = await _activityService.getFilteredActivities(
        filter: _selectedFilter,
        searchQuery: _searchQuery.isNotEmpty ? _searchQuery : null,
        dateRange: _dateRange,
        limit: _pageSize,
        startAfterTimestamp: _lastTimestamp,
      );
      
      final activitiesData = result['activities'] as List?;
      final hasMore = result['hasMore'] as bool? ?? false;
      final lastTimestamp = result['lastTimestamp'] as String?;
      
      if (activitiesData != null) {
        final newActivities = _parseActivitiesData(activitiesData);
        
        if (reset) {
          _activities = newActivities;
        } else {
          _activities.addAll(newActivities);
        }
        
        _hasMoreData = hasMore;
        _lastTimestamp = lastTimestamp;
        _error = null;
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('ActivityDataManager: Error loading activities: $e');
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      _notifyStateChanged();
    }
  }
  
  /// Parse activities data from service response
  List<BaseActivity> _parseActivitiesData(List activitiesData) {
    final activities = <BaseActivity>[];
    
    for (final data in activitiesData) {
      try {
        if (data is Map) {
          final activity = ActivityFactory.fromMap(
            data['id'] ?? '',
            Map<String, dynamic>.from(data),
          );
          activities.add(activity);
        }
      } catch (e) {
        debugPrint('ActivityDataManager: Error parsing activity: $e');
      }
    }
    
    return activities;
  }
  
  /// Apply filter and reload data
  Future<void> applyFilter(String filter) async {
    if (_selectedFilter == filter) return;
    
    _selectedFilter = filter;
    await loadActivities(reset: true);
  }
  
  /// Apply search query and reload data
  Future<void> applySearch(String query) async {
    if (_searchQuery == query) return;
    
    _searchQuery = query;
    await loadActivities(reset: true);
  }
  
  /// Apply date range filter and reload data
  Future<void> applyDateRange(DateTimeRange? range) async {
    if (_dateRange == range) return;
    
    _dateRange = range;
    await loadActivities(reset: true);
  }
  
  /// Clear all filters and reload data
  Future<void> clearFilters() async {
    bool hasChanges = false;
    
    if (_selectedFilter != 'all') {
      _selectedFilter = 'all';
      hasChanges = true;
    }
    
    if (_searchQuery.isNotEmpty) {
      _searchQuery = '';
      hasChanges = true;
    }
    
    if (_dateRange != null) {
      _dateRange = null;
      hasChanges = true;
    }
    
    if (hasChanges) {
      await loadActivities(reset: true);
    }
  }
  
  /// Load more activities (pagination)
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMoreData) return;
    await loadActivities(reset: false);
  }
  
  /// Refresh all data
  Future<void> refresh() async {
    await loadActivities(reset: true);
  }
  
  /// Get activity statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      return await _activityService.getActivityStatistics();
    } catch (e) {
      debugPrint('ActivityDataManager: Error loading statistics: $e');
      return {
        'todayCount': 0,
        'weekCount': 0,
        'activeUsers': 0,
        'suspiciousCount': 0,
      };
    }
  }
  
  /// Get activity by ID
  BaseActivity? getActivityById(String id) {
    try {
      return _activities.firstWhere((activity) => activity.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Get activities by type
  List<BaseActivity> getActivitiesByType(String type) {
    return _activities.where((activity) => activity.type == type).toList();
  }
  
  /// Get suspicious activities
  List<BaseActivity> getSuspiciousActivities() {
    return _activities.where((activity) => activity.isSuspicious).toList();
  }
  
  /// Get activities for specific user
  List<BaseActivity> getActivitiesForUser(String userId) {
    return _activities.where((activity) => activity.userId == userId).toList();
  }
  
  /// Get filter summary for UI display
  String getFilterSummary() {
    final filters = <String>[];
    
    if (_selectedFilter != 'all') {
      filters.add(_getFilterDisplayName(_selectedFilter));
    }
    
    if (_searchQuery.isNotEmpty) {
      filters.add('Search: "$_searchQuery"');
    }
    
    if (_dateRange != null) {
      final start = _dateRange!.start;
      final end = _dateRange!.end;
      filters.add('${start.day}/${start.month} - ${end.day}/${end.month}');
    }
    
    return filters.isEmpty ? 'All Activities' : filters.join(' • ');
  }
  
  /// Get display name for filter
  String _getFilterDisplayName(String filter) {
    switch (filter) {
      case 'login':
        return 'Login/Logout';
      case 'file':
        return 'File Operations';
      case 'upload':
        return 'Uploads';
      case 'download':
        return 'Downloads';
      case 'delete':
        return 'Deletions';
      case 'suspicious':
        return 'Suspicious';
      default:
        return filter.toUpperCase();
    }
  }
  
  /// Dispose resources
  void dispose() {
    _onStateChanged = null;
  }
}
