import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../core/constants/app_colors.dart';
import '../models/offline_auth_models.dart';

/// Widget that displays the current network and authentication status
class NetworkStatusWidget extends StatelessWidget {
  final bool showDetails;
  final bool compact;

  const NetworkStatusWidget({
    super.key,
    this.showDetails = false,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final isOnline = authProvider.isOnline;
        final authMode = authProvider.authMode;
        
        if (compact) {
          return _buildCompactStatus(isOnline, authMode);
        }
        
        return _buildDetailedStatus(context, authProvider, isOnline, authMode);
      },
    );
  }

  Widget _buildCompactStatus(bool isOnline, AuthMode authMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getStatusColor(isOnline, authMode).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(isOnline, authMode),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getStatusIcon(isOnline, authMode),
            size: 12,
            color: _getStatusColor(isOnline, authMode),
          ),
          const SizedBox(width: 4),
          Text(
            _getStatusText(isOnline, authMode),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: _getStatusColor(isOnline, authMode),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedStatus(
    BuildContext context,
    AuthProvider authProvider,
    bool isOnline,
    AuthMode authMode,
  ) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _getStatusIcon(isOnline, authMode),
                  color: _getStatusColor(isOnline, authMode),
                ),
                const SizedBox(width: 8),
                Text(
                  'Status Koneksi',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildStatusRow(
              'Koneksi Internet',
              isOnline ? 'Terhubung' : 'Terputus',
              isOnline ? Icons.wifi : Icons.wifi_off,
              isOnline ? AppColors.success : AppColors.error,
            ),
            const SizedBox(height: 8),
            _buildStatusRow(
              'Mode Autentikasi',
              _getAuthModeText(authMode),
              _getAuthModeIcon(authMode),
              _getAuthModeColor(authMode),
            ),
            if (showDetails) ...[
              const SizedBox(height: 8),
              _buildStatusRow(
                'Biometrik',
                authProvider.biometricEnabled ? 'Tersedia' : 'Tidak Tersedia',
                authProvider.biometricEnabled 
                    ? Icons.fingerprint 
                    : Icons.fingerprint_outlined,
                authProvider.biometricEnabled 
                    ? AppColors.success 
                    : AppColors.textSecondary,
              ),
            ],
            if (!isOnline) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.warning),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: AppColors.warning,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mode offline aktif. Beberapa fitur mungkin terbatas.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(bool isOnline, AuthMode authMode) {
    if (!isOnline) return AppColors.warning;
    
    switch (authMode) {
      case AuthMode.online:
        return AppColors.success;
      case AuthMode.offline:
        return AppColors.warning;
      case AuthMode.biometric:
        return AppColors.primary;
      case AuthMode.hybrid:
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getStatusIcon(bool isOnline, AuthMode authMode) {
    if (!isOnline) return Icons.wifi_off;
    
    switch (authMode) {
      case AuthMode.online:
        return Icons.cloud_done;
      case AuthMode.offline:
        return Icons.offline_bolt;
      case AuthMode.biometric:
        return Icons.fingerprint;
      case AuthMode.hybrid:
        return Icons.sync;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(bool isOnline, AuthMode authMode) {
    if (!isOnline) return 'Offline';
    
    switch (authMode) {
      case AuthMode.online:
        return 'Online';
      case AuthMode.offline:
        return 'Offline';
      case AuthMode.biometric:
        return 'Biometrik';
      case AuthMode.hybrid:
        return 'Hybrid';
      default:
        return 'Unknown';
    }
  }

  String _getAuthModeText(AuthMode authMode) {
    switch (authMode) {
      case AuthMode.online:
        return 'Online';
      case AuthMode.offline:
        return 'Offline';
      case AuthMode.biometric:
        return 'Biometrik';
      case AuthMode.hybrid:
        return 'Hybrid';
      case AuthMode.none:
        return 'Tidak Aktif';
    }
  }

  IconData _getAuthModeIcon(AuthMode authMode) {
    switch (authMode) {
      case AuthMode.online:
        return Icons.cloud;
      case AuthMode.offline:
        return Icons.offline_bolt;
      case AuthMode.biometric:
        return Icons.fingerprint;
      case AuthMode.hybrid:
        return Icons.sync;
      case AuthMode.none:
        return Icons.block;
    }
  }

  Color _getAuthModeColor(AuthMode authMode) {
    switch (authMode) {
      case AuthMode.online:
        return AppColors.success;
      case AuthMode.offline:
        return AppColors.warning;
      case AuthMode.biometric:
        return AppColors.primary;
      case AuthMode.hybrid:
        return AppColors.success;
      case AuthMode.none:
        return AppColors.textSecondary;
    }
  }
}

/// Simple connectivity indicator for app bars
class ConnectivityIndicator extends StatelessWidget {
  const ConnectivityIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isOnline) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.warning,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi_off,
                size: 12,
                color: AppColors.textWhite,
              ),
              const SizedBox(width: 4),
              Text(
                'Offline',
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Network status banner that appears at the top when offline
class NetworkStatusBanner extends StatelessWidget {
  const NetworkStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isOnline) {
          return const SizedBox.shrink();
        }

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: AppColors.warning,
          child: Row(
            children: [
              Icon(
                Icons.wifi_off,
                color: AppColors.textWhite,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mode Offline Aktif',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Beberapa fitur mungkin terbatas. Data akan disinkronkan saat koneksi pulih.',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => authProvider.refreshConnectivity(),
                icon: Icon(
                  Icons.refresh,
                  color: AppColors.textWhite,
                ),
                tooltip: 'Periksa Koneksi',
              ),
            ],
          ),
        );
      },
    );
  }
}
