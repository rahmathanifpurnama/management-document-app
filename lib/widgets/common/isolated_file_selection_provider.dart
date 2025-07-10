import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget that provides an isolated FileSelectionProvider instance for a specific screen
/// This prevents global state conflicts between different screens
///
/// NOTE: This widget is now deprecated in favor of using isolatedFileSelectionProvider
/// directly with Riverpod. It's kept for backward compatibility during migration.
@Deprecated('Use isolatedFileSelectionProvider directly with Riverpod instead')
class IsolatedFileSelectionProvider extends ConsumerWidget {
  final Widget child;
  final String? screenId; // Optional identifier for debugging

  const IsolatedFileSelectionProvider({
    super.key,
    required this.child,
    this.screenId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This widget now just passes through the child since Riverpod
    // handles isolated providers automatically via family providers
    debugPrint(
      'IsolatedFileSelectionProvider: Using Riverpod isolated provider for screen: ${screenId ?? "unknown"}',
    );

    return child;
  }
}

/// Extension to easily wrap screens with isolated file selection provider
///
/// NOTE: This extension is deprecated. Use isolatedFileSelectionProvider
/// directly with Riverpod family providers instead.
@Deprecated('Use isolatedFileSelectionProvider directly with Riverpod instead')
extension ScreenIsolation on Widget {
  /// Wraps the widget with an isolated FileSelectionProvider
  @Deprecated(
    'Use isolatedFileSelectionProvider directly with Riverpod instead',
  )
  Widget withIsolatedFileSelection({String? screenId}) {
    return IsolatedFileSelectionProvider(screenId: screenId, child: this);
  }
}

/// Helper class for migrating from old isolated file selection pattern
///
/// Usage example:
/// ```dart
/// // Old way (deprecated):
/// IsolatedFileSelectionProvider(
///   screenId: 'MyScreen',
///   child: MyWidget(),
/// )
///
/// // New way (recommended):
/// class MyWidget extends ConsumerWidget {
///   @override
///   Widget build(BuildContext context, WidgetRef ref) {
///     final screenId = 'MyScreen';
///     final selectionState = ref.watch(isolatedFileSelectionProvider(screenId));
///     final actions = ref.read(isolatedFileSelectionActionsProvider(screenId));
///     // ... use selectionState and actions
///   }
/// }
/// ```
class IsolatedFileSelectionHelper {
  /// Get the screen ID for a given widget type
  static String getScreenId(Type widgetType) {
    return widgetType.toString();
  }

  /// Documentation for migration patterns
  static const String migrationGuide = '''
Migration from IsolatedFileSelectionProvider to Riverpod:

1. Convert your widget to ConsumerWidget or ConsumerStatefulWidget
2. Use isolatedFileSelectionProvider(screenId) to watch state
3. Use isolatedFileSelectionActionsProvider(screenId) for actions
4. Remove IsolatedFileSelectionProvider wrapper

Example:
// Before:
IsolatedFileSelectionProvider(
  screenId: 'MyScreen',
  child: Consumer<FileSelectionProvider>(
    builder: (context, provider, child) => Text('\${provider.selectedCount}'),
  ),
)

// After:
Consumer(
  builder: (context, ref, child) {
    final count = ref.watch(isolatedFileSelectionProvider('MyScreen')
        .select((state) => state.selectedFileIds.length));
    return Text('\$count');
  },
)
''';
}
