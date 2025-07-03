import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/services/firebase_service.dart';
import '../../core/constants/app_colors.dart';

/// Widget to display Firebase connection status
class FirebaseStatusWidget extends StatefulWidget {
  final Widget child;
  final bool showStatusBar;
  final VoidCallback? onRetry;

  const FirebaseStatusWidget({
    super.key,
    required this.child,
    this.showStatusBar = true,
    this.onRetry,
  });

  @override
  State<FirebaseStatusWidget> createState() => _FirebaseStatusWidgetState();
}

class _FirebaseStatusWidgetState extends State<FirebaseStatusWidget> {
  late FirebaseServiceStatus _status;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  void _updateStatus() {
    setState(() {
      _status = FirebaseService.instance.status;
    });
  }

  Future<void> _retry() async {
    if (_isRetrying) return;

    setState(() {
      _isRetrying = true;
    });

    try {
      await FirebaseService.instance.attemptRecovery();
      _updateStatus();
      
      if (widget.onRetry != null) {
        widget.onRetry!();
      }
    } catch (e) {
      debugPrint('❌ Firebase recovery failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.showStatusBar && _shouldShowStatusBar()) _buildStatusBar(),
        Expanded(child: widget.child),
      ],
    );
  }

  bool _shouldShowStatusBar() {
    return _status.state == FirebaseInitializationState.failed ||
           _status.state == FirebaseInitializationState.offline ||
           !_status.isFullyAvailable;
  }

  Widget _buildStatusBar() {
    Color backgroundColor;
    IconData icon;
    String message;

    switch (_status.state) {
      case FirebaseInitializationState.failed:
        backgroundColor = AppColors.error;
        icon = Icons.error_outline;
        message = 'Connection failed';
        break;
      case FirebaseInitializationState.offline:
        backgroundColor = Colors.orange;
        icon = Icons.cloud_off;
        message = 'Offline mode';
        break;
      case FirebaseInitializationState.initializing:
        backgroundColor = Colors.blue;
        icon = Icons.sync;
        message = 'Connecting...';
        break;
      default:
        if (!_status.isFullyAvailable) {
          backgroundColor = Colors.orange;
          icon = Icons.warning_amber;
          message = 'Limited functionality';
        } else {
          return const SizedBox.shrink();
        }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: backgroundColor,
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (_status.state == FirebaseInitializationState.failed ||
              _status.state == FirebaseInitializationState.offline)
            _buildRetryButton(),
        ],
      ),
    );
  }

  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: _isRetrying ? null : _retry,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: _isRetrying
            ? const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                'Retry',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// Widget to show detailed Firebase status for debugging
class FirebaseStatusDebugWidget extends StatelessWidget {
  const FirebaseStatusDebugWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final status = FirebaseService.instance.status;
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Firebase Status',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusRow('State', status.state.toString()),
            _buildStatusRow('Firebase Core', status.isFirebaseInitialized),
            _buildStatusRow('Auth', status.isAuthAvailable),
            _buildStatusRow('Firestore', status.isFirestoreAvailable),
            _buildStatusRow('Storage', status.isStorageAvailable),
            _buildStatusRow('Functions', status.isFunctionsAvailable),
            if (status.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Error: ${status.errorMessage}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, dynamic value) {
    Color color;
    String displayValue;
    
    if (value is bool) {
      color = value ? Colors.green : Colors.red;
      displayValue = value ? 'Available' : 'Unavailable';
    } else {
      color = AppColors.textSecondary;
      displayValue = value.toString();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12),
          ),
          Text(
            displayValue,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
