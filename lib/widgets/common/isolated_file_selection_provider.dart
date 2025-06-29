import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/file_selection_provider.dart';

/// Widget that provides an isolated FileSelectionProvider instance for a specific screen
/// This prevents global state conflicts between different screens
class IsolatedFileSelectionProvider extends StatefulWidget {
  final Widget child;
  final String? screenId; // Optional identifier for debugging

  const IsolatedFileSelectionProvider({
    super.key,
    required this.child,
    this.screenId,
  });

  @override
  State<IsolatedFileSelectionProvider> createState() =>
      _IsolatedFileSelectionProviderState();
}

class _IsolatedFileSelectionProviderState
    extends State<IsolatedFileSelectionProvider> {
  late FileSelectionProvider _localProvider;

  @override
  void initState() {
    super.initState();
    _localProvider = FileSelectionProvider();
    debugPrint(
      'IsolatedFileSelectionProvider: Created local provider for screen: ${widget.screenId ?? "unknown"}',
    );
  }

  @override
  void dispose() {
    debugPrint(
      'IsolatedFileSelectionProvider: Disposing local provider for screen: ${widget.screenId ?? "unknown"}',
    );
    _localProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FileSelectionProvider>.value(
      value: _localProvider,
      child: widget.child,
    );
  }
}

/// Extension to easily wrap screens with isolated file selection provider
extension ScreenIsolation on Widget {
  /// Wraps the widget with an isolated FileSelectionProvider
  Widget withIsolatedFileSelection({String? screenId}) {
    return IsolatedFileSelectionProvider(
      screenId: screenId,
      child: this,
    );
  }
}

/// Mixin for screens that need isolated file selection
mixin IsolatedFileSelectionMixin<T extends StatefulWidget> on State<T> {
  late FileSelectionProvider _isolatedProvider;

  @override
  void initState() {
    super.initState();
    _isolatedProvider = FileSelectionProvider();
    debugPrint(
      'IsolatedFileSelectionMixin: Created isolated provider for ${T.toString()}',
    );
  }

  @override
  void dispose() {
    debugPrint(
      'IsolatedFileSelectionMixin: Disposing isolated provider for ${T.toString()}',
    );
    _isolatedProvider.dispose();
    super.dispose();
  }

  /// Get the isolated file selection provider
  FileSelectionProvider get isolatedFileSelectionProvider => _isolatedProvider;

  /// Wrap a widget with the isolated provider
  Widget wrapWithIsolatedProvider(Widget child) {
    return ChangeNotifierProvider<FileSelectionProvider>.value(
      value: _isolatedProvider,
      child: child,
    );
  }
}
