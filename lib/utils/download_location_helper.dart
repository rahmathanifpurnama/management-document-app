import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/file_download_service.dart';
import '../core/constants/app_colors.dart';

class DownloadLocationHelper {
  static final FileDownloadService _downloadService = FileDownloadService();

  /// Show dialog with download location information
  static Future<void> showDownloadLocationInfo(BuildContext context) async {
    final locationDescription = await _downloadService
        .getDownloadLocationDescription();
    final actualPath = await _downloadService.getDownloadDirectoryPath();
    final canAccessPublic = await _downloadService.canAccessPublicDownloads();

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.folder, color: AppColors.primary),
            const SizedBox(width: 8),
            Text(
              'Download Location',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Location Description
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Files are saved to:',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      locationDescription,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Access Status
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: canAccessPublic
                      ? AppColors.success.withValues(alpha: 0.1)
                      : AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: canAccessPublic
                        ? AppColors.success.withValues(alpha: 0.3)
                        : AppColors.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      canAccessPublic ? Icons.check_circle : Icons.info,
                      color: canAccessPublic
                          ? AppColors.success
                          : AppColors.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        canAccessPublic
                            ? 'Public Downloads folder accessible'
                            : 'Using app storage (more secure)',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: canAccessPublic
                              ? AppColors.success
                              : AppColors.warning,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // How to Find Files
              Text(
                'How to find your files:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              if (Platform.isAndroid) ...[
                _buildStep('1', 'Open File Manager app'),
                _buildStep(
                  '2',
                  canAccessPublic
                      ? 'Go to Downloads folder'
                      : 'Go to Internal Storage > Android > data',
                ),
                _buildStep(
                  '3',
                  canAccessPublic
                      ? 'Look for "ManagementDoc" folder'
                      : 'Find your app folder > files > Downloads',
                ),
              ] else ...[
                _buildStep('1', 'Open Files app'),
                _buildStep('2', 'Go to "On My iPhone/iPad"'),
                _buildStep('3', 'Find your app > Downloads'),
              ],

              const SizedBox(height: 16),

              // Technical Path (Expandable)
              ExpansionTile(
                title: Text(
                  'Technical Details',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      actualPath,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Got it',
              style: GoogleFonts.poppins(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show quick location info in a snackbar
  static Future<void> showQuickLocationInfo(BuildContext context) async {
    final locationDescription = await _downloadService
        .getDownloadLocationDescription();

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.folder, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Files saved to: $locationDescription',
                style: GoogleFonts.poppins(fontSize: 12),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Details',
          textColor: Colors.white,
          onPressed: () => showDownloadLocationInfo(context),
        ),
      ),
    );
  }
}
