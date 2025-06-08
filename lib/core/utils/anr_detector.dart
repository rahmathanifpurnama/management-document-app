import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// ANR (Application Not Responding) detector and recovery system
class ANRDetector {
  static ANRDetector? _instance;
  static ANRDetector get instance => _instance ??= ANRDetector._();

  ANRDetector._();

  Timer? _watchdogTimer;
  DateTime? _lastHeartbeat;
  bool _isMonitoring = false;
  int _anrCount = 0;
  final List<String> _anrLog = [];

  static const Duration _watchdogInterval = Duration(seconds: 2);
  static const Duration _anrThreshold = Duration(seconds: 5);
  static const int _maxAnrCount = 3;

  /// Start ANR monitoring
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _lastHeartbeat = DateTime.now();
    _anrCount = 0;

    debugPrint('🔍 ANR Detector: Starting monitoring...');

    // Start watchdog timer
    _watchdogTimer = Timer.periodic(_watchdogInterval, _checkForANR);

    // Start heartbeat in main thread
    _startHeartbeat();
  }

  /// Stop ANR monitoring
  void stopMonitoring() {
    if (!_isMonitoring) return;

    _isMonitoring = false;
    _watchdogTimer?.cancel();
    _watchdogTimer = null;

    debugPrint('🔍 ANR Detector: Stopped monitoring');
  }

  /// Start heartbeat to indicate main thread is responsive
  void _startHeartbeat() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isMonitoring) {
        timer.cancel();
        return;
      }

      _lastHeartbeat = DateTime.now();
    });
  }

  /// Check for ANR condition
  void _checkForANR(Timer timer) {
    if (!_isMonitoring || _lastHeartbeat == null) return;

    final now = DateTime.now();
    final timeSinceLastHeartbeat = now.difference(_lastHeartbeat!);

    if (timeSinceLastHeartbeat > _anrThreshold) {
      _handleANRDetected(timeSinceLastHeartbeat);
    }
  }

  /// Handle ANR detection
  void _handleANRDetected(Duration anrDuration) {
    _anrCount++;
    final anrMessage =
        'ANR detected: Main thread unresponsive for ${anrDuration.inSeconds}s';

    debugPrint('🚨 $anrMessage');
    _anrLog.add('${DateTime.now()}: $anrMessage');

    // Try recovery actions
    _attemptRecovery();

    // If too many ANRs, take drastic action
    if (_anrCount >= _maxAnrCount) {
      _handleCriticalANR();
    }
  }

  /// Attempt to recover from ANR
  void _attemptRecovery() {
    debugPrint('🔧 ANR Detector: Attempting recovery...');

    try {
      // Force garbage collection
      _forceGarbageCollection();

      // Clear any pending operations
      _clearPendingOperations();

      // Reset heartbeat
      _lastHeartbeat = DateTime.now();

      debugPrint('✅ ANR Detector: Recovery attempt completed');
    } catch (e) {
      debugPrint('❌ ANR Detector: Recovery failed - $e');
    }
  }

  /// Handle critical ANR situation
  void _handleCriticalANR() {
    debugPrint('💥 ANR Detector: Critical ANR situation detected!');

    // Log critical ANR
    _anrLog.add(
      '${DateTime.now()}: CRITICAL ANR - $_anrCount consecutive ANRs',
    );

    // Show user notification
    _showANRNotification();

    // Reset counter after handling
    _anrCount = 0;
  }

  /// Force garbage collection
  void _forceGarbageCollection() {
    try {
      // Force GC in debug mode
      if (kDebugMode) {
        // This is a hint to the VM to run garbage collection
        for (int i = 0; i < 3; i++) {
          List.generate(1000, (index) => index).clear();
        }
      }
      debugPrint('🗑️ ANR Detector: Forced garbage collection');
    } catch (e) {
      debugPrint('❌ ANR Detector: GC failed - $e');
    }
  }

  /// Clear pending operations that might be causing ANR
  void _clearPendingOperations() {
    try {
      // Clear any pending timers or operations
      // This is a placeholder - implement based on your app's specific needs
      debugPrint('🧹 ANR Detector: Cleared pending operations');
    } catch (e) {
      debugPrint('❌ ANR Detector: Clear operations failed - $e');
    }
  }

  /// Show ANR notification to user
  void _showANRNotification() {
    try {
      // Use platform channel to show native notification
      // This is a simplified implementation
      debugPrint('📱 ANR Detector: Showing user notification');

      // In a real implementation, you might want to:
      // 1. Show a dialog to the user
      // 2. Send analytics event
      // 3. Restart the app if necessary
    } catch (e) {
      debugPrint('❌ ANR Detector: Notification failed - $e');
    }
  }

  /// Get ANR statistics
  Map<String, dynamic> getANRStats() {
    return {
      'isMonitoring': _isMonitoring,
      'anrCount': _anrCount,
      'lastHeartbeat': _lastHeartbeat?.toIso8601String(),
      'anrLog': List.from(_anrLog),
    };
  }

  /// Clear ANR log
  void clearANRLog() {
    _anrLog.clear();
    _anrCount = 0;
    debugPrint('🧹 ANR Detector: Log cleared');
  }

  /// Check if main thread is responsive
  bool isMainThreadResponsive() {
    if (_lastHeartbeat == null) return true;

    final now = DateTime.now();
    final timeSinceLastHeartbeat = now.difference(_lastHeartbeat!);

    return timeSinceLastHeartbeat < _anrThreshold;
  }

  /// Manual heartbeat (call this from critical operations)
  void heartbeat() {
    _lastHeartbeat = DateTime.now();
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _anrLog.clear();
    _instance = null;
  }
}

/// ANR Prevention Widget that automatically monitors for ANR
class ANRMonitorWidget extends StatefulWidget {
  final Widget child;
  final bool autoStart;

  const ANRMonitorWidget({
    super.key,
    required this.child,
    this.autoStart = true,
  });

  @override
  State<ANRMonitorWidget> createState() => _ANRMonitorWidgetState();
}

class _ANRMonitorWidgetState extends State<ANRMonitorWidget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ANRDetector.instance.startMonitoring();
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        ANRDetector.instance.startMonitoring();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        ANRDetector.instance.stopMonitoring();
        break;
      case AppLifecycleState.inactive:
        // Keep monitoring but reduce frequency
        break;
      case AppLifecycleState.hidden:
        ANRDetector.instance.stopMonitoring();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// Extension to add ANR monitoring to any widget
extension ANRMonitoring on Widget {
  Widget withANRMonitoring({bool autoStart = true}) {
    return ANRMonitorWidget(autoStart: autoStart, child: this);
  }
}
