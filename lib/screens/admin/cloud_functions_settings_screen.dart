import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../providers/consolidated_upload_provider.dart';

class CloudFunctionsSettingsScreen extends StatefulWidget {
  const CloudFunctionsSettingsScreen({super.key});

  @override
  State<CloudFunctionsSettingsScreen> createState() =>
      _CloudFunctionsSettingsScreenState();
}

class _CloudFunctionsSettingsScreenState
    extends State<CloudFunctionsSettingsScreen> {
  bool _isTestingConnection = false;
  String? _connectionStatus;

  @override
  void initState() {
    super.initState();
    // Initialize Cloud Functions when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeCloudFunctions();
    });
  }

  Future<void> _initializeCloudFunctions() async {
    final provider = Provider.of<ConsolidatedUploadProvider>(
      context,
      listen: false,
    );
    await provider.initializeCloudFunctions();
  }

  Future<void> _testConnection() async {
    if (_isTestingConnection) return;

    setState(() {
      _isTestingConnection = true;
      _connectionStatus = 'Testing...';
    });

    try {
      final provider = Provider.of<ConsolidatedUploadProvider>(
        context,
        listen: false,
      );

      final isAvailable = await provider.checkCloudFunctionsAvailability();

      setState(() {
        _connectionStatus = isAvailable
            ? 'Connected Successfully'
            : 'Connection Failed';
      });

      // Show result message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAvailable
                  ? 'Cloud Functions are working properly!'
                  : 'Cloud Functions are not available. Check deployment.',
            ),
            backgroundColor: isAvailable ? AppColors.success : AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _connectionStatus = 'Error: ${e.toString()}';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Test failed: ${e.toString()}'),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTestingConnection = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'Cloud Functions Settings',
      currentNavIndex: 4, // Profile index for admin
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCloudFunctionsStatusCard(),
            const SizedBox(height: 16),
            _buildFeaturesCard(),
            const SizedBox(height: 16),
            _buildPerformanceCard(),
            const SizedBox(height: 16),
            _buildTroubleshootingCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCloudFunctionsStatusCard() {
    return Consumer<ConsolidatedUploadProvider>(
      builder: (context, uploadProvider, child) {
        final isEnabled = uploadProvider.isCloudFunctionsEnabled;

        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.cloud_queue, color: AppColors.primary, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Cloud Functions Status',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isEnabled ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isEnabled ? 'Enabled' : 'Disabled',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: isEnabled ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const Spacer(),
                    Switch(
                      value: isEnabled,
                      onChanged: (value) {
                        uploadProvider.toggleCloudFunctions(value);
                        _showToggleMessage(value);
                      },
                      activeColor: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isEnabled
                      ? 'Cloud Functions are handling file uploads, category management, and sync operations for better performance and reliability.'
                      : 'Using traditional Firebase operations. Enable Cloud Functions for enhanced performance and features.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                // Connection status and test button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Connection Status',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _connectionStatus ??
                                (uploadProvider.isCloudFunctionsAvailable
                                    ? 'Available'
                                    : 'Not Available'),
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: uploadProvider.isCloudFunctionsAvailable
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isTestingConnection ? null : _testConnection,
                      icon: _isTestingConnection
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.wifi_protected_setup, size: 16),
                      label: Text(
                        _isTestingConnection ? 'Testing...' : 'Test',
                        style: GoogleFonts.poppins(fontSize: 12),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeaturesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Features',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            _buildFeatureItem(
              'Enhanced File Upload',
              'Automatic file validation, processing, and metadata extraction',
              Icons.cloud_upload,
              true,
            ),
            _buildFeatureItem(
              'Category Management',
              'Server-side category operations with better error handling',
              Icons.folder,
              true,
            ),
            _buildFeatureItem(
              'User Management',
              'Secure user creation and permission management',
              Icons.people,
              true,
            ),
            _buildFeatureItem(
              'Sync Operations',
              'Automated data synchronization and cleanup',
              Icons.sync,
              true,
            ),
            _buildFeatureItem(
              'Notifications',
              'Real-time notifications for important events',
              Icons.notifications,
              true,
            ),
            _buildFeatureItem(
              'Activity Logging',
              'Comprehensive activity tracking and audit trails',
              Icons.history,
              true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    String title,
    String description,
    IconData icon,
    bool available,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: available
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: available ? AppColors.success : AppColors.textSecondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            available ? Icons.check_circle : Icons.info,
            color: available ? AppColors.success : AppColors.textSecondary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Performance Benefits',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildPerformanceItem(
              'Reduced ANR Risk',
              'Heavy operations moved to server-side processing',
              Icons.timer_off,
            ),
            _buildPerformanceItem(
              'Better Error Handling',
              'Comprehensive error handling and retry mechanisms',
              Icons.error_outline,
            ),
            _buildPerformanceItem(
              'Automatic Fallback',
              'Falls back to traditional methods if Cloud Functions fail',
              Icons.backup,
            ),
            _buildPerformanceItem(
              'Scalability',
              'Server-side processing scales automatically with load',
              Icons.trending_up,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceItem(
    String title,
    String description,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTroubleshootingCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Troubleshooting',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildTroubleshootingItem(
              'If uploads fail',
              'The app will automatically fallback to traditional upload methods',
            ),
            _buildTroubleshootingItem(
              'If Cloud Functions are slow',
              'Disable Cloud Functions temporarily and use direct Firebase operations',
            ),
            _buildTroubleshootingItem(
              'For debugging',
              'Check the debug console for detailed Cloud Functions logs',
            ),
            _buildTroubleshootingItem(
              'Network issues',
              'Cloud Functions require stable internet connection',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTroubleshootingItem(String issue, String solution) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            solution,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showToggleMessage(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Cloud Functions enabled. Enhanced features are now active.'
              : 'Cloud Functions disabled. Using traditional Firebase operations.',
        ),
        backgroundColor: enabled ? AppColors.success : AppColors.warning,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
