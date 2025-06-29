import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';
import 'real_time_sync_service.dart';
import 'optimized_statistics_service.dart';
import 'duplicate_prevention_service.dart';
import 'sync_edge_case_handler.dart';

/// REAL-TIME SYNC INITIALIZER
/// Coordinates initialization of all real-time synchronization components
/// Ensures proper startup sequence and error handling
class RealTimeSyncInitializer {
  static final RealTimeSyncInitializer _instance =
      RealTimeSyncInitializer._internal();
  factory RealTimeSyncInitializer() => _instance;
  RealTimeSyncInitializer._internal();

  static RealTimeSyncInitializer get instance => _instance;

  // Service instances
  final FirebaseService _firebaseService = FirebaseService.instance;
  final RealTimeSyncService _realTimeSyncService = RealTimeSyncService.instance;
  final OptimizedStatisticsService _statisticsService =
      OptimizedStatisticsService.instance;
  final DuplicatePreventionService _duplicateService =
      DuplicatePreventionService.instance;
  final SyncEdgeCaseHandler _edgeCaseHandler = SyncEdgeCaseHandler.instance;

  // Initialization state
  bool _isInitialized = false;
  bool _isInitializing = false;
  final List<String> _initializationSteps = [];
  final Map<String, bool> _componentStatus = {};
  final Completer<void> _initializationCompleter = Completer<void>();

  /// Initialize all real-time synchronization components
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('✅ Real-time sync already initialized');
      return;
    }

    if (_isInitializing) {
      debugPrint('⏳ Real-time sync initialization in progress, waiting...');
      return _initializationCompleter.future;
    }

    _isInitializing = true;
    debugPrint('🚀 Starting real-time synchronization initialization...');

    try {
      // Step 1: Verify Firebase connection
      await _verifyFirebaseConnection();
      _markStepComplete('firebase_connection');

      // Step 2: Initialize duplicate prevention service
      await _initializeDuplicatePrevention();
      _markStepComplete('duplicate_prevention');

      // Step 3: Initialize real-time sync service
      await _initializeRealTimeSync();
      _markStepComplete('real_time_sync');

      // Step 4: Initialize statistics service with real-time features
      await _initializeStatisticsService();
      _markStepComplete('statistics_service');

      // Step 5: Initialize edge case handler
      await _initializeEdgeCaseHandler();
      _markStepComplete('edge_case_handler');

      // Step 6: Setup health monitoring
      await _setupHealthMonitoring();
      _markStepComplete('health_monitoring');

      // Step 7: Perform initial sync check
      await _performInitialSyncCheck();
      _markStepComplete('initial_sync_check');

      _isInitialized = true;
      _isInitializing = false;
      _initializationCompleter.complete();

      debugPrint(
        '🎉 Real-time synchronization initialization completed successfully!',
      );
      _logInitializationSuccess();
    } catch (e) {
      _isInitializing = false;
      _initializationCompleter.completeError(e);

      debugPrint('❌ Real-time sync initialization failed: $e');
      await _handleInitializationFailure(e);
      rethrow;
    }
  }

  /// Verify Firebase connection and services
  Future<void> _verifyFirebaseConnection() async {
    debugPrint('🔍 Verifying Firebase connection...');

    try {
      // Test Firestore connection with simple read operation
      await _firebaseService.firestore.collection('users').limit(1).get();

      // Test Cloud Functions connection
      try {
        final callable = _firebaseService.functions.httpsCallable(
          'healthCheck',
        );
        await callable.call().timeout(const Duration(seconds: 5));
        _componentStatus['cloud_functions'] = true;
      } catch (e) {
        debugPrint('⚠️ Cloud Functions not available: $e');
        _componentStatus['cloud_functions'] = false;
      }

      _componentStatus['firestore'] = true;
      debugPrint('✅ Firebase connection verified');
    } catch (e) {
      debugPrint('❌ Firebase connection failed: $e');
      _componentStatus['firestore'] = false;
      rethrow;
    }
  }

  /// Initialize duplicate prevention service
  Future<void> _initializeDuplicatePrevention() async {
    debugPrint('🔍 Initializing duplicate prevention service...');

    try {
      // Clear any stale cache
      _duplicateService.clearAllCache();

      // Test duplicate checking functionality
      await _duplicateService.documentExists('_test_path');

      _componentStatus['duplicate_prevention'] = true;
      debugPrint('✅ Duplicate prevention service initialized');
    } catch (e) {
      debugPrint('❌ Duplicate prevention initialization failed: $e');
      _componentStatus['duplicate_prevention'] = false;
      rethrow;
    }
  }

  /// Initialize real-time sync service
  Future<void> _initializeRealTimeSync() async {
    debugPrint('🔄 Initializing real-time sync service...');

    try {
      await _realTimeSyncService.initialize();

      // Verify listeners are working
      if (!_realTimeSyncService.isInitialized) {
        throw Exception('Real-time sync service failed to initialize properly');
      }

      _componentStatus['real_time_sync'] = true;
      debugPrint('✅ Real-time sync service initialized');
    } catch (e) {
      debugPrint('❌ Real-time sync initialization failed: $e');
      _componentStatus['real_time_sync'] = false;
      rethrow;
    }
  }

  /// Initialize statistics service with real-time features
  Future<void> _initializeStatisticsService() async {
    debugPrint('📊 Initializing statistics service...');

    try {
      await _statisticsService.initializeRealTimeSync();

      // Test statistics fetching
      await _statisticsService.getAggregatedStatistics();

      _componentStatus['statistics_service'] = true;
      debugPrint('✅ Statistics service initialized');
    } catch (e) {
      debugPrint('❌ Statistics service initialization failed: $e');
      _componentStatus['statistics_service'] = false;
      rethrow;
    }
  }

  /// Initialize edge case handler
  Future<void> _initializeEdgeCaseHandler() async {
    debugPrint('🔧 Initializing edge case handler...');

    try {
      // Setup network issue handling
      await _edgeCaseHandler.handleNetworkIssues();

      _componentStatus['edge_case_handler'] = true;
      debugPrint('✅ Edge case handler initialized');
    } catch (e) {
      debugPrint('❌ Edge case handler initialization failed: $e');
      _componentStatus['edge_case_handler'] = false;
      // Don't rethrow - edge case handler is not critical for basic functionality
    }
  }

  /// Setup health monitoring
  Future<void> _setupHealthMonitoring() async {
    debugPrint('🏥 Setting up health monitoring...');

    try {
      // Setup periodic health checks
      Timer.periodic(const Duration(minutes: 5), (timer) {
        _performHealthCheck();
      });

      _componentStatus['health_monitoring'] = true;
      debugPrint('✅ Health monitoring setup complete');
    } catch (e) {
      debugPrint('❌ Health monitoring setup failed: $e');
      _componentStatus['health_monitoring'] = false;
      // Don't rethrow - health monitoring is not critical
    }
  }

  /// Perform initial sync check
  Future<void> _performInitialSyncCheck() async {
    debugPrint('🔍 Performing initial sync check...');

    try {
      // Check for any pending sync operations
      final pendingOps = await _checkPendingSyncOperations();

      if (pendingOps.isNotEmpty) {
        debugPrint('📋 Found ${pendingOps.length} pending sync operations');
        await _processPendingSyncOperations(pendingOps);
      }

      _componentStatus['initial_sync_check'] = true;
      debugPrint('✅ Initial sync check completed');
    } catch (e) {
      debugPrint('❌ Initial sync check failed: $e');
      _componentStatus['initial_sync_check'] = false;
      // Don't rethrow - this is not critical for initialization
    }
  }

  /// Check for pending sync operations
  Future<List<Map<String, dynamic>>> _checkPendingSyncOperations() async {
    try {
      final snapshot = await _firebaseService.firestore
          .collection('sync-operations')
          .where('status', isEqualTo: 'pending')
          .limit(10)
          .get();

      return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      debugPrint('❌ Error checking pending sync operations: $e');
      return [];
    }
  }

  /// Process pending sync operations
  Future<void> _processPendingSyncOperations(
    List<Map<String, dynamic>> operations,
  ) async {
    for (final operation in operations) {
      try {
        await _processSingleSyncOperation(operation);
      } catch (e) {
        debugPrint('❌ Error processing sync operation ${operation['id']}: $e');
      }
    }
  }

  /// Process single sync operation
  Future<void> _processSingleSyncOperation(
    Map<String, dynamic> operation,
  ) async {
    final type = operation['type'] as String?;
    final data = operation['data'] as Map<String, dynamic>?;

    if (type == null || data == null) return;

    switch (type) {
      case 'document_sync':
        await _edgeCaseHandler.handleConsoleFileAddition(data['filePath']);
        break;
      case 'user_sync':
        await _edgeCaseHandler.handleConsoleUserAddition(data['uid']);
        break;
      default:
        debugPrint('⚠️ Unknown sync operation type: $type');
    }
  }

  /// Perform periodic health check
  Future<void> _performHealthCheck() async {
    try {
      final healthStatus = await _getSystemHealthStatus();

      if (healthStatus['overall'] != 'healthy') {
        debugPrint('⚠️ System health check failed: $healthStatus');
        await _handleHealthIssues(healthStatus);
      }
    } catch (e) {
      debugPrint('❌ Health check error: $e');
    }
  }

  /// Get system health status
  Future<Map<String, dynamic>> _getSystemHealthStatus() async {
    final status = <String, dynamic>{
      'timestamp': DateTime.now().toIso8601String(),
      'components': Map.from(_componentStatus),
      'overall': 'healthy',
    };

    // Check if any critical components are down
    final criticalComponents = [
      'firestore',
      'real_time_sync',
      'statistics_service',
    ];
    final criticalIssues = criticalComponents
        .where((component) => _componentStatus[component] != true)
        .toList();

    if (criticalIssues.isNotEmpty) {
      status['overall'] = 'unhealthy';
      status['criticalIssues'] = criticalIssues;
    }

    return status;
  }

  /// Handle health issues
  Future<void> _handleHealthIssues(Map<String, dynamic> healthStatus) async {
    final criticalIssues =
        healthStatus['criticalIssues'] as List<String>? ?? [];

    for (final issue in criticalIssues) {
      debugPrint('🔧 Attempting to resolve health issue: $issue');

      try {
        switch (issue) {
          case 'firestore':
            await _verifyFirebaseConnection();
            break;
          case 'real_time_sync':
            await _initializeRealTimeSync();
            break;
          case 'statistics_service':
            await _initializeStatisticsService();
            break;
        }
      } catch (e) {
        debugPrint('❌ Failed to resolve health issue $issue: $e');
      }
    }
  }

  /// Mark initialization step as complete
  void _markStepComplete(String step) {
    _initializationSteps.add(step);
    debugPrint('✅ Initialization step completed: $step');
  }

  /// Log initialization success
  Future<void> _logInitializationSuccess() async {
    try {
      await _firebaseService.firestore.collection('system-logs').add({
        'type': 'real_time_sync_initialization',
        'status': 'success',
        'steps': _initializationSteps,
        'componentStatus': _componentStatus,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ Failed to log initialization success: $e');
    }
  }

  /// Handle initialization failure
  Future<void> _handleInitializationFailure(dynamic error) async {
    // Only log critical errors, skip permission errors for system-logs
    if (!error.toString().contains('permission-denied')) {
      try {
        await _firebaseService.firestore.collection('system-logs').add({
          'type': 'real_time_sync_initialization',
          'status': 'failure',
          'error': error.toString(),
          'completedSteps': _initializationSteps,
          'componentStatus': _componentStatus,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        // Silently fail for logging errors to avoid noise
        debugPrint('⚠️ System logging unavailable (non-critical)');
      }
    } else {
      debugPrint(
        '⚠️ Permission error during initialization (rules may need update)',
      );
    }
  }

  /// Get initialization status
  Map<String, dynamic> getInitializationStatus() {
    return {
      'isInitialized': _isInitialized,
      'isInitializing': _isInitializing,
      'completedSteps': List.from(_initializationSteps),
      'componentStatus': Map.from(_componentStatus),
    };
  }

  /// Check if system is ready
  bool get isReady => _isInitialized && _componentStatus['firestore'] == true;

  /// Get component status
  Map<String, bool> get componentStatus => Map.unmodifiable(_componentStatus);
}
