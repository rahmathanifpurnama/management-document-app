import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';

/// Offline error log viewer widget
class OfflineErrorLog extends StatefulWidget {
  final List<String> errorLogs;
  final VoidCallback? onRetry;
  final VoidCallback? onClose;

  const OfflineErrorLog({
    super.key,
    required this.errorLogs,
    this.onRetry,
    this.onClose,
  });

  @override
  State<OfflineErrorLog> createState() => _OfflineErrorLogState();
}

class _OfflineErrorLogState extends State<OfflineErrorLog> {
  final ScrollController _scrollController = ScrollController();
  bool _showFullLog = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade600,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Application Error Log',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: widget.onClose,
                  icon: const Icon(Icons.close),
                  color: Colors.black54,
                ),
              ],
            ),
          ),

          // Error summary
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connection Status: Offline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.red.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Errors: ${widget.errorLogs.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          // Error logs
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: widget.errorLogs.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'No error logs available',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: _showFullLog
                          ? widget.errorLogs.length
                          : (widget.errorLogs.length > 5
                                ? 5
                                : widget.errorLogs.length),
                      itemBuilder: (context, index) {
                        final log = widget.errorLogs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            border: Border(
                              left: BorderSide(
                                width: 4,
                                color: Colors.red.shade300,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    size: 16,
                                    color: Colors.red.shade600,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Error ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red.shade600,
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                        ClipboardData(text: log),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Error log copied to clipboard',
                                          ),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.copy,
                                      size: 16,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                log,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),

          // Show more/less button
          if (widget.errorLogs.length > 5)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextButton(
                onPressed: () {
                  setState(() {
                    _showFullLog = !_showFullLog;
                  });
                },
                child: Text(
                  _showFullLog
                      ? 'Show Less'
                      : 'Show All (${widget.errorLogs.length} errors)',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

          // Action buttons
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Copy all logs to clipboard
                      final allLogs = widget.errorLogs.join('\n\n');
                      Clipboard.setData(ClipboardData(text: allLogs));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All error logs copied to clipboard'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                    child: const Text('Copy All'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: widget.onRetry,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Retry Connection'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Simple error log manager for offline mode
class OfflineErrorLogManager {
  static final List<String> _errorLogs = [];

  static void addError(String error) {
    final timestamp = DateTime.now().toString().substring(0, 19);
    _errorLogs.add('[$timestamp] $error');

    // Keep only last 50 errors to prevent memory issues
    if (_errorLogs.length > 50) {
      _errorLogs.removeAt(0);
    }
  }

  static List<String> get errorLogs => List.unmodifiable(_errorLogs);

  static void clearLogs() {
    _errorLogs.clear();
  }

  static bool get hasErrors => _errorLogs.isNotEmpty;
}
