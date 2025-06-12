import 'package:flutter/material.dart';
import '../core/utils/firebase_debug_helper.dart';

/// Widget to display Firebase connection status and diagnostics
class ConnectionStatusWidget extends StatefulWidget {
  final bool showDetails;
  final VoidCallback? onRetry;

  const ConnectionStatusWidget({
    super.key,
    this.showDetails = false,
    this.onRetry,
  });

  @override
  State<ConnectionStatusWidget> createState() => _ConnectionStatusWidgetState();
}

class _ConnectionStatusWidgetState extends State<ConnectionStatusWidget> {
  FirebaseConnectionReport? _report;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    if (mounted) {
      setState(() => _isLoading = true);
    }

    try {
      final report = await FirebaseDebugHelper.instance.runDiagnostics();
      if (mounted) {
        setState(() {
          _report = report;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 12),
              Text('Checking connection status...'),
            ],
          ),
        ),
      );
    }

    if (_report == null) {
      return const SizedBox.shrink();
    }

    return Card(
      color: _getStatusColor(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(_getStatusIcon(), color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getStatusMessage(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (widget.onRetry != null)
                  IconButton(
                    onPressed: () {
                      _runDiagnostics();
                      widget.onRetry?.call();
                    },
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    tooltip: 'Retry connection',
                  ),
              ],
            ),
            if (widget.showDetails) ...[
              const SizedBox(height: 12),
              _buildDetailRow('Network', _report!.networkStatus.status),
              _buildDetailRow('Authentication', _report!.authStatus.name),
              _buildDetailRow('Storage', _report!.storageStatus.name),
              _buildDetailRow('App Check', _report!.appCheckStatus.name),

              // Show recommendations if any
              if (_getRecommendations().isNotEmpty) ...[
                const SizedBox(height: 12),
                const Text(
                  'Recommendations:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                ..._getRecommendations().map(
                  (rec) => Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 2.0),
                    child: Text(
                      '• $rec',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Text(
            status,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (_report == null) return Colors.grey;

    if (_report!.isHealthy) {
      return Colors.green;
    } else if (_report!.networkStatus.hasInternet) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  IconData _getStatusIcon() {
    if (_report == null) return Icons.help_outline;

    if (_report!.isHealthy) {
      return Icons.check_circle;
    } else if (_report!.networkStatus.hasInternet) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  String _getStatusMessage() {
    if (_report == null) return 'Unknown status';

    if (_report!.isHealthy) {
      return 'All services connected';
    } else if (!_report!.networkStatus.hasInternet) {
      return 'No internet connection';
    } else if (!_report!.networkStatus.canReachFirebase) {
      return 'Cannot reach Firebase services';
    } else {
      return 'Some services have issues';
    }
  }

  List<String> _getRecommendations() {
    if (_report == null) return [];

    final recommendations = <String>[];

    if (!_report!.networkStatus.hasInternet) {
      recommendations.add('Check your internet connection');
    }

    if (!_report!.networkStatus.canReachFirebase) {
      recommendations.add('Check firewall/proxy settings');
    }

    if (_report!.storageStatus == ServiceStatus.timeout) {
      recommendations.add('Storage is timing out - check network stability');
    }

    return recommendations;
  }
}
