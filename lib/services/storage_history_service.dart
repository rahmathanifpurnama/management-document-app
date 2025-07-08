import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StorageHistoryService {
  static final StorageHistoryService _instance = StorageHistoryService._internal();
  factory StorageHistoryService() => _instance;
  StorageHistoryService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get storage history data for chart
  Future<List<FlSpot>> getStorageHistory(String period) async {
    try {
      final now = DateTime.now();
      DateTime startDate;
      
      switch (period) {
        case 'day':
          startDate = now.subtract(const Duration(days: 1));
          break;
        case 'week':
          startDate = now.subtract(const Duration(days: 7));
          break;
        case 'month':
          startDate = now.subtract(const Duration(days: 30));
          break;
        case 'year':
          startDate = now.subtract(const Duration(days: 365));
          break;
        default:
          startDate = now.subtract(const Duration(days: 7));
      }
      
      final query = await _firestore
          .collection('storage_history')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('timestamp')
          .get();
      
      final spots = <FlSpot>[];
      
      if (query.docs.isEmpty) {
        // Generate sample data if no history exists
        return _generateSampleData(period, startDate, now);
      }
      
      for (final doc in query.docs) {
        final data = doc.data();
        final timestamp = (data['timestamp'] as Timestamp).toDate();
        final totalBytes = (data['totalBytes'] as num?)?.toDouble() ?? 0;
        
        spots.add(FlSpot(
          timestamp.millisecondsSinceEpoch.toDouble(),
          totalBytes,
        ));
      }
      
      return spots;
    } catch (e) {
      debugPrint('Error getting storage history: $e');
      return _generateSampleData(period, DateTime.now().subtract(const Duration(days: 7)), DateTime.now());
    }
  }

  /// Get current storage statistics
  Future<Map<String, dynamic>> getCurrentStorageStats() async {
    try {
      // Get total storage from all documents
      final documentsQuery = await _firestore.collection('documents').get();
      
      int totalBytes = 0;
      int fileCount = 0;
      final fileSizes = <int>[];
      
      for (final doc in documentsQuery.docs) {
        final data = doc.data();
        final fileSize = (data['fileSize'] as num?)?.toInt() ?? 0;
        totalBytes += fileSize;
        fileCount++;
        fileSizes.add(fileSize);
      }
      
      final averageFileSize = fileCount > 0 ? totalBytes / fileCount : 0;
      
      // Get user count
      final usersQuery = await _firestore.collection('users').get();
      final userCount = usersQuery.docs.length;
      
      return {
        'totalBytes': totalBytes,
        'fileCount': fileCount,
        'userCount': userCount,
        'averageFileSize': averageFileSize,
        'lastUpdated': DateTime.now(),
      };
    } catch (e) {
      debugPrint('Error getting current storage stats: $e');
      return {
        'totalBytes': 0,
        'fileCount': 0,
        'userCount': 0,
        'averageFileSize': 0,
        'lastUpdated': DateTime.now(),
      };
    }
  }

  /// Record storage snapshot (would be called by scheduled function)
  Future<void> recordStorageSnapshot() async {
    try {
      final stats = await getCurrentStorageStats();
      
      await _firestore.collection('storage_history').add({
        'timestamp': FieldValue.serverTimestamp(),
        'totalBytes': stats['totalBytes'],
        'fileCount': stats['fileCount'],
        'userCount': stats['userCount'],
        'averageFileSize': stats['averageFileSize'],
      });
      
      debugPrint('Storage snapshot recorded successfully');
    } catch (e) {
      debugPrint('Error recording storage snapshot: $e');
    }
  }

  /// Get detailed storage history for the history page
  Future<List<Map<String, dynamic>>> getDetailedStorageHistory({
    int limit = 50,
    DocumentSnapshot? startAfter,
  }) async {
    try {
      Query query = _firestore
          .collection('storage_history')
          .orderBy('timestamp', descending: true)
          .limit(limit);
      
      if (startAfter != null) {
        query = query.startAfterDocument(startAfter);
      }
      
      final querySnapshot = await query.get();
      final history = <Map<String, dynamic>>[];
      
      for (final doc in querySnapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        data['documentSnapshot'] = doc;
        history.add(data);
      }
      
      return history;
    } catch (e) {
      debugPrint('Error getting detailed storage history: $e');
      return [];
    }
  }

  /// Get storage breakdown by file type
  Future<Map<String, dynamic>> getStorageBreakdownByType() async {
    try {
      final documentsQuery = await _firestore.collection('documents').get();
      
      final typeBreakdown = <String, Map<String, dynamic>>{};
      
      for (final doc in documentsQuery.docs) {
        final data = doc.data();
        final fileType = data['fileType'] as String? ?? 'Unknown';
        final fileSize = (data['fileSize'] as num?)?.toInt() ?? 0;
        
        if (typeBreakdown.containsKey(fileType)) {
          typeBreakdown[fileType]!['count'] += 1;
          typeBreakdown[fileType]!['totalSize'] += fileSize;
        } else {
          typeBreakdown[fileType] = {
            'count': 1,
            'totalSize': fileSize,
          };
        }
      }
      
      // Calculate percentages
      final totalSize = typeBreakdown.values
          .fold<int>(0, (sum, item) => sum + (item['totalSize'] as int));
      
      for (final entry in typeBreakdown.entries) {
        final size = entry.value['totalSize'] as int;
        entry.value['percentage'] = totalSize > 0 ? (size / totalSize) * 100 : 0;
      }
      
      return {
        'breakdown': typeBreakdown,
        'totalSize': totalSize,
        'totalFiles': typeBreakdown.values
            .fold<int>(0, (sum, item) => sum + (item['count'] as int)),
      };
    } catch (e) {
      debugPrint('Error getting storage breakdown by type: $e');
      return {
        'breakdown': <String, Map<String, dynamic>>{},
        'totalSize': 0,
        'totalFiles': 0,
      };
    }
  }

  /// Get storage breakdown by category
  Future<Map<String, dynamic>> getStorageBreakdownByCategory() async {
    try {
      final documentsQuery = await _firestore.collection('documents').get();
      
      final categoryBreakdown = <String, Map<String, dynamic>>{};
      
      for (final doc in documentsQuery.docs) {
        final data = doc.data();
        final categoryName = data['categoryName'] as String? ?? 'Uncategorized';
        final fileSize = (data['fileSize'] as num?)?.toInt() ?? 0;
        
        if (categoryBreakdown.containsKey(categoryName)) {
          categoryBreakdown[categoryName]!['count'] += 1;
          categoryBreakdown[categoryName]!['totalSize'] += fileSize;
        } else {
          categoryBreakdown[categoryName] = {
            'count': 1,
            'totalSize': fileSize,
          };
        }
      }
      
      // Calculate percentages
      final totalSize = categoryBreakdown.values
          .fold<int>(0, (sum, item) => sum + (item['totalSize'] as int));
      
      for (final entry in categoryBreakdown.entries) {
        final size = entry.value['totalSize'] as int;
        entry.value['percentage'] = totalSize > 0 ? (size / totalSize) * 100 : 0;
      }
      
      return {
        'breakdown': categoryBreakdown,
        'totalSize': totalSize,
        'totalFiles': categoryBreakdown.values
            .fold<int>(0, (sum, item) => sum + (item['count'] as int)),
      };
    } catch (e) {
      debugPrint('Error getting storage breakdown by category: $e');
      return {
        'breakdown': <String, Map<String, dynamic>>{},
        'totalSize': 0,
        'totalFiles': 0,
      };
    }
  }

  /// Get storage growth rate
  Future<Map<String, dynamic>> getStorageGrowthRate() async {
    try {
      final now = DateTime.now();
      final lastMonth = now.subtract(const Duration(days: 30));
      final twoMonthsAgo = now.subtract(const Duration(days: 60));
      
      // Get current month data
      final currentMonthQuery = await _firestore
          .collection('storage_history')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(lastMonth))
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      
      // Get previous month data
      final previousMonthQuery = await _firestore
          .collection('storage_history')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(twoMonthsAgo))
          .where('timestamp', isLessThan: Timestamp.fromDate(lastMonth))
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();
      
      double currentSize = 0;
      double previousSize = 0;
      
      if (currentMonthQuery.docs.isNotEmpty) {
        currentSize = (currentMonthQuery.docs.first.data()['totalBytes'] as num?)?.toDouble() ?? 0;
      }
      
      if (previousMonthQuery.docs.isNotEmpty) {
        previousSize = (previousMonthQuery.docs.first.data()['totalBytes'] as num?)?.toDouble() ?? 0;
      }
      
      double growthRate = 0;
      if (previousSize > 0) {
        growthRate = ((currentSize - previousSize) / previousSize) * 100;
      }
      
      return {
        'currentSize': currentSize,
        'previousSize': previousSize,
        'growthRate': growthRate,
        'growthAmount': currentSize - previousSize,
      };
    } catch (e) {
      debugPrint('Error getting storage growth rate: $e');
      return {
        'currentSize': 0,
        'previousSize': 0,
        'growthRate': 0,
        'growthAmount': 0,
      };
    }
  }

  /// Clean up old storage history records
  Future<void> cleanupOldHistory({int daysToKeep = 365}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysToKeep));
      
      final oldRecords = await _firestore
          .collection('storage_history')
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();
      
      final batch = _firestore.batch();
      for (final doc in oldRecords.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
      
      debugPrint('Cleaned up ${oldRecords.docs.length} old storage history records');
    } catch (e) {
      debugPrint('Error cleaning up old storage history: $e');
    }
  }

  /// Generate sample data for demonstration
  List<FlSpot> _generateSampleData(String period, DateTime startDate, DateTime endDate) {
    final spots = <FlSpot>[];
    final duration = endDate.difference(startDate);
    
    int dataPoints;
    switch (period) {
      case 'day':
        dataPoints = 24; // Hourly data
        break;
      case 'week':
        dataPoints = 7; // Daily data
        break;
      case 'month':
        dataPoints = 30; // Daily data
        break;
      case 'year':
        dataPoints = 12; // Monthly data
        break;
      default:
        dataPoints = 7;
    }
    
    final interval = duration.inMilliseconds / dataPoints;
    double baseSize = 1024 * 1024 * 100; // 100 MB base
    
    for (int i = 0; i <= dataPoints; i++) {
      final timestamp = startDate.add(Duration(milliseconds: (interval * i).round()));
      final growth = i * (1024 * 1024 * 5); // 5 MB growth per point
      final randomVariation = (i % 3) * (1024 * 1024 * 2); // Some variation
      
      spots.add(FlSpot(
        timestamp.millisecondsSinceEpoch.toDouble(),
        baseSize + growth + randomVariation,
      ));
    }
    
    return spots;
  }
}
