import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
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
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: const Column(
                children: [
                  Icon(
                    Icons.privacy_tip_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Last updated: January 2024',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Introduction
            _buildSection(
              'Introduction',
              'Management Doc ("we," "our," or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our document management application.',
            ),

            // Information We Collect
            _buildSection(
              'Information We Collect',
              'We collect information you provide directly to us, such as:\n\n'
                  '• Account information (name, email address, password)\n'
                  '• Documents and files you upload\n'
                  '• Usage data and preferences\n'
                  '• Communication with our support team',
            ),

            // How We Use Your Information
            _buildSection(
              'How We Use Your Information',
              'We use the information we collect to:\n\n'
                  '• Provide and maintain our services\n'
                  '• Process and store your documents securely\n'
                  '• Communicate with you about your account\n'
                  '• Improve our application and services\n'
                  '• Ensure security and prevent fraud',
            ),

            // Data Security
            _buildSection(
              'Data Security',
              'We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. Your documents are encrypted both in transit and at rest.',
            ),

            // Data Sharing
            _buildSection(
              'Data Sharing',
              'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent, except as described in this policy. We may share information:\n\n'
                  '• With your explicit consent\n'
                  '• To comply with legal obligations\n'
                  '• To protect our rights and safety',
            ),

            // Your Rights
            _buildSection(
              'Your Rights',
              'You have the right to:\n\n'
                  '• Access your personal information\n'
                  '• Correct inaccurate information\n'
                  '• Delete your account and data\n'
                  '• Export your data\n'
                  '• Opt-out of communications',
            ),

            // Data Retention
            _buildSection(
              'Data Retention',
              'We retain your information for as long as your account is active or as needed to provide services. You may delete your account at any time, and we will delete your data within 30 days of account deletion.',
            ),

            // Children\'s Privacy
            _buildSection(
              'Children\'s Privacy',
              'Our service is not intended for children under 13 years of age. We do not knowingly collect personal information from children under 13.',
            ),

            // Changes to Privacy Policy
            _buildSection(
              'Changes to This Privacy Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page and updating the "Last updated" date.',
            ),

            // Contact Information
            _buildSection(
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us:\n\n'
                  'Email: privacy@managementdoc.com\n'
                  'Phone: +1 (555) 123-4567',
            ),

            const SizedBox(height: 32),

            // Footer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: const Text(
                'By using Management Doc, you agree to the collection and use of information in accordance with this Privacy Policy.',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
