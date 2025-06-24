import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../models/firebase_auth_user_model.dart';

/// Card widget for displaying Firebase Auth users
class FirebaseAuthUserCard extends StatelessWidget {
  final CombinedUserModel user;
  final VoidCallback? onSync;
  final VoidCallback? onTap;

  const FirebaseAuthUserCard({
    super.key,
    required this.user,
    this.onSync,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: 6,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: isSmallScreen ? 20 : 24,
                    backgroundColor: user.existsInFirestore
                        ? AppColors.success.withValues(alpha: 0.2)
                        : AppColors.warning.withValues(alpha: 0.2),
                    child: Icon(
                      user.existsInFirestore ? Icons.person : Icons.person_outline,
                      color: user.existsInFirestore ? AppColors.success : AppColors.warning,
                      size: isSmallScreen ? 20 : 24,
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // User Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.displayName,
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user.email,
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 12 : 14,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // Status Badge
                  _buildStatusBadge(isSmallScreen),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Details Row
              Row(
                children: [
                  Expanded(
                    child: _buildDetailChip(
                      'Role',
                      user.role.toUpperCase(),
                      AppColors.primary,
                      isSmallScreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDetailChip(
                      'Status',
                      user.status.toUpperCase(),
                      user.isActive ? AppColors.success : AppColors.error,
                      isSmallScreen,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildDetailChip(
                      'Verified',
                      user.authUser.emailVerified ? 'YES' : 'NO',
                      user.authUser.emailVerified ? AppColors.success : AppColors.warning,
                      isSmallScreen,
                    ),
                  ),
                ],
              ),
              
              // Sync Button (only show if not in Firestore)
              if (!user.existsInFirestore) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onSync,
                    icon: const Icon(Icons.sync, size: 16),
                    label: Text(
                      'Sync to Firestore',
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.warning,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 8 : 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isSmallScreen) {
    final color = user.existsInFirestore ? AppColors.success : AppColors.warning;
    final text = user.existsInFirestore ? 'SYNCED' : 'NOT SYNCED';
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 10 : 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDetailChip(String label, String value, Color color, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 6 : 8,
        vertical: isSmallScreen ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 9 : 10,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 10 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
