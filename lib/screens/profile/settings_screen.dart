import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/settings_provider.dart';
import 'help_center_screen.dart';
import 'privacy_policy_screen.dart';
import '../../utils/firestore_management_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textWhite),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.textWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preferences Section
            _buildSectionHeader('Preferences'),
            const SizedBox(height: 16),

            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return Column(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.notifications_outlined,
                      title: 'Push Notifications',
                      subtitle: 'Receive notifications about updates',
                      value: settingsProvider.notificationsEnabled,
                      onChanged: (value) {
                        settingsProvider.setNotificationsEnabled(value);
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildSwitchTile(
                      icon: Icons.dark_mode_outlined,
                      title: 'Dark Mode',
                      subtitle: 'Switch to dark theme',
                      value: settingsProvider.darkModeEnabled,
                      onChanged: (value) {
                        settingsProvider.setDarkModeEnabled(value);
                      },
                    ),

                    const SizedBox(height: 12),

                    _buildLanguageTile(settingsProvider),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Security Section
            _buildSectionHeader('Security'),
            const SizedBox(height: 16),

            _buildMenuTile(
              icon: Icons.lock_outline,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () => _navigateToChangePassword(context),
            ),

            const SizedBox(height: 12),

            _buildMenuTile(
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              subtitle: 'Add an extra layer of security',
              onTap: () => _navigateToTwoFactor(context),
            ),

            const SizedBox(height: 32),

            // Admin Section (only for admin users)
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                if (!authProvider.isAdmin) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Admin Tools'),
                    const SizedBox(height: 16),

                    _buildMenuTile(
                      icon: Icons.sync,
                      title: 'Sync Management',
                      subtitle: 'Manage data synchronization operations',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.syncManagement,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildMenuTile(
                      icon: Icons.cloud_queue,
                      title: 'Cloud Functions Settings',
                      subtitle: 'Configure Cloud Functions features',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.cloudFunctionsSettings,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildMenuTile(
                      icon: Icons.storage,
                      title: 'Database Management',
                      subtitle: 'Manage Firestore data and clean up metadata',
                      onTap: () =>
                          FirestoreManagementHelper.openManagementScreen(
                            context,
                          ),
                    ),

                    const SizedBox(height: 12),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),

            // Support Section
            _buildSectionHeader('Support'),
            const SizedBox(height: 16),

            _buildMenuTile(
              icon: Icons.help_outline,
              title: 'Help Center',
              subtitle: 'Get help and support',
              onTap: () => _navigateToHelp(context),
            ),

            const SizedBox(height: 12),

            _buildMenuTile(
              icon: Icons.info_outline,
              title: 'About',
              subtitle: 'App version and information',
              onTap: () => _showAboutDialog(context),
            ),

            const SizedBox(height: 12),

            _buildMenuTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              subtitle: 'Read our privacy policy',
              onTap: () => _navigateToPrivacy(context),
            ),

            const SizedBox(height: 12),

            _buildMenuTile(
              icon: Icons.delete_sweep,
              title: 'Clear Document Metadata',
              subtitle:
                  'Remove document IDs from database (files remain intact)',
              onTap: () => _clearDocumentMetadata(context),
            ),

            const SizedBox(height: 32),

            // Logout Section
            _buildSectionHeader('Account'),
            const SizedBox(height: 16),

            _buildMenuTile(
              icon: Icons.logout_outlined,
              title: 'Log Out',
              subtitle: 'Sign out of your account',
              onTap: () => _showLogoutDialog(context),
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageTile(SettingsProvider settingsProvider) {
    return InkWell(
      onTap: () => _showLanguageDialog(settingsProvider),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                Icons.language_outlined,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Language',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    settingsProvider.selectedLanguage,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDestructive
                    ? Colors.red.withValues(alpha: 0.1)
                    : AppColors.primary.withValues(alpha: 0.1),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isDestructive ? Colors.red : AppColors.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isDestructive ? Colors.red : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Select Language',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: settingsProvider.availableLanguages.map((language) {
              return RadioListTile<String>(
                title: Text(language),
                value: language,
                groupValue: settingsProvider.selectedLanguage,
                activeColor: AppColors.primary,
                onChanged: (String? value) {
                  if (value != null) {
                    settingsProvider.setSelectedLanguage(value);
                  }
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _navigateToChangePassword(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.changePassword);
  }

  void _navigateToTwoFactor(BuildContext context) {
    // Navigate to two-factor authentication screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Two-Factor Authentication feature coming soon'),
      ),
    );
  }

  void _navigateToHelp(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const HelpCenterScreen()));
  }

  void _navigateToPrivacy(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Management Doc',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.folder_open, color: Colors.white, size: 30),
      ),
      children: [
        const Text('A document management application built with Flutter.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _performLogout(context),
              child: const Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _clearDocumentMetadata(BuildContext context) async {
    await FirestoreManagementHelper.safeDeleteDocumentMetadata(context);
  }

  void _performLogout(BuildContext context) async {
    try {
      Navigator.of(context).pop(); // Close dialog

      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 12),
                Text('Logging out...'),
              ],
            ),
            duration: Duration(seconds: 2),
          ),
        );
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.logout();

      if (context.mounted) {
        // Clear all routes and navigate to login
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
