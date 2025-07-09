import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/firebase_initialization_status.dart';

/// Safe provider wrapper that prevents Firebase-dependent providers from
/// initializing when Firebase is not ready, preventing red error screens
class SafeProviderWrapper<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() create;
  final Widget child;
  final bool requiresFirebase;
  final bool lazy;

  const SafeProviderWrapper({
    super.key,
    required this.create,
    required this.child,
    this.requiresFirebase = true,
    this.lazy = false,
  });

  @override
  State<SafeProviderWrapper<T>> createState() => _SafeProviderWrapperState<T>();
}

class _SafeProviderWrapperState<T extends ChangeNotifier>
    extends State<SafeProviderWrapper<T>> {
  T? _provider;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    if (!widget.lazy) {
      _initializeProvider();
    }
  }

  void _initializeProvider() {
    try {
      // Check if Firebase is required and available
      if (widget.requiresFirebase && !FirebaseInitializationStatus.canInitializeProviders) {
        setState(() {
          _hasError = true;
          _errorMessage = FirebaseInitializationStatus.statusMessage;
        });
        return;
      }

      // Create the provider
      _provider = widget.create();
      setState(() {
        _hasError = false;
        _errorMessage = null;
      });
    } catch (e) {
      debugPrint('🚨 SafeProviderWrapper: Provider creation failed: $e');
      setState(() {
        _hasError = true;
        _errorMessage = _getErrorMessage(e.toString());
      });
    }
  }

  String _getErrorMessage(String error) {
    if (error.toLowerCase().contains('firebase') && 
        error.toLowerCase().contains('no-app')) {
      return 'Services are initializing...';
    } else if (error.toLowerCase().contains('network') ||
               error.toLowerCase().contains('connection')) {
      return 'No internet connection';
    } else if (error.toLowerCase().contains('firebase')) {
      return 'Unable to connect to services';
    } else {
      return 'Service initialization failed';
    }
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _errorMessage = null;
    });
    _initializeProvider();
  }

  @override
  Widget build(BuildContext context) {
    // If provider is not created yet and lazy loading is enabled
    if (_provider == null && widget.lazy) {
      _initializeProvider();
    }

    // If there's an error, show error UI instead of crashing
    if (_hasError) {
      return _buildErrorUI(context);
    }

    // If provider is not ready yet, show loading
    if (_provider == null) {
      return _buildLoadingUI(context);
    }

    // Provider is ready, wrap it normally
    return ChangeNotifierProvider<T>.value(
      value: _provider!,
      child: widget.child,
    );
  }

  Widget _buildErrorUI(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.cloud_off,
                  size: 64,
                  color: Colors.orange,
                ),
                const SizedBox(height: 24),
                Text(
                  'Service Unavailable',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage ?? 'Unable to initialize services',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _retry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to login screen or show offline mode
                    Navigator.of(context).pushReplacementNamed('/login');
                  },
                  child: const Text(
                    'Continue Offline',
                    style: TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingUI(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.orange,
              ),
              const SizedBox(height: 24),
              Text(
                'Initializing Services...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                FirebaseInitializationStatus.statusMessage,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _provider?.dispose();
    super.dispose();
  }
}
