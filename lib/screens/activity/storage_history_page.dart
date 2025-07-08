import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../services/storage_history_service.dart';
import '../../services/export_service.dart';

class StorageHistoryPage extends StatefulWidget {
  const StorageHistoryPage({super.key});

  @override
  State<StorageHistoryPage> createState() => _StorageHistoryPageState();
}

class _StorageHistoryPageState extends State<StorageHistoryPage> {
  final StorageHistoryService _storageHistoryService = StorageHistoryService();
  final ExportService _exportService = ExportService();
  final ScrollController _scrollController = ScrollController();
  
  List<Map<String, dynamic>> _historyRecords = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  Map<String, dynamic> _storageBreakdown = {};
  Map<String, dynamic> _growthRate = {};

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreHistory();
    }
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    try {
      final futures = await Future.wait([
        _storageHistoryService.getDetailedStorageHistory(),
        _storageHistoryService.getStorageBreakdownByType(),
        _storageHistoryService.getStorageGrowthRate(),
      ]);
      
      setState(() {
        _historyRecords = futures[0] as List<Map<String, dynamic>>;
        _storageBreakdown = futures[1] as Map<String, dynamic>;
        _growthRate = futures[2] as Map<String, dynamic>;
      });
    } catch (e) {
      debugPrint('Error loading storage history data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadMoreHistory() async {
    if (_isLoadingMore || !_hasMoreData || _historyRecords.isEmpty) return;

    setState(() => _isLoadingMore = true);

    try {
      final lastDoc = _historyRecords.last['documentSnapshot'] as DocumentSnapshot;
      final moreRecords = await _storageHistoryService.getDetailedStorageHistory(
        startAfter: lastDoc,
      );
      
      setState(() {
        _historyRecords.addAll(moreRecords);
        _hasMoreData = moreRecords.length == 50; // Assuming limit of 50
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      debugPrint('Error loading more history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: _isLoading ? _buildLoadingState() : _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      title: Text(
        'Storage History',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: _exportStorageStats,
          tooltip: 'Export Statistics',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGrowthRateCard(),
            const SizedBox(height: 16),
            _buildStorageBreakdownCard(),
            const SizedBox(height: 16),
            _buildHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthRateCard() {
    if (_growthRate.isEmpty) return const SizedBox.shrink();

    final growthRate = _growthRate['growthRate'] as double? ?? 0;
    final growthAmount = _growthRate['growthAmount'] as double? ?? 0;
    final isPositiveGrowth = growthRate >= 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storage Growth Rate',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildGrowthStatItem(
                  'Monthly Growth',
                  '${growthRate.toStringAsFixed(1)}%',
                  isPositiveGrowth ? Icons.trending_up : Icons.trending_down,
                  isPositiveGrowth ? AppColors.success : AppColors.error,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildGrowthStatItem(
                  'Growth Amount',
                  _formatBytes(growthAmount.abs()),
                  isPositiveGrowth ? Icons.add : Icons.remove,
                  isPositiveGrowth ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStorageBreakdownCard() {
    if (_storageBreakdown.isEmpty) return const SizedBox.shrink();

    final breakdown = _storageBreakdown['breakdown'] as Map<String, dynamic>? ?? {};
    final totalSize = _storageBreakdown['totalSize'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storage Breakdown by File Type',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          if (breakdown.isEmpty)
            const Center(child: Text('No data available'))
          else
            ...breakdown.entries.map((entry) => _buildBreakdownItem(
              entry.key,
              entry.value['totalSize'] as int,
              entry.value['count'] as int,
              entry.value['percentage'] as double,
              totalSize,
            )),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(String type, int size, int count, double percentage, int totalSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                type,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_formatBytes(size.toDouble())} (${percentage.toStringAsFixed(1)}%)',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count files',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'Avg: ${_formatBytes((size / count).toDouble())}',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Storage History Records',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (_historyRecords.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('No history records found')),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _historyRecords.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.withOpacity(0.2),
              ),
              itemBuilder: (context, index) {
                if (index == _historyRecords.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                
                final record = _historyRecords[index];
                return _buildHistoryItem(record);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> record) {
    final timestamp = (record['timestamp'] as Timestamp).toDate();
    final totalBytes = (record['totalBytes'] as num?)?.toInt() ?? 0;
    final fileCount = (record['fileCount'] as num?)?.toInt() ?? 0;
    final userCount = (record['userCount'] as num?)?.toInt() ?? 0;
    final averageFileSize = (record['averageFileSize'] as num?)?.toDouble() ?? 0;

    return ListTile(
      contentPadding: const EdgeInsets.all(16),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.storage,
          color: AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        _formatDateTime(timestamp),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(
            'Total: ${_formatBytes(totalBytes.toDouble())} • $fileCount files • $userCount users',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            'Avg file size: ${_formatBytes(averageFileSize)}',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportStorageStats() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Exporting storage statistics...')),
      );
      
      final stats = {
        'Total Storage': _formatBytes((_storageBreakdown['totalSize'] as int? ?? 0).toDouble()),
        'Total Files': (_storageBreakdown['totalFiles'] as int? ?? 0).toString(),
        'Growth Rate': '${(_growthRate['growthRate'] as double? ?? 0).toStringAsFixed(1)}%',
        'Growth Amount': _formatBytes((_growthRate['growthAmount'] as double? ?? 0).abs()),
        'History Records': _historyRecords.length.toString(),
        'Export Date': _formatDateTime(DateTime.now()),
      };
      
      await _exportService.exportStorageStatsToExcel(stats);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage statistics exported successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Export failed: $e')),
      );
    }
  }

  String _formatBytes(double bytes) {
    if (bytes < 1024) return '${bytes.toInt()} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
