import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/documents/bloc/document_bloc.dart';
import '../features/documents/bloc/document_event.dart';
import '../features/category/bloc/category_bloc.dart';
import '../features/category/bloc/category_event.dart' as category_events;

/// Service untuk menangani refresh UI secara global setelah upload
class UIRefreshService {
  static UIRefreshService? _instance;
  static UIRefreshService get instance => _instance ??= UIRefreshService._();

  UIRefreshService._();

  /// Trigger comprehensive UI refresh across all relevant BLoCs
  static Future<void> refreshAllProviders(BuildContext context) async {
    try {
      debugPrint('🔄 Starting comprehensive UI refresh...');

      // Refresh DocumentBloc
      context.read<DocumentBloc>().add(const DocumentEvent.refreshDocuments());
      debugPrint('✅ Document BLoC refreshed');

      // Refresh CategoryBloc
      context.read<CategoryBloc>().add(
        const category_events.CategoryEvent.loadCategories(),
      );
      debugPrint('✅ Category BLoC refreshed');

      debugPrint('🎉 Comprehensive UI refresh completed successfully');
    } catch (e) {
      debugPrint('❌ Error during UI refresh: $e');
    }
  }

  /// Trigger refresh with multiple attempts for reliability
  static Future<void> refreshWithRetry(
    BuildContext context, {
    int maxRetries = 3,
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        await refreshAllProviders(context);
        break; // Success, exit retry loop
      } catch (e) {
        debugPrint('⚠️ Refresh attempt ${i + 1} failed: $e');
        if (i == maxRetries - 1) {
          debugPrint('❌ All refresh attempts failed');
        } else {
          // Wait before retry
          await Future.delayed(Duration(milliseconds: 500 * (i + 1)));
        }
      }
    }
  }

  /// Schedule delayed refresh (useful for ensuring UI updates after navigation)
  static void scheduleDelayedRefresh(
    BuildContext context, {
    Duration delay = const Duration(milliseconds: 500),
  }) {
    Timer(delay, () {
      if (context.mounted) {
        refreshAllProviders(context);
      }
    });
  }

  /// Refresh specific to upload completion
  static Future<void> refreshAfterUpload(
    BuildContext context, {
    String? categoryId,
  }) async {
    try {
      debugPrint('🔄 Refreshing UI after upload completion...');

      // Immediate refresh
      await refreshAllProviders(context);

      // If uploaded to specific category, ensure category view is updated
      if (categoryId != null && context.mounted) {
        debugPrint('📁 Refreshing category-specific views for: $categoryId');
        // Refresh documents for the specific category
        context.read<DocumentBloc>().add(
          DocumentEvent.loadDocumentsByCategory(category: categoryId),
        );
      }

      // Schedule additional refresh to ensure persistence
      if (context.mounted) {
        scheduleDelayedRefresh(
          context,
          delay: const Duration(milliseconds: 1000),
        );
      }

      debugPrint('✅ Upload-specific refresh completed');
    } catch (e) {
      debugPrint('❌ Error refreshing after upload: $e');
    }
  }

  /// Refresh when navigating away from upload screen
  static Future<void> refreshOnNavigationExit(BuildContext context) async {
    try {
      debugPrint('🔄 Refreshing UI on navigation exit...');

      // Immediate refresh
      await refreshAllProviders(context);

      // Schedule delayed refresh for when user returns to other screens
      if (context.mounted) {
        scheduleDelayedRefresh(
          context,
          delay: const Duration(milliseconds: 300),
        );
      }

      debugPrint('✅ Navigation exit refresh completed');
    } catch (e) {
      debugPrint('❌ Error refreshing on navigation exit: $e');
    }
  }
}
