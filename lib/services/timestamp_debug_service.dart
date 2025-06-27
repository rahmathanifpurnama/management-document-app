import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/services/firebase_service.dart';

/// Service for debugging timestamp-related issues in recent files calculation
/// Provides detailed logging and analysis of timestamp data consistency
class TimestampDebugService {
  static final TimestampDebugService _instance =
      TimestampDebugService._internal();
  factory TimestampDebugService() => _instance;
  TimestampDebugService._internal();

  static TimestampDebugService get instance => _instance;

  final FirebaseService _firebaseService = FirebaseService.instance;

  /// Comprehensive timestamp analysis for recent files debugging
  Future<Map<String, dynamic>> analyzeTimestampConsistency() async {
    debugPrint('🔍 Starting comprehensive timestamp analysis...');

    try {
      final firestore = _firebaseService.firestore;
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Get all active documents for analysis
      final allDocsSnapshot = await firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .limit(100) // Limit for analysis
          .get();

      final analysis = <String, dynamic>{
        'totalDocuments': allDocsSnapshot.docs.length,
        'analysisTime': now.toIso8601String(),
        'cutoffDate': sevenDaysAgo.toIso8601String(),
        'timestampFormats': <String, int>{},
        'recentFilesCount': 0,
        'timestampIssues': <String>[],
        'sampleDocuments': <Map<String, dynamic>>[],
      };

      int recentCount = 0;
      final timestampFormats = <String, int>{};
      final issues = <String>[];
      final samples = <Map<String, dynamic>>[];

      for (final doc in allDocsSnapshot.docs) {
        final data = doc.data();
        final uploadedAt = data['uploadedAt'];

        // Analyze timestamp format
        String timestampType;
        DateTime? parsedDate;

        if (uploadedAt == null) {
          timestampType = 'null';
          issues.add('Document ${doc.id} has null uploadedAt');
        } else if (uploadedAt is Timestamp) {
          timestampType = 'Firestore Timestamp';
          parsedDate = uploadedAt.toDate();
        } else if (uploadedAt is DateTime) {
          timestampType = 'DateTime';
          parsedDate = uploadedAt;
        } else if (uploadedAt is String) {
          timestampType = 'String';
          try {
            parsedDate = DateTime.parse(uploadedAt);
          } catch (e) {
            issues.add(
              'Document ${doc.id} has invalid date string: $uploadedAt',
            );
          }
        } else {
          timestampType = 'Unknown (${uploadedAt.runtimeType})';
          issues.add(
            'Document ${doc.id} has unknown timestamp type: ${uploadedAt.runtimeType}',
          );
        }

        // Count timestamp formats
        timestampFormats[timestampType] =
            (timestampFormats[timestampType] ?? 0) + 1;

        // Check if recent
        if (parsedDate != null && parsedDate.isAfter(sevenDaysAgo)) {
          recentCount++;
        }

        // Collect samples (first 10)
        if (samples.length < 10) {
          samples.add({
            'documentId': doc.id,
            'fileName': data['fileName'] ?? 'Unknown',
            'uploadedAt': uploadedAt?.toString(),
            'timestampType': timestampType,
            'parsedDate': parsedDate?.toIso8601String(),
            'isRecent': parsedDate?.isAfter(sevenDaysAgo) ?? false,
            'daysAgo': parsedDate != null
                ? now.difference(parsedDate).inDays
                : null,
          });
        }
      }

      analysis['recentFilesCount'] = recentCount;
      analysis['timestampFormats'] = timestampFormats;
      analysis['timestampIssues'] = issues;
      analysis['sampleDocuments'] = samples;

      // Log detailed analysis
      debugPrint('📊 Timestamp Analysis Results:');
      debugPrint('   Total documents analyzed: ${analysis['totalDocuments']}');
      debugPrint('   Recent files found: $recentCount');
      debugPrint('   Timestamp formats: $timestampFormats');
      debugPrint('   Issues found: ${issues.length}');

      if (issues.isNotEmpty) {
        debugPrint('⚠️ Timestamp Issues:');
        for (final issue in issues) {
          debugPrint('   - $issue');
        }
      }

      debugPrint('📄 Sample Documents:');
      for (final sample in samples.take(5)) {
        debugPrint(
          '   - ${sample['fileName']}: ${sample['timestampType']} (${sample['daysAgo']} days ago)',
        );
      }

      return analysis;
    } catch (e) {
      debugPrint('❌ Timestamp analysis failed: $e');
      return {
        'error': e.toString(),
        'analysisTime': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Compare recent files count between different calculation methods
  Future<Map<String, dynamic>> compareRecentFilesCalculations() async {
    debugPrint('🔍 Comparing recent files calculation methods...');

    try {
      final firestore = _firebaseService.firestore;
      final now = DateTime.now();
      final sevenDaysAgo = now.subtract(const Duration(days: 7));

      // Method 1: Direct Firestore query with DateTime
      final method1Snapshot = await firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .where('uploadedAt', isGreaterThanOrEqualTo: sevenDaysAgo)
          .limit(1000)
          .get();

      // Method 2: Direct Firestore query with Timestamp
      final sevenDaysAgoTimestamp = Timestamp.fromDate(sevenDaysAgo);
      final method2Snapshot = await firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .where('uploadedAt', isGreaterThanOrEqualTo: sevenDaysAgoTimestamp)
          .limit(1000)
          .get();

      // Method 3: Fetch all and filter locally
      final allDocsSnapshot = await firestore
          .collection('document-metadata')
          .where('isActive', isEqualTo: true)
          .limit(1000)
          .get();

      int method3Count = 0;
      for (final doc in allDocsSnapshot.docs) {
        final data = doc.data();
        final uploadedAt = data['uploadedAt'];
        DateTime? parsedDate;

        if (uploadedAt is Timestamp) {
          parsedDate = uploadedAt.toDate();
        } else if (uploadedAt is DateTime) {
          parsedDate = uploadedAt;
        } else if (uploadedAt is String) {
          try {
            parsedDate = DateTime.parse(uploadedAt);
          } catch (e) {
            // Skip invalid dates
          }
        }

        if (parsedDate != null && parsedDate.isAfter(sevenDaysAgo)) {
          method3Count++;
        }
      }

      final comparison = {
        'analysisTime': now.toIso8601String(),
        'cutoffDate': sevenDaysAgo.toIso8601String(),
        'method1_datetime_query': method1Snapshot.docs.length,
        'method2_timestamp_query': method2Snapshot.docs.length,
        'method3_local_filter': method3Count,
        'totalActiveDocuments': allDocsSnapshot.docs.length,
        'consistency': {
          'method1_vs_method2':
              method1Snapshot.docs.length == method2Snapshot.docs.length,
          'method2_vs_method3': method2Snapshot.docs.length == method3Count,
          'all_methods_match':
              method1Snapshot.docs.length == method2Snapshot.docs.length &&
              method2Snapshot.docs.length == method3Count,
        },
      };

      debugPrint('📊 Recent Files Calculation Comparison:');
      debugPrint(
        '   Method 1 (DateTime query): ${method1Snapshot.docs.length}',
      );
      debugPrint(
        '   Method 2 (Timestamp query): ${method2Snapshot.docs.length}',
      );
      debugPrint('   Method 3 (Local filter): $method3Count');
      debugPrint('   Total active documents: ${allDocsSnapshot.docs.length}');
      debugPrint(
        '   All methods match: ${(comparison['consistency'] as Map<String, dynamic>?)?['all_methods_match']}',
      );

      return comparison;
    } catch (e) {
      debugPrint('❌ Recent files comparison failed: $e');
      return {
        'error': e.toString(),
        'analysisTime': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Monitor recent files statistics over time
  Future<void> monitorRecentFilesStatistics() async {
    debugPrint('📊 Starting recent files statistics monitoring...');

    // Run both analysis methods
    final timestampAnalysis = await analyzeTimestampConsistency();
    final calculationComparison = await compareRecentFilesCalculations();

    // Log summary
    debugPrint('🔍 MONITORING SUMMARY:');
    debugPrint(
      '   Timestamp Analysis - Recent Files: ${timestampAnalysis['recentFilesCount']}',
    );
    debugPrint(
      '   Calculation Comparison - Method 2: ${calculationComparison['method2_timestamp_query']}',
    );
    debugPrint(
      '   Methods Consistent: ${calculationComparison['consistency']['all_methods_match']}',
    );

    if (timestampAnalysis['timestampIssues'] != null &&
        (timestampAnalysis['timestampIssues'] as List).isNotEmpty) {
      debugPrint('⚠️ TIMESTAMP ISSUES DETECTED:');
      for (final issue in timestampAnalysis['timestampIssues']) {
        debugPrint('   - $issue');
      }
    }
  }
}
