import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/circuit_breaker.dart';
import '../../widgets/common/app_bottom_navigation.dart';

/// Debug screen to monitor circuit breaker status
class CircuitBreakerDebugScreen extends StatefulWidget {
  const CircuitBreakerDebugScreen({super.key});

  @override
  State<CircuitBreakerDebugScreen> createState() => _CircuitBreakerDebugScreenState();
}

class _CircuitBreakerDebugScreenState extends State<CircuitBreakerDebugScreen> {
  Map<String, Map<String, dynamic>> _circuitStatus = {};

  @override
  void initState() {
    super.initState();
    _loadCircuitStatus();
  }

  void _loadCircuitStatus() {
    setState(() {
      _circuitStatus = CircuitBreaker.getCircuitStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'Circuit Breaker Debug',
      currentNavIndex: -1, // No navigation highlight
      showAppBar: true,
      body: Column(
        children: [
          // Header with refresh button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.border.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Circuit Breaker Status',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _loadCircuitStatus,
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Refresh Status',
                    ),
                    IconButton(
                      onPressed: _resetAllCircuits,
                      icon: const Icon(Icons.restore),
                      tooltip: 'Reset All Circuits',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Circuit status list
          Expanded(
            child: _circuitStatus.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _circuitStatus.length,
                    itemBuilder: (context, index) {
                      final entry = _circuitStatus.entries.elementAt(index);
                      return _buildCircuitCard(entry.key, entry.value);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.electrical_services,
            size: 64,
            color: AppColors.textSecondary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Circuit Breakers Active',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Circuit breakers will appear here when operations fail',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCircuitCard(String operationId, Map<String, dynamic> status) {
    final state = status['state'] as String;
    final failureCount = status['failureCount'] as int;
    final lastFailureTime = status['lastFailureTime'] as String?;
    final nextRetryTime = status['nextRetryTime'] as String?;

    Color stateColor;
    IconData stateIcon;
    
    switch (state) {
      case '_CircuitState.closed':
        stateColor = Colors.green;
        stateIcon = Icons.check_circle;
        break;
      case '_CircuitState.open':
        stateColor = Colors.red;
        stateIcon = Icons.error;
        break;
      case '_CircuitState.halfOpen':
        stateColor = Colors.orange;
        stateIcon = Icons.warning;
        break;
      default:
        stateColor = Colors.grey;
        stateIcon = Icons.help;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  stateIcon,
                  color: stateColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    operationId,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: stateColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    state.split('.').last.toUpperCase(),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: stateColor,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Details
            _buildDetailRow('Failures', '$failureCount'),
            if (lastFailureTime != null)
              _buildDetailRow('Last Failure', _formatDateTime(lastFailureTime)),
            if (nextRetryTime != null)
              _buildDetailRow('Next Retry', _formatDateTime(nextRetryTime)),

            // Reset button for individual circuit
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _resetCircuit(operationId),
                icon: const Icon(Icons.restore, size: 16),
                label: const Text('Reset'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String isoString) {
    try {
      final dateTime = DateTime.parse(isoString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inHours < 1) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inDays < 1) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    } catch (e) {
      return isoString;
    }
  }

  void _resetCircuit(String operationId) {
    CircuitBreaker.resetCircuit(operationId);
    _loadCircuitStatus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Circuit breaker reset: $operationId'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _resetAllCircuits() {
    CircuitBreaker.resetAllCircuits();
    _loadCircuitStatus();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All circuit breakers reset'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
