import 'package:flutter/foundation.dart';

/// Feature flags for controlling application behavior
/// This allows for gradual rollout of new features and A/B testing
class FeatureFlags {
  // Delete Operation Feature Flags
  
  /// Use cloud function for document deletion instead of direct SDK calls
  /// This provides better consistency and error handling
  static const bool useCloudFunctionDelete = true;
  
  /// Enable enhanced delete error handling with retry mechanisms
  static const bool enableEnhancedDeleteErrorHandling = true;
  
  /// Show detailed delete operation logs for debugging
  static const bool enableDeleteOperationLogging = kDebugMode;
  
  /// Enable force removal option for documents not found in backend
  static const bool enableForceRemovalOption = true;
  
  // Upload Operation Feature Flags
  
  /// Use optimized upload service for better performance
  static const bool useOptimizedUploadService = true;
  
  /// Enable duplicate file detection during upload
  static const bool enableDuplicateFileDetection = true;
  
  // UI Feature Flags
  
  /// Enable enhanced file list animations
  static const bool enableEnhancedFileListAnimations = true;
  
  /// Show file operation progress indicators
  static const bool showFileOperationProgress = true;
  
  /// Enable bulk file operations
  static const bool enableBulkFileOperations = true;
  
  // Performance Feature Flags
  
  /// Use pagination for large file lists
  static const bool usePaginatedFileLists = true;
  
  /// Enable file list caching for better performance
  static const bool enableFileListCaching = true;
  
  /// Use optimized network service for API calls
  static const bool useOptimizedNetworkService = true;
  
  // Security Feature Flags
  
  /// Enforce admin-only deletion policy
  static const bool enforceAdminOnlyDeletion = true;
  
  /// Enable enhanced permission checking
  static const bool enableEnhancedPermissionChecking = true;
  
  /// Log all file operations for audit trail
  static const bool enableFileOperationAuditLogging = true;
  
  // Experimental Features
  
  /// Enable experimental direct storage deletion service
  static const bool enableDirectStorageDeletion = false;
  
  /// Enable experimental file synchronization features
  static const bool enableExperimentalFileSync = false;
  
  /// Enable beta features for testing
  static const bool enableBetaFeatures = kDebugMode;
  
  // Helper Methods
  
  /// Check if a feature is enabled
  static bool isFeatureEnabled(String featureName) {
    switch (featureName) {
      case 'cloudFunctionDelete':
        return useCloudFunctionDelete;
      case 'enhancedDeleteErrorHandling':
        return enableEnhancedDeleteErrorHandling;
      case 'deleteOperationLogging':
        return enableDeleteOperationLogging;
      case 'forceRemovalOption':
        return enableForceRemovalOption;
      case 'optimizedUploadService':
        return useOptimizedUploadService;
      case 'duplicateFileDetection':
        return enableDuplicateFileDetection;
      case 'enhancedFileListAnimations':
        return enableEnhancedFileListAnimations;
      case 'fileOperationProgress':
        return showFileOperationProgress;
      case 'bulkFileOperations':
        return enableBulkFileOperations;
      case 'paginatedFileLists':
        return usePaginatedFileLists;
      case 'fileListCaching':
        return enableFileListCaching;
      case 'optimizedNetworkService':
        return useOptimizedNetworkService;
      case 'adminOnlyDeletion':
        return enforceAdminOnlyDeletion;
      case 'enhancedPermissionChecking':
        return enableEnhancedPermissionChecking;
      case 'fileOperationAuditLogging':
        return enableFileOperationAuditLogging;
      case 'directStorageDeletion':
        return enableDirectStorageDeletion;
      case 'experimentalFileSync':
        return enableExperimentalFileSync;
      case 'betaFeatures':
        return enableBetaFeatures;
      default:
        return false;
    }
  }
  
  /// Get all enabled features for debugging
  static Map<String, bool> getAllFeatureStates() {
    return {
      'useCloudFunctionDelete': useCloudFunctionDelete,
      'enableEnhancedDeleteErrorHandling': enableEnhancedDeleteErrorHandling,
      'enableDeleteOperationLogging': enableDeleteOperationLogging,
      'enableForceRemovalOption': enableForceRemovalOption,
      'useOptimizedUploadService': useOptimizedUploadService,
      'enableDuplicateFileDetection': enableDuplicateFileDetection,
      'enableEnhancedFileListAnimations': enableEnhancedFileListAnimations,
      'showFileOperationProgress': showFileOperationProgress,
      'enableBulkFileOperations': enableBulkFileOperations,
      'usePaginatedFileLists': usePaginatedFileLists,
      'enableFileListCaching': enableFileListCaching,
      'useOptimizedNetworkService': useOptimizedNetworkService,
      'enforceAdminOnlyDeletion': enforceAdminOnlyDeletion,
      'enableEnhancedPermissionChecking': enableEnhancedPermissionChecking,
      'enableFileOperationAuditLogging': enableFileOperationAuditLogging,
      'enableDirectStorageDeletion': enableDirectStorageDeletion,
      'enableExperimentalFileSync': enableExperimentalFileSync,
      'enableBetaFeatures': enableBetaFeatures,
    };
  }
  
  /// Print all feature states for debugging
  static void printFeatureStates() {
    if (kDebugMode) {
      debugPrint('🏁 Feature Flags Status:');
      getAllFeatureStates().forEach((feature, enabled) {
        debugPrint('   $feature: ${enabled ? "✅" : "❌"}');
      });
    }
  }
}
