import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import '../core/services/firebase_service.dart';

/**
 * DUPLICATE PREVENTION SERVICE
 * Prevents duplicate documents and users from being created
 * Uses unique identifiers and checksums for verification
 */
class DuplicatePreventionService {
  static final DuplicatePreventionService _instance = DuplicatePreventionService._internal();
  factory DuplicatePreventionService() => _instance;
  DuplicatePreventionService._internal();

  static DuplicatePreventionService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;
  
  // Cache for recently checked items to improve performance
  final Map<String, bool> _documentExistsCache = {};
  final Map<String, bool> _userExistsCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  /// Check if document already exists based on file path
  Future<bool> documentExists(String filePath) async {
    try {
      final cacheKey = 'doc_$filePath';
      
      // Check cache first
      if (_isCacheValid(cacheKey) && _documentExistsCache.containsKey(cacheKey)) {
        debugPrint('📦 Using cached result for document: $filePath');
        return _documentExistsCache[cacheKey]!;
      }

      debugPrint('🔍 Checking if document exists: $filePath');
      
      final querySnapshot = await _firebaseService.firestore
          .collection('document-metadata')
          .where('filePath', isEqualTo: filePath)
          .where('isActive', isEqualTo: true)
          .limit(1)
          .get();

      final exists = querySnapshot.docs.isNotEmpty;
      
      // Cache the result
      _documentExistsCache[cacheKey] = exists;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      debugPrint('📄 Document exists check result: $exists for $filePath');
      return exists;
    } catch (e) {
      debugPrint('❌ Error checking document existence: $e');
      return false; // Assume doesn't exist on error to allow creation
    }
  }

  /// Check if user already exists based on UID
  Future<bool> userExists(String uid) async {
    try {
      final cacheKey = 'user_$uid';
      
      // Check cache first
      if (_isCacheValid(cacheKey) && _userExistsCache.containsKey(cacheKey)) {
        debugPrint('📦 Using cached result for user: $uid');
        return _userExistsCache[cacheKey]!;
      }

      debugPrint('🔍 Checking if user exists: $uid');
      
      final userDoc = await _firebaseService.firestore
          .collection('users')
          .doc(uid)
          .get();

      final exists = userDoc.exists && (userDoc.data()?['isActive'] == true);
      
      // Cache the result
      _userExistsCache[cacheKey] = exists;
      _cacheTimestamps[cacheKey] = DateTime.now();
      
      debugPrint('👤 User exists check result: $exists for $uid');
      return exists;
    } catch (e) {
      debugPrint('❌ Error checking user existence: $e');
      return false; // Assume doesn't exist on error to allow creation
    }
  }

  /// Generate consistent document ID from file path
  String generateDocumentId(String filePath) {
    final bytes = utf8.encode(filePath);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  /// Check for duplicate documents by multiple criteria
  Future<DuplicateCheckResult> checkDocumentDuplicates({
    required String filePath,
    String? fileName,
    int? fileSize,
    String? contentType,
  }) async {
    try {
      debugPrint('🔍 Comprehensive duplicate check for: $filePath');
      
      final checks = <String, bool>{};
      final duplicateDocuments = <Map<String, dynamic>>[];

      // Check 1: Exact file path match
      final pathQuery = await _firebaseService.firestore
          .collection('document-metadata')
          .where('filePath', isEqualTo: filePath)
          .where('isActive', isEqualTo: true)
          .get();
      
      checks['exactPath'] = pathQuery.docs.isNotEmpty;
      if (pathQuery.docs.isNotEmpty) {
        duplicateDocuments.addAll(pathQuery.docs.map((doc) => {
          'id': doc.id,
          'data': doc.data(),
          'reason': 'Exact file path match',
        }));
      }

      // Check 2: Same file name and size (if provided)
      if (fileName != null && fileSize != null) {
        final nameQuery = await _firebaseService.firestore
            .collection('document-metadata')
            .where('fileName', isEqualTo: fileName)
            .where('fileSize', isEqualTo: fileSize)
            .where('isActive', isEqualTo: true)
            .get();
        
        checks['nameAndSize'] = nameQuery.docs.isNotEmpty;
        if (nameQuery.docs.isNotEmpty) {
          for (final doc in nameQuery.docs) {
            if (!duplicateDocuments.any((d) => d['id'] == doc.id)) {
              duplicateDocuments.add({
                'id': doc.id,
                'data': doc.data(),
                'reason': 'Same file name and size',
              });
            }
          }
        }
      }

      // Check 3: Content type and name similarity (if provided)
      if (fileName != null && contentType != null) {
        final similarQuery = await _firebaseService.firestore
            .collection('document-metadata')
            .where('fileName', isEqualTo: fileName)
            .where('contentType', isEqualTo: contentType)
            .where('isActive', isEqualTo: true)
            .get();
        
        checks['similarContent'] = similarQuery.docs.isNotEmpty;
        if (similarQuery.docs.isNotEmpty) {
          for (final doc in similarQuery.docs) {
            if (!duplicateDocuments.any((d) => d['id'] == doc.id)) {
              duplicateDocuments.add({
                'id': doc.id,
                'data': doc.data(),
                'reason': 'Similar content (name + type)',
              });
            }
          }
        }
      }

      final hasDuplicates = checks.values.any((check) => check);
      
      debugPrint('📊 Duplicate check results: $checks');
      debugPrint('🔍 Found ${duplicateDocuments.length} potential duplicates');

      return DuplicateCheckResult(
        hasDuplicates: hasDuplicates,
        checks: checks,
        duplicateDocuments: duplicateDocuments,
        filePath: filePath,
      );
    } catch (e) {
      debugPrint('❌ Error in comprehensive duplicate check: $e');
      return DuplicateCheckResult(
        hasDuplicates: false,
        checks: {'error': true},
        duplicateDocuments: [],
        filePath: filePath,
        error: e.toString(),
      );
    }
  }

  /// Check for duplicate users by multiple criteria
  Future<UserDuplicateCheckResult> checkUserDuplicates({
    required String uid,
    String? email,
    String? displayName,
  }) async {
    try {
      debugPrint('🔍 Comprehensive user duplicate check for: $uid');
      
      final checks = <String, bool>{};
      final duplicateUsers = <Map<String, dynamic>>[];

      // Check 1: Exact UID match
      final uidDoc = await _firebaseService.firestore
          .collection('users')
          .doc(uid)
          .get();
      
      checks['exactUID'] = uidDoc.exists && (uidDoc.data()?['isActive'] == true);
      if (checks['exactUID']!) {
        duplicateUsers.add({
          'id': uidDoc.id,
          'data': uidDoc.data(),
          'reason': 'Exact UID match',
        });
      }

      // Check 2: Same email (if provided)
      if (email != null && email.isNotEmpty) {
        final emailQuery = await _firebaseService.firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .where('isActive', isEqualTo: true)
            .get();
        
        checks['sameEmail'] = emailQuery.docs.isNotEmpty;
        if (emailQuery.docs.isNotEmpty) {
          for (final doc in emailQuery.docs) {
            if (!duplicateUsers.any((d) => d['id'] == doc.id)) {
              duplicateUsers.add({
                'id': doc.id,
                'data': doc.data(),
                'reason': 'Same email address',
              });
            }
          }
        }
      }

      final hasDuplicates = checks.values.any((check) => check);
      
      debugPrint('📊 User duplicate check results: $checks');
      debugPrint('🔍 Found ${duplicateUsers.length} potential user duplicates');

      return UserDuplicateCheckResult(
        hasDuplicates: hasDuplicates,
        checks: checks,
        duplicateUsers: duplicateUsers,
        uid: uid,
      );
    } catch (e) {
      debugPrint('❌ Error in user duplicate check: $e');
      return UserDuplicateCheckResult(
        hasDuplicates: false,
        checks: {'error': true},
        duplicateUsers: [],
        uid: uid,
        error: e.toString(),
      );
    }
  }

  /// Clear cache for specific item
  void clearCache(String identifier) {
    final docKey = 'doc_$identifier';
    final userKey = 'user_$identifier';
    
    _documentExistsCache.remove(docKey);
    _userExistsCache.remove(userKey);
    _cacheTimestamps.remove(docKey);
    _cacheTimestamps.remove(userKey);
    
    debugPrint('🧹 Cleared cache for: $identifier');
  }

  /// Clear all cache
  void clearAllCache() {
    _documentExistsCache.clear();
    _userExistsCache.clear();
    _cacheTimestamps.clear();
    debugPrint('🧹 Cleared all duplicate prevention cache');
  }

  /// Check if cache is valid for given key
  bool _isCacheValid(String key) {
    final timestamp = _cacheTimestamps[key];
    if (timestamp == null) return false;
    
    return DateTime.now().difference(timestamp) < _cacheValidDuration;
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    final now = DateTime.now();
    final validDocuments = _documentExistsCache.keys.where((key) => _isCacheValid(key)).length;
    final validUsers = _userExistsCache.keys.where((key) => _isCacheValid(key)).length;
    
    return {
      'totalDocumentEntries': _documentExistsCache.length,
      'totalUserEntries': _userExistsCache.length,
      'validDocumentEntries': validDocuments,
      'validUserEntries': validUsers,
      'cacheHitRate': _calculateCacheHitRate(),
    };
  }

  double _calculateCacheHitRate() {
    final totalEntries = _documentExistsCache.length + _userExistsCache.length;
    if (totalEntries == 0) return 0.0;
    
    final validEntries = _documentExistsCache.keys.where((key) => _isCacheValid(key)).length +
                        _userExistsCache.keys.where((key) => _isCacheValid(key)).length;
    
    return validEntries / totalEntries;
  }
}

/// Result of duplicate check for documents
class DuplicateCheckResult {
  final bool hasDuplicates;
  final Map<String, bool> checks;
  final List<Map<String, dynamic>> duplicateDocuments;
  final String filePath;
  final String? error;

  const DuplicateCheckResult({
    required this.hasDuplicates,
    required this.checks,
    required this.duplicateDocuments,
    required this.filePath,
    this.error,
  });

  @override
  String toString() {
    return 'DuplicateCheckResult(hasDuplicates: $hasDuplicates, checks: $checks, duplicates: ${duplicateDocuments.length})';
  }
}

/// Result of duplicate check for users
class UserDuplicateCheckResult {
  final bool hasDuplicates;
  final Map<String, bool> checks;
  final List<Map<String, dynamic>> duplicateUsers;
  final String uid;
  final String? error;

  const UserDuplicateCheckResult({
    required this.hasDuplicates,
    required this.checks,
    required this.duplicateUsers,
    required this.uid,
    this.error,
  });

  @override
  String toString() {
    return 'UserDuplicateCheckResult(hasDuplicates: $hasDuplicates, checks: $checks, duplicates: ${duplicateUsers.length})';
  }
}
