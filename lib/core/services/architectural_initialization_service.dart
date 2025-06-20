import 'package:flutter/foundation.dart';
import 'unified_id_system.dart';
import 'database_version_tracker.dart';
import 'smart_cache_invalidation.dart';
import 'id_reconciliation_service.dart';

/// Architectural Initialization Service
/// 
/// Coordinates the initialization and interaction of all architectural services
/// to ensure proper system startup and data consistency.
class ArchitecturalInitializationService {
  static final ArchitecturalInitializationService _instance = 
      ArchitecturalInitializationService._internal();
  static ArchitecturalInitializationService get instance => _instance;
  ArchitecturalInitializationService._internal();

  // Service instances
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;
  final DatabaseVersionTracker _versionTracker = DatabaseVersionTracker.instance;
  final SmartCacheInvalidation _cacheInvalidation = SmartCacheInvalidation.instance;
  final IdReconciliationService _reconciliationService = IdReconciliationService.instance;

  bool _isInitialized = false;
  bool _isInitializing = false;

  /// Initialize all architectural services in the correct order
  Future<InitializationResult> initializeArchitecturalServices({
    bool forceReconciliation = false,
    bool performDeepValidation = false,
  }) async {
    if (_isInitialized && !forceReconciliation) {
      debugPrint('✅ Architectural services already initialized');
      return InitializationResult.success('Services already initialized');
    }

    if (_isInitializing) {
      debugPrint('⚠️ Architectural services initialization already in progress');
      return InitializationResult.inProgress('Initialization in progress');
    }

    _isInitializing = true;
    final result = InitializationResult();
    final startTime = DateTime.now();

    try {
      debugPrint('🚀 Starting architectural services initialization...');

      // Step 1: Initialize Database Version Tracker
      debugPrint('1️⃣ Initializing Database Version Tracker...');
      await _versionTracker.initialize();
      result.steps.add('Database Version Tracker initialized');

      // Step 2: Check for version mismatch and handle accordingly
      debugPrint('2️⃣ Checking database version consistency...');
      final versionMismatch = await _versionTracker.checkVersionMismatch();
      if (versionMismatch) {
        debugPrint('⚠️ Database version mismatch detected - invalidating cache');
        await _cacheInvalidation.invalidateCache();
        result.steps.add('Cache invalidated due to version mismatch');
        
        if (forceReconciliation) {
          debugPrint('🔄 Performing forced reconciliation due to version mismatch...');
          final reconciliationResult = await _reconciliationService.performFullReconciliation();
          if (reconciliationResult.success) {
            result.steps.add('Full reconciliation completed successfully');
          } else {
            result.steps.add('Reconciliation failed: ${reconciliationResult.message}');
          }
        }
      } else {
        result.steps.add('Database version is consistent');
      }

      // Step 3: Clear and reset ID system cache if needed
      debugPrint('3️⃣ Resetting Unified ID System cache...');
      _unifiedIdSystem.clearCache();
      result.steps.add('Unified ID System cache cleared');

      // Step 4: Validate system readiness
      debugPrint('4️⃣ Validating system readiness...');
      final systemValidation = await _validateSystemReadiness(performDeepValidation);
      result.steps.addAll(systemValidation.validationSteps);
      
      if (!systemValidation.isValid) {
        result.success = false;
        result.message = 'System validation failed: ${systemValidation.issues.join(', ')}';
        return result;
      }

      // Step 5: Mark as initialized
      _isInitialized = true;
      result.success = true;
      result.duration = DateTime.now().difference(startTime);
      result.message = 'All architectural services initialized successfully';

      debugPrint('✅ Architectural services initialization completed in ${result.duration!.inMilliseconds}ms');
      debugPrint('📊 Initialization steps: ${result.steps.length}');

      return result;
    } catch (e) {
      debugPrint('❌ Architectural services initialization failed: $e');
      result.success = false;
      result.message = 'Initialization failed: ${e.toString()}';
      result.duration = DateTime.now().difference(startTime);
      return result;
    } finally {
      _isInitializing = false;
    }
  }

  /// Validate that all systems are ready and consistent
  Future<SystemValidationResult> _validateSystemReadiness(bool performDeepValidation) async {
    final validation = SystemValidationResult();
    
    try {
      // Check 1: Database version tracker functionality
      final versionInfo = await _versionTracker.getVersionInfo();
      if (versionInfo.containsKey('error')) {
        validation.issues.add('Database version tracker error: ${versionInfo['error']}');
      } else {
        validation.validationSteps.add('Database version tracker is functional');
      }

      // Check 2: Cache invalidation service functionality
      final cacheInfo = await _cacheInvalidation.getCacheValidationInfo();
      if (cacheInfo.containsKey('error')) {
        validation.issues.add('Cache invalidation service error: ${cacheInfo['error']}');
      } else {
        validation.validationSteps.add('Cache invalidation service is functional');
      }

      // Check 3: Unified ID system functionality
      final idSystemStats = _unifiedIdSystem.getCacheStats();
      validation.validationSteps.add('Unified ID system is functional (${idSystemStats['timestamp']})');

      // Check 4: Deep validation if requested
      if (performDeepValidation) {
        debugPrint('🔬 Performing deep system validation...');
        
        // Test ID generation
        final testId = _unifiedIdSystem.generateDocumentId();
        if (testId.isNotEmpty) {
          validation.validationSteps.add('ID generation test passed');
        } else {
          validation.issues.add('ID generation test failed');
        }

        // Test ID validation
        final isValidTestId = await _unifiedIdSystem.validateDocumentId(testId);
        if (!isValidTestId) {
          validation.validationSteps.add('Generated ID validation test passed (expected false for new ID)');
        }
      }

      validation.isValid = validation.issues.isEmpty;
      return validation;
    } catch (e) {
      validation.issues.add('System validation error: ${e.toString()}');
      validation.isValid = false;
      return validation;
    }
  }

  /// Get comprehensive system status
  Future<Map<String, dynamic>> getSystemStatus() async {
    try {
      final versionInfo = await _versionTracker.getVersionInfo();
      final cacheInfo = await _cacheInvalidation.getCacheValidationInfo();
      final idSystemStats = _unifiedIdSystem.getCacheStats();

      return {
        'initialized': _isInitialized,
        'initializing': _isInitializing,
        'versionTracker': versionInfo,
        'cacheInvalidation': cacheInfo,
        'unifiedIdSystem': idSystemStats,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Perform maintenance operations
  Future<MaintenanceResult> performMaintenance({
    bool clearCaches = true,
    bool reconcileIds = false,
    bool updateVersion = false,
  }) async {
    final result = MaintenanceResult();
    final startTime = DateTime.now();

    try {
      debugPrint('🔧 Starting system maintenance...');

      if (clearCaches) {
        debugPrint('🧹 Clearing all caches...');
        _unifiedIdSystem.clearCache();
        await _cacheInvalidation.invalidateCache();
        result.operations.add('Caches cleared');
      }

      if (reconcileIds) {
        debugPrint('🔄 Performing ID reconciliation...');
        final reconciliationResult = await _reconciliationService.performFullReconciliation();
        if (reconciliationResult.success) {
          result.operations.add('ID reconciliation completed successfully');
        } else {
          result.operations.add('ID reconciliation failed: ${reconciliationResult.message}');
        }
      }

      if (updateVersion) {
        debugPrint('📊 Updating database version...');
        await _versionTracker.updateDatabaseVersion(reason: 'Manual maintenance operation');
        result.operations.add('Database version updated');
      }

      result.success = true;
      result.duration = DateTime.now().difference(startTime);
      result.message = 'Maintenance completed successfully';

      debugPrint('✅ System maintenance completed in ${result.duration!.inMilliseconds}ms');
      return result;
    } catch (e) {
      debugPrint('❌ System maintenance failed: $e');
      result.success = false;
      result.message = 'Maintenance failed: ${e.toString()}';
      result.duration = DateTime.now().difference(startTime);
      return result;
    }
  }

  /// Reset all architectural services (for testing or recovery)
  Future<void> resetAllServices() async {
    debugPrint('🔄 Resetting all architectural services...');
    
    _isInitialized = false;
    _isInitializing = false;
    
    _unifiedIdSystem.clearCache();
    await _cacheInvalidation.invalidateCache();
    await _versionTracker.invalidateLocalCache();
    
    debugPrint('✅ All architectural services reset');
  }

  /// Check if services are properly initialized
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;
}

/// Result of initialization process
class InitializationResult {
  bool success = false;
  String message = '';
  Duration? duration;
  List<String> steps = [];

  InitializationResult();
  
  InitializationResult.success(this.message) : success = true;
  InitializationResult.inProgress(this.message) : success = false;

  @override
  String toString() {
    return 'InitializationResult(success: $success, message: $message, steps: ${steps.length})';
  }
}

/// Result of system validation
class SystemValidationResult {
  bool isValid = true;
  List<String> issues = [];
  List<String> validationSteps = [];

  @override
  String toString() {
    return 'SystemValidationResult(isValid: $isValid, issues: ${issues.length}, steps: ${validationSteps.length})';
  }
}

/// Result of maintenance operations
class MaintenanceResult {
  bool success = false;
  String message = '';
  Duration? duration;
  List<String> operations = [];

  @override
  String toString() {
    return 'MaintenanceResult(success: $success, message: $message, operations: ${operations.length})';
  }
}
