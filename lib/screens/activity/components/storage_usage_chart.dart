import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../services/storage_history_service.dart';

class StorageUsageChart extends StatefulWidget {
  final VoidCallback? onNavigateToHistory;

  const StorageUsageChart({super.key, this.onNavigateToHistory});

  @override
  State<StorageUsageChart> createState() => _StorageUsageChartState();
}

class _StorageUsageChartState extends State<StorageUsageChart> {
  final StorageHistoryService _storageHistoryService = StorageHistoryService();

  String _selectedPeriod = 'week'; // 'day', 'week', 'month', 'year'
  List<FlSpot> _chartData = [];
  bool _isLoading = false;
  Map<String, dynamic> _currentStats = {};

  final Map<String, String> _periodLabels = {
    'day': 'Last 24 Hours',
    'week': 'Last 7 Days',
    'month': 'Last 30 Days',
    'year': 'Last 12 Months',
  };

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    setState(() => _isLoading = true);

    try {
      final data = await _storageHistoryService.getStorageHistory(
        _selectedPeriod,
      );
      final stats = await _storageHistoryService.getCurrentStorageStats();

      setState(() {
        _chartData = data;
        _currentStats = stats;
      });
    } catch (e) {
      debugPrint('Error loading chart data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
          _buildHeader(),
          const SizedBox(height: 16),
          _buildPeriodSelector(),
          const SizedBox(height: 16),
          _buildChart(),
          const SizedBox(height: 16),
          _buildStorageStats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Storage Usage Trend',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        Row(
          children: [
            if (widget.onNavigateToHistory != null)
              TextButton.icon(
                onPressed: widget.onNavigateToHistory,
                icon: const Icon(Icons.history, size: 16),
                label: const Text('View History'),
                style: TextButton.styleFrom(foregroundColor: AppColors.primary),
              ),
            IconButton(
              onPressed: _loadChartData,
              icon: const Icon(Icons.refresh, size: 20),
              tooltip: 'Refresh',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.1),
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Row(
      children: _periodLabels.entries.map((entry) {
        final isSelected = _selectedPeriod == entry.key;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ChoiceChip(
            label: Text(
              entry.value,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              if (selected) {
                setState(() => _selectedPeriod = entry.key);
                _loadChartData();
              }
            },
            backgroundColor: Colors.grey.withOpacity(0.1),
            selectedColor: AppColors.primary,
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.withOpacity(0.3),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildChart() {
    if (_isLoading) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_chartData.isEmpty) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.storage,
                size: 48,
                color: AppColors.textSecondary.withOpacity(0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No storage data available',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getHorizontalInterval(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: _getBottomInterval(),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _getBottomTitle(value),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: _getHorizontalInterval(),
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _formatBytes(value),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.withOpacity(0.2)),
          ),
          minX: _chartData.first.x,
          maxX: _chartData.last.x,
          minY: 0,
          maxY: _getMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _chartData,
              isCurved: true,
              gradient: LinearGradient(
                colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
              ),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 4,
                    color: AppColors.primary,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.primary.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            enabled: true,
            touchTooltipData: LineTouchTooltipData(
              getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                return touchedBarSpots.map((barSpot) {
                  return LineTooltipItem(
                    '${_formatBytes(barSpot.y)}\n${_getTooltipDate(barSpot.x)}',
                    const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStorageStats() {
    if (_currentStats.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Total Storage',
            _formatBytes(_currentStats['totalBytes']?.toDouble() ?? 0),
            Icons.storage,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(
            'Total Files',
            _currentStats['fileCount']?.toString() ?? '0',
            Icons.folder,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatItem(
            'Avg File Size',
            _formatBytes(_currentStats['averageFileSize']?.toDouble() ?? 0),
            Icons.insert_drive_file,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    if (_chartData.isEmpty) return 100;
    final maxValue = _chartData
        .map((spot) => spot.y)
        .reduce((a, b) => a > b ? a : b);
    return maxValue * 1.1; // Add 10% padding
  }

  double _getHorizontalInterval() {
    final maxY = _getMaxY();
    return maxY / 5; // 5 horizontal lines
  }

  double _getBottomInterval() {
    if (_chartData.isEmpty) return 1;
    final range = _chartData.last.x - _chartData.first.x;
    return range / 5; // 5 vertical labels
  }

  String _getBottomTitle(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());

    switch (_selectedPeriod) {
      case 'day':
        return '${date.hour}:00';
      case 'week':
        return '${date.day}/${date.month}';
      case 'month':
        return '${date.day}/${date.month}';
      case 'year':
        return '${date.month}/${date.year}';
      default:
        return '${date.day}/${date.month}';
    }
  }

  String _getTooltipDate(double value) {
    final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatBytes(double bytes) {
    if (bytes < 1024) return '${bytes.toInt()} B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
