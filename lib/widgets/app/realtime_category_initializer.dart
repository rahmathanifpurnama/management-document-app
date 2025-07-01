import 'package:flutter/material.dart';
import '../../services/realtime_category_sync_service.dart';

/// Widget untuk initialize real-time category sync service
class RealtimeCategoryInitializer extends StatefulWidget {
  final Widget child;

  const RealtimeCategoryInitializer({
    super.key,
    required this.child,
  });

  @override
  State<RealtimeCategoryInitializer> createState() =>
      _RealtimeCategoryInitializerState();
}

class _RealtimeCategoryInitializerState
    extends State<RealtimeCategoryInitializer> {
  @override
  void initState() {
    super.initState();
    _initializeRealtimeCategorySync();
  }

  void _initializeRealtimeCategorySync() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final realtimeCategorySync = RealtimeCategorySyncService.instance;
        realtimeCategorySync.initialize(context);
        realtimeCategorySync.startCategorySync();
        
        debugPrint('✅ Real-time category sync initialized successfully');
      } catch (e) {
        debugPrint('❌ Failed to initialize real-time category sync: $e');
      }
    });
  }

  @override
  void dispose() {
    try {
      final realtimeCategorySync = RealtimeCategorySyncService.instance;
      realtimeCategorySync.dispose();
      debugPrint('🗑️ Real-time category sync disposed');
    } catch (e) {
      debugPrint('❌ Error disposing real-time category sync: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
