import 'package:flutter/material.dart';
import '../../services/statistics_sync_service.dart';

/// Widget that initializes the StatisticsSyncService
/// This ensures real-time statistics updates across the app
class StatisticsInitializer extends StatefulWidget {
  final Widget child;

  const StatisticsInitializer({super.key, required this.child});

  @override
  State<StatisticsInitializer> createState() => _StatisticsInitializerState();
}

class _StatisticsInitializerState extends State<StatisticsInitializer> {
  final StatisticsSyncService _syncService = StatisticsSyncService.instance;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeStatisticsSync();
  }

  void _initializeStatisticsSync() {
    if (_isInitialized) return;

    try {
      _syncService.initialize();

      _isInitialized = true;
      debugPrint(
        '✅ StatisticsInitializer: Statistics sync service initialized',
      );
    } catch (e) {
      debugPrint(
        '❌ StatisticsInitializer: Failed to initialize statistics sync: $e',
      );
    }
  }

  @override
  void dispose() {
    _syncService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
