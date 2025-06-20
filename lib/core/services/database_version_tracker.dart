import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_service.dart';

/// Database Version Tracker
///
/// Tracks database version/timestamp to detect when the database has been
/// recreated or reseeded, allowing the app to invalidate stale local cache.
class DatabaseVersionTracker {
  static final DatabaseVersionTracker _instance =
      DatabaseVersionTracker._internal();
  static DatabaseVersionTracker get instance => _instance;
  DatabaseVersionTracker._internal();

  final FirebaseService _firebaseService = FirebaseService.instance;

  // Collection and document for version tracking
  static const String _versionCollection = 'system-metadata';
  static const String _versionDocument = 'database-version';

  // Local storage keys
  static const String _localVersionKey = 'local_database_version';
  static const String _lastSyncKey = 'last_database_sync';

  /// Initialize database version tracking
  /// Should be called when the app starts
  Future<void> initialize() async {
    try {
      debugPrint('🔄 DatabaseVersionTracker: Initializing...');

      // Ensure version document exists in Firestore
      await _ensureVersionDocumentExists();

      // Check for version mismatch
      final versionMismatch = await checkVersionMismatch();
      if (versionMismatch) {
        debugPrint(
          '⚠️ DatabaseVersionTracker: Version mismatch detected - cache invalidation needed',
        );
      }

      debugPrint('✅ DatabaseVersionTracker: Initialized successfully');
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Initialization failed: $e');
    }
  }

  /// Update database version (should be called after database recreation/seeding)
  Future<void> updateDatabaseVersion({String? reason}) async {
    try {
      final timestamp = FieldValue.serverTimestamp();
      final versionData = {
        'version': DateTime.now().millisecondsSinceEpoch,
        'timestamp': timestamp,
        'reason': reason ?? 'Database updated',
        'updatedAt': timestamp,
      };

      await _firebaseService.firestore
          .collection(_versionCollection)
          .doc(_versionDocument)
          .set(versionData, SetOptions(merge: true));

      debugPrint(
        '✅ DatabaseVersionTracker: Database version updated - $reason',
      );
    } catch (e) {
      debugPrint(
        '❌ DatabaseVersionTracker: Failed to update database version: $e',
      );
      rethrow;
    }
  }

  /// Check if there's a version mismatch between local cache and Firestore
  Future<bool> checkVersionMismatch() async {
    try {
      debugPrint('🔍 DatabaseVersionTracker: Checking for version mismatch...');

      // Get remote version from Firestore
      final remoteVersion = await _getRemoteVersion();
      if (remoteVersion == null) {
        debugPrint('⚠️ DatabaseVersionTracker: No remote version found');
        return false;
      }

      // Get local version from SharedPreferences
      final localVersion = await _getLocalVersion();

      debugPrint(
        '📊 DatabaseVersionTracker: Remote version: $remoteVersion, Local version: $localVersion',
      );

      // Check for mismatch
      final mismatch = localVersion == null || localVersion != remoteVersion;

      if (mismatch) {
        debugPrint('🚨 DatabaseVersionTracker: Version mismatch detected!');
        debugPrint('   Remote: $remoteVersion');
        debugPrint('   Local: $localVersion');
      } else {
        debugPrint('✅ DatabaseVersionTracker: Versions match');
      }

      return mismatch;
    } catch (e) {
      debugPrint(
        '❌ DatabaseVersionTracker: Error checking version mismatch: $e',
      );
      return false;
    }
  }

  /// Sync local version with remote version
  /// Should be called after successful data sync
  Future<void> syncLocalVersion() async {
    try {
      final remoteVersion = await _getRemoteVersion();
      if (remoteVersion != null) {
        await _setLocalVersion(remoteVersion);
        await _setLastSyncTime(DateTime.now());
        debugPrint(
          '✅ DatabaseVersionTracker: Local version synced to $remoteVersion',
        );
      }
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Failed to sync local version: $e');
    }
  }

  /// Force invalidate local cache by clearing local version
  Future<void> invalidateLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localVersionKey);
      await prefs.remove(_lastSyncKey);
      debugPrint('🧹 DatabaseVersionTracker: Local cache invalidated');
    } catch (e) {
      debugPrint(
        '❌ DatabaseVersionTracker: Failed to invalidate local cache: $e',
      );
    }
  }

  /// Get database version information for debugging
  Future<Map<String, dynamic>> getVersionInfo() async {
    try {
      final remoteVersion = await _getRemoteVersion();
      final localVersion = await _getLocalVersion();
      final lastSync = await _getLastSyncTime();
      final mismatch = await checkVersionMismatch();

      return {
        'remoteVersion': remoteVersion,
        'localVersion': localVersion,
        'lastSync': lastSync?.toIso8601String(),
        'versionMismatch': mismatch,
        'cacheAge': lastSync != null
            ? DateTime.now().difference(lastSync).inMinutes
            : null,
      };
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error getting version info: $e');
      return {'error': e.toString()};
    }
  }

  /// Check if cache should be refreshed based on version and time
  Future<bool> shouldRefreshCache({Duration? maxCacheAge}) async {
    try {
      // Always refresh if there's a version mismatch
      if (await checkVersionMismatch()) {
        return true;
      }

      // Check cache age if specified
      if (maxCacheAge != null) {
        final lastSync = await _getLastSyncTime();
        if (lastSync == null) {
          return true;
        }

        final cacheAge = DateTime.now().difference(lastSync);
        if (cacheAge > maxCacheAge) {
          debugPrint(
            '⏰ DatabaseVersionTracker: Cache age (${cacheAge.inMinutes}min) exceeds limit (${maxCacheAge.inMinutes}min)',
          );
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error checking cache refresh: $e');
      return true; // Err on the side of caution
    }
  }

  /// Private method to ensure version document exists
  Future<void> _ensureVersionDocumentExists() async {
    try {
      final docRef = _firebaseService.firestore
          .collection(_versionCollection)
          .doc(_versionDocument);

      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        // Create initial version document
        await updateDatabaseVersion(
          reason: 'Initial version document creation',
        );
      }
    } catch (e) {
      debugPrint(
        '❌ DatabaseVersionTracker: Failed to ensure version document exists: $e',
      );
    }
  }

  /// Get remote version from Firestore
  Future<int?> _getRemoteVersion() async {
    try {
      final docSnapshot = await _firebaseService.firestore
          .collection(_versionCollection)
          .doc(_versionDocument)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        return data['version'] as int?;
      }
      return null;
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error getting remote version: $e');
      return null;
    }
  }

  /// Get local version from SharedPreferences
  Future<int?> _getLocalVersion() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_localVersionKey);
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error getting local version: $e');
      return null;
    }
  }

  /// Set local version in SharedPreferences
  Future<void> _setLocalVersion(int version) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_localVersionKey, version);
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error setting local version: $e');
    }
  }

  /// Get last sync time
  Future<DateTime?> _getLastSyncTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_lastSyncKey);
      return timestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(timestamp)
          : null;
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error getting last sync time: $e');
      return null;
    }
  }

  /// Set last sync time
  Future<void> _setLastSyncTime(DateTime time) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_lastSyncKey, time.millisecondsSinceEpoch);
    } catch (e) {
      debugPrint('❌ DatabaseVersionTracker: Error setting last sync time: $e');
    }
  }
}
