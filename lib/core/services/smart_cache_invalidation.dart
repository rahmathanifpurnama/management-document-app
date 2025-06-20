import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_service.dart';
import '../../models/document_model.dart';
import 'database_version_tracker.dart';
import 'unified_id_system.dart';

/// Smart Cache Invalidation System
///
/// Implements cache validation that checks for data inconsistency between
/// local cache and Firestore, not just time-based expiration.
class SmartCacheInvalidation {
  static final SmartCacheInvalidation _instance =
      SmartCacheInvalidation._internal();
  static SmartCacheInvalidation get instance => _instance;
  SmartCacheInvalidation._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;
  final DatabaseVersionTracker _versionTracker =
      DatabaseVersionTracker.instance;
  final UnifiedIdSystem _unifiedIdSystem = UnifiedIdSystem.instance;

  // Cache validation settings
  static const Duration _defaultMaxCacheAge = Duration(hours: 1);
  static const int _sampleSize =
      5; // Number of documents to sample for consistency check

  // Local storage keys
  static const String _cacheValidationKey = 'cache_validation_timestamp';
  static const String _documentCountKey = 'cached_document_count';

  /// Validate cache consistency with comprehensive checks
  Future<CacheValidationResult> validateCache({
    required List<DocumentModel> cachedDocuments,
    Duration? maxCacheAge,
    bool performDeepValidation = false,
  }) async {
    try {
      debugPrint('🔍 SmartCacheInvalidation: Starting cache validation...');

      final validationResult = CacheValidationResult();

      // 1. Check database version mismatch
      final versionMismatch = await _versionTracker.checkVersionMismatch();
      if (versionMismatch) {
        validationResult.isValid = false;
        validationResult.reasons.add('Database version mismatch detected');
        debugPrint(
          '🚨 SmartCacheInvalidation: Database version mismatch - cache invalid',
        );
        return validationResult;
      }

      // 2. Check cache age
      final cacheAge = await _getCacheAge();
      final maxAge = maxCacheAge ?? _defaultMaxCacheAge;
      if (cacheAge != null && cacheAge > maxAge) {
        validationResult.isValid = false;
        validationResult.reasons.add(
          'Cache age (${cacheAge.inMinutes}min) exceeds limit (${maxAge.inMinutes}min)',
        );
        debugPrint('⏰ SmartCacheInvalidation: Cache too old - invalid');
        return validationResult;
      }

      // 3. Check document count consistency
      final countMismatch = await _checkDocumentCountConsistency(
        cachedDocuments.length,
      );
      if (countMismatch) {
        validationResult.isValid = false;
        validationResult.reasons.add('Document count mismatch with Firestore');
        debugPrint(
          '📊 SmartCacheInvalidation: Document count mismatch - cache invalid',
        );
        return validationResult;
      }

      // 4. Sample-based document existence validation
      final existenceCheck = await _validateDocumentExistence(cachedDocuments);
      if (!existenceCheck.isValid) {
        validationResult.isValid = false;
        validationResult.reasons.addAll(existenceCheck.reasons);
        debugPrint(
          '🔍 SmartCacheInvalidation: Document existence check failed - cache invalid',
        );
        return validationResult;
      }

      // 5. Deep validation (optional, more thorough but slower)
      if (performDeepValidation) {
        final deepCheck = await _performDeepValidation(cachedDocuments);
        if (!deepCheck.isValid) {
          validationResult.isValid = false;
          validationResult.reasons.addAll(deepCheck.reasons);
          debugPrint(
            '🔬 SmartCacheInvalidation: Deep validation failed - cache invalid',
          );
          return validationResult;
        }
      }

      // Cache is valid
      validationResult.isValid = true;
      validationResult.cacheAge = cacheAge;
      debugPrint('✅ SmartCacheInvalidation: Cache validation passed');

      return validationResult;
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Cache validation error: $e');
      return CacheValidationResult()
        ..isValid = false
        ..reasons.add('Validation error: ${e.toString()}');
    }
  }

  /// Invalidate cache and clear related data
  Future<void> invalidateCache() async {
    try {
      debugPrint('🧹 SmartCacheInvalidation: Invalidating cache...');

      final prefs = await SharedPreferences.getInstance();

      // Clear cache validation timestamp
      await prefs.remove(_cacheValidationKey);
      await prefs.remove(_documentCountKey);

      // Clear unified ID system cache
      _unifiedIdSystem.clearCache();

      // Invalidate database version tracker cache
      await _versionTracker.invalidateLocalCache();

      debugPrint('✅ SmartCacheInvalidation: Cache invalidated successfully');
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error invalidating cache: $e');
    }
  }

  /// Update cache validation timestamp after successful sync
  Future<void> markCacheAsValid({required int documentCount}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
        _cacheValidationKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await prefs.setInt(_documentCountKey, documentCount);

      // Sync database version
      await _versionTracker.syncLocalVersion();

      debugPrint(
        '✅ SmartCacheInvalidation: Cache marked as valid with $documentCount documents',
      );
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error marking cache as valid: $e');
    }
  }

  /// Get cache validation information for debugging
  Future<Map<String, dynamic>> getCacheValidationInfo() async {
    try {
      final cacheAge = await _getCacheAge();
      final versionInfo = await _versionTracker.getVersionInfo();
      final idSystemStats = _unifiedIdSystem.getCacheStats();

      return {
        'cacheAge': cacheAge?.inMinutes,
        'cacheAgeHours': cacheAge?.inHours,
        'versionInfo': versionInfo,
        'idSystemStats': idSystemStats,
        'lastValidation': await _getLastValidationTime(),
      };
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error getting validation info: $e');
      return {'error': e.toString()};
    }
  }

  /// Check if document count matches between cache and Firestore
  Future<bool> _checkDocumentCountConsistency(int cachedCount) async {
    try {
      // Get actual count from Firestore
      final querySnapshot = await _firebaseService.documentsCollection
          .where('isActive', isEqualTo: true)
          .count()
          .get();

      final firestoreCount = querySnapshot.count ?? 0;

      debugPrint(
        '📊 SmartCacheInvalidation: Document count - Cache: $cachedCount, Firestore: $firestoreCount',
      );

      // Allow small discrepancy (e.g., due to recent uploads/deletions)
      const tolerance = 2;
      final difference = (cachedCount - firestoreCount).abs();

      return difference <= tolerance;
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error checking document count: $e');
      return false; // Assume inconsistency on error
    }
  }

  /// Validate existence of sample documents in Firestore
  Future<CacheValidationResult> _validateDocumentExistence(
    List<DocumentModel> documents,
  ) async {
    final result = CacheValidationResult();

    try {
      if (documents.isEmpty) {
        result.isValid = true;
        return result;
      }

      // Sample documents for validation (don't check all to avoid performance issues)
      final sampleSize = documents.length < _sampleSize
          ? documents.length
          : _sampleSize;
      final sampleDocuments = documents.take(sampleSize).toList();

      debugPrint(
        '🔍 SmartCacheInvalidation: Validating existence of ${sampleDocuments.length} sample documents',
      );

      int validCount = 0;
      for (final document in sampleDocuments) {
        final exists = await _unifiedIdSystem.validateDocumentId(document.id);
        if (exists) {
          validCount++;
        } else {
          result.reasons.add(
            'Document not found in Firestore: ${document.fileName} (ID: ${document.id})',
          );
        }
      }

      // Require at least 80% of sample documents to exist
      final validPercentage = validCount / sampleDocuments.length;
      result.isValid = validPercentage >= 0.8;

      debugPrint(
        '📊 SmartCacheInvalidation: Document existence check - $validCount/${sampleDocuments.length} valid (${(validPercentage * 100).toStringAsFixed(1)}%)',
      );

      if (!result.isValid) {
        result.reasons.add(
          'Too many documents missing from Firestore (${(validPercentage * 100).toStringAsFixed(1)}% valid, need 80%+)',
        );
      }

      return result;
    } catch (e) {
      debugPrint(
        '❌ SmartCacheInvalidation: Error validating document existence: $e',
      );
      result.isValid = false;
      result.reasons.add(
        'Document existence validation error: ${e.toString()}',
      );
      return result;
    }
  }

  /// Perform deep validation (more thorough but slower)
  Future<CacheValidationResult> _performDeepValidation(
    List<DocumentModel> documents,
  ) async {
    final result = CacheValidationResult();

    try {
      debugPrint('🔬 SmartCacheInvalidation: Performing deep validation...');

      // Check for ID normalization issues
      final normalizedDocuments = await _unifiedIdSystem.normalizeDocumentIds(
        documents,
      );
      final normalizationIssues = documents.length - normalizedDocuments.length;

      if (normalizationIssues > 0) {
        result.reasons.add(
          '$normalizationIssues documents have ID normalization issues',
        );
      }

      // Allow up to 10% normalization issues
      final issuePercentage = normalizationIssues / documents.length;
      result.isValid = issuePercentage <= 0.1;

      debugPrint(
        '🔬 SmartCacheInvalidation: Deep validation - $normalizationIssues issues (${(issuePercentage * 100).toStringAsFixed(1)}%)',
      );

      return result;
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error in deep validation: $e');
      result.isValid = false;
      result.reasons.add('Deep validation error: ${e.toString()}');
      return result;
    }
  }

  /// Get cache age from last validation timestamp
  Future<Duration?> _getCacheAge() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheValidationKey);
      if (timestamp != null) {
        final lastValidation = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return DateTime.now().difference(lastValidation);
      }
      return null;
    } catch (e) {
      debugPrint('❌ SmartCacheInvalidation: Error getting cache age: $e');
      return null;
    }
  }

  /// Get last validation time for debugging
  Future<DateTime?> _getLastValidationTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_cacheValidationKey);
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      debugPrint(
        '❌ SmartCacheInvalidation: Error getting last validation time: $e',
      );
      return null;
    }
  }
}

/// Result of cache validation
class CacheValidationResult {
  bool isValid = true;
  List<String> reasons = [];
  Duration? cacheAge;

  @override
  String toString() {
    return 'CacheValidationResult(isValid: $isValid, reasons: $reasons, cacheAge: $cacheAge)';
  }
}
