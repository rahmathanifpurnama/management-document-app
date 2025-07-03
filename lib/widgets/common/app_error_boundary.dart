import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../../core/error/error_handler.dart';
import '../../core/services/network_service.dart';

/// Error boundary widget that catches and handles errors gracefully
class AppErrorBoundary extends StatefulWidget {
  final Widget child;
  final String? errorTitle;
  final String? errorMessage;

  const AppErrorBoundary({
    super.key,
    required this.child,
    this.errorTitle,
    this.errorMessage,
  });

  @override
  State<AppErrorBoundary> createState() => _AppErrorBoundaryState();
}

class _AppErrorBoundaryState extends State<AppErrorBoundary> {
  Object? _error;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    // Listen for provider errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForProviderErrors();
    });
  }

  void _checkForProviderErrors() {
    // Skip provider error checking for now
    // This will be handled by individual providers
  }

  void _retry() {
    setState(() {
      _error = null;
      _hasError = false;
    });

    // Re-check providers after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkForProviderErrors();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      return AppErrorHandler.handleProviderError(_error!, _retry);
    }

    // Set up global error widget builder
    ErrorWidget.builder = (FlutterErrorDetails details) {
      // In debug mode, show the default error widget
      if (kDebugMode) {
        return ErrorWidget(details.exception);
      }

      // In release mode, show our custom error UI
      return AppErrorHandler.handleFirebaseError(details.exception, _retry);
    };

    return widget.child;
  }
}

/// Provider error boundary specifically for provider initialization
class ProviderErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;

  const ProviderErrorBoundary({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<dynamic>(
      builder: (context, value, child) {
        return this.child;
      },
      child: child,
    );
  }
}

/// Network-aware widget that shows appropriate UI based on connectivity
class NetworkAwareWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(NetworkDiagnostics diagnostics)? offlineBuilder;
  final bool showOfflineIndicator;

  const NetworkAwareWidget({
    super.key,
    required this.child,
    this.offlineBuilder,
    this.showOfflineIndicator = true,
  });

  @override
  State<NetworkAwareWidget> createState() => _NetworkAwareWidgetState();
}

class _NetworkAwareWidgetState extends State<NetworkAwareWidget> {
  NetworkDiagnostics? _diagnostics;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    if (_isChecking) return;

    setState(() {
      _isChecking = true;
    });

    try {
      final diagnostics = await NetworkService.instance.runDiagnostics();
      if (mounted) {
        setState(() {
          _diagnostics = diagnostics;
          _isChecking = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _diagnostics = NetworkDiagnostics(
            hasInternet: false,
            canReachFirebase: false,
            timestamp: DateTime.now(),
          );
          _isChecking = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_diagnostics != null && !_diagnostics!.isHealthy) {
      if (widget.offlineBuilder != null) {
        return widget.offlineBuilder!(_diagnostics!);
      }

      return AppErrorHandler.handleProviderError(
        'Network connectivity issue: ${_diagnostics!.status}',
        _checkConnectivity,
      );
    }

    // Show online indicator if enabled
    if (widget.showOfflineIndicator && _diagnostics != null) {
      return Stack(
        children: [
          widget.child,
          if (!_diagnostics!.isHealthy)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                color: Colors.orange.shade600,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.wifi_off, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      'Limited connectivity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: _checkConnectivity,
                      child: Icon(Icons.refresh, color: Colors.white, size: 16),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    }

    return widget.child;
  }
}

/// Firebase-aware widget that handles Firebase-specific errors
class FirebaseAwareWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;

  const FirebaseAwareWidget({
    super.key,
    required this.child,
    this.errorBuilder,
  });

  @override
  State<FirebaseAwareWidget> createState() => _FirebaseAwareWidgetState();
}

class _FirebaseAwareWidgetState extends State<FirebaseAwareWidget> {
  Object? _error;
  bool _hasError = false;

  void _retry() {
    setState(() {
      _error = null;
      _hasError = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError && _error != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_error!, _retry);
      }

      return AppErrorHandler.handleFirebaseError(_error!, _retry);
    }

    return widget.child;
  }
}
