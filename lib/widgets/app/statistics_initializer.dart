import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/document_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/user_provider.dart';
import '../../services/statistics_sync_service.dart';

/// Widget that initializes the StatisticsSyncService with providers
/// This ensures real-time statistics updates across the app
class StatisticsInitializer extends StatefulWidget {
  final Widget child;

  const StatisticsInitializer({
    super.key,
    required this.child,
  });

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
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      _syncService.initialize(
        documentProvider: documentProvider,
        categoryProvider: categoryProvider,
        userProvider: userProvider,
      );

      _isInitialized = true;
      debugPrint('✅ StatisticsInitializer: Statistics sync service initialized');
    } catch (e) {
      debugPrint('❌ StatisticsInitializer: Failed to initialize statistics sync: $e');
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
