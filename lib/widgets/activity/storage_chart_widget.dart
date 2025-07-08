import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../services/storage_history_service.dart';
import '../common/app_container.dart';

class StorageChartWidget extends StatefulWidget {
  final VoidCallback? onNavigateToHistory;
  final bool showHeader;
  final bool showPeriodSelector;
  final bool showStorageStats;
  final double? height;

  const StorageChartWidget({
    super.key,
    this.onNavigateToHistory,
    this.showHeader = true,
    this.showPeriodSelector = true,
    this.showStorageStats = true,
    this.height,
  });

  @override
  State<StorageChartWidget> createState() => _StorageChartWidgetState();
}

class _StorageChartWidgetState extends State<StorageChartWidget> {
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

  @override
  void dispose() {
    // Cancel any ongoing operations if needed
    super.dispose();
  }

  Future<void> _loadChartData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final data = await _storageHistoryService.getStorageHistory(
        _selectedPeriod,
      );
      final stats = await _storageHistoryService.getCurrentStorageStats();

      if (mounted) {
        setState(() {
          _chartData = data;
          _currentStats = stats;
        });
      }
    } catch (e) {
      debugPrint('Error loading chart data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showHeader) _buildHeader(),
          if (widget.showHeader) const SizedBox(height: 16),
          if (widget.showPeriodSelector) _buildPeriodSelector(),
          if (widget.showPeriodSelector) const SizedBox(height: 16),
          _buildChart(),
          if (widget.showStorageStats) const SizedBox(height: 16),
          if (widget.showStorageStats) _buildStorageStats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Storage Usage',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        if (widget.onNavigateToHistory != null)
          TextButton.icon(
            onPressed: widget.onNavigateToHistory,
            icon: const Icon(Icons.history, size: 16),
            label: const Text('View History'),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              textStyle: GoogleFonts.poppins(fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _periodLabels.entries.map((entry) {
          final isSelected = _selectedPeriod == entry.key;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(entry.value),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedPeriod = entry.key);
                  _loadChartData();
                }
              },
              backgroundColor: AppColors.background,
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              checkmarkColor: AppColors.primary,
              labelStyle: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildChart() {
    if (_isLoading) {
      return SizedBox(
        height: widget.height ?? 200,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_chartData.isEmpty) {
      return SizedBox(
        height: widget.height ?? 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.storage,
                size: 48,
                color: AppColors.textSecondary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 8),
              Text(
                'No storage data available',
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SizedBox(
      height: widget.height ?? 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _getHorizontalInterval(),
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.border.withValues(alpha: 0.5),
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
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
                      style: GoogleFonts.poppins(
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
                reservedSize: 50,
                interval: _getHorizontalInterval(),
                getTitlesWidget: (value, meta) {
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _formatBytes(value),
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: _chartData.first.x,
          maxX: _chartData.last.x,
          minY: 0,
          maxY: _getMaxY(),
          lineBarsData: [
            LineChartBarData(
              spots: _chartData,
              isCurved: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.8),
                  AppColors.primary,
                ],
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
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
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
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Total Files',
            _currentStats['fileCount']?.toString() ?? '0',
            Icons.folder,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem(
            'Avg Size',
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
    return AppContainer.info(
      padding: const EdgeInsets.all(12),
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
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
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

  String _formatBytes(double bytes) {
    if (bytes < 1024) return '${bytes.toInt()}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }
}
