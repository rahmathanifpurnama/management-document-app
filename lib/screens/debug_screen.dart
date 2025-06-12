import 'package:flutter/material.dart';
import '../widgets/connection_status_widget.dart';
import '../widgets/debug/debug_token_widget.dart';
import '../widgets/debug/app_check_error_widget.dart';
import '../core/utils/firebase_debug_helper.dart';

/// Debug screen to test Firebase connectivity
class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  final GlobalKey _connectionKey = GlobalKey();
  FirebaseConnectionReport? _lastReport;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Debug'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Firebase Connection Status',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ConnectionStatusWidget(
              key: _connectionKey,
              showDetails: true,
              onRetry: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Retrying connection...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _runFullDiagnostics,
              icon: const Icon(Icons.bug_report),
              label: const Text('Run Full Diagnostics'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            const DebugTokenWidget(),
            const SizedBox(height: 16),

            // Show App Check error widget if there's an error
            if (_lastReport?.appCheckStatus == ServiceStatus.error)
              AppCheckErrorWidget(
                errorMessage: 'Too many attempts',
                onRetry: () {
                  setState(() {
                    _lastReport = null;
                  });
                  _runFullDiagnostics();
                },
              ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Troubleshooting Tips:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('1. Check your internet connection'),
                    Text('2. Verify Firebase project configuration'),
                    Text(
                      '3. Debug token is pre-configured: 0D5038C4-B4F2-4628-8AD4-D500B904BA04',
                    ),
                    Text('4. Ensure firewall allows Firebase domains'),
                    Text('5. Try restarting the app'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runFullDiagnostics() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Running diagnostics...'),
          ],
        ),
      ),
    );

    try {
      final report = await FirebaseDebugHelper.instance.runDiagnostics();

      if (mounted) {
        setState(() {
          _lastReport = report;
        });

        Navigator.of(context).pop(); // Close loading dialog

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Diagnostics Complete'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Network: ${report.networkStatus.status}'),
                Text('Auth: ${report.authStatus.name}'),
                Text('Storage: ${report.storageStatus.name}'),
                Text('App Check: ${report.appCheckStatus.name}'),
                const SizedBox(height: 16),
                Text(
                  report.isHealthy
                      ? 'All services are healthy!'
                      : 'Some issues detected.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: report.isHealthy ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Diagnostics failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
