import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:managementdoc/core/monitoring/performance_monitor.dart';

class PerformanceDashboard extends ConsumerWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Performance Dashboard'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              PerformanceMonitor.clearMetrics();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCards(),
            const SizedBox(height: 24),
            _buildMemoryChart(),
            const SizedBox(height: 24),
            _buildRebuildChart(),
            const SizedBox(height: 24),
            _buildNavigationChart(),
            const SizedBox(height: 24),
            _buildMetricsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            'Memory Usage',
            '78.5 MB',
            Icons.memory,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Avg Rebuild Time',
            '2.3 ms',
            Icons.refresh,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildMetricCard(
            'Navigation Time',
            '145 ms',
            Icons.navigation,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Memory Usage Over Time',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}MB');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}s');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: _generateMemoryData(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRebuildChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Widget Rebuild Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}ms');
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final widgets = ['Home', 'Upload', 'Docs', 'Profile'];
                          if (value.toInt() < widgets.length) {
                            return Text(widgets[value.toInt()]);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                  barGroups: _generateRebuildData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Navigation Performance',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _generateNavigationData(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsList() {
    final report = PerformanceMonitor.getReport();
    
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Performance Metrics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...report.rebuildCounts.entries.map((entry) {
              return ListTile(
                leading: const Icon(Icons.widgets),
                title: Text(entry.key),
                trailing: Text('${entry.value} rebuilds'),
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.timeline),
              title: const Text('Total Metrics'),
              trailing: Text('${report.metrics.length}'),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Report Generated'),
              trailing: Text(
                '${report.generatedAt.hour}:${report.generatedAt.minute.toString().padLeft(2, '0')}',
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> _generateMemoryData() {
    return [
      const FlSpot(0, 45),
      const FlSpot(1, 52),
      const FlSpot(2, 48),
      const FlSpot(3, 65),
      const FlSpot(4, 78),
      const FlSpot(5, 72),
      const FlSpot(6, 69),
    ];
  }

  List<BarChartGroupData> _generateRebuildData() {
    return [
      BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 2.3, color: Colors.green)]),
      BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 4.1, color: Colors.orange)]),
      BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1.8, color: Colors.green)]),
      BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 3.2, color: Colors.orange)]),
    ];
  }

  List<PieChartSectionData> _generateNavigationData() {
    return [
      PieChartSectionData(
        color: Colors.blue,
        value: 40,
        title: 'Home\n40%',
        radius: 60,
      ),
      PieChartSectionData(
        color: Colors.green,
        value: 30,
        title: 'Upload\n30%',
        radius: 60,
      ),
      PieChartSectionData(
        color: Colors.orange,
        value: 20,
        title: 'Docs\n20%',
        radius: 60,
      ),
      PieChartSectionData(
        color: Colors.red,
        value: 10,
        title: 'Profile\n10%',
        radius: 60,
      ),
    ];
  }
}
