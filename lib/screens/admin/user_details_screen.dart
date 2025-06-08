import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/custom_app_bar.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserModel user;

  const UserDetailsScreen({super.key, required this.user});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Detail Pengguna',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.editUser, arguments: widget.user);
            },
            tooltip: 'Edit User',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Avatar
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.textWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    widget.user.fullName,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    widget.user.email,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: AppColors.textWhite.withValues(alpha: 0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),

                  // Role & Status Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildBadge(
                        widget.user.role.toUpperCase(),
                        widget.user.role == 'admin'
                            ? AppColors.admin
                            : AppColors.user,
                      ),
                      const SizedBox(width: 8),
                      _buildBadge(
                        widget.user.status == 'active'
                            ? 'AKTIF'
                            : 'TIDAK AKTIF',
                        widget.user.status == 'active'
                            ? AppColors.success
                            : AppColors.error,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // User Information
            _buildSectionHeader('Informasi Pengguna'),
            const SizedBox(height: 16),

            _buildInfoCard([
              _buildInfoRow('ID Pengguna', widget.user.id, Icons.fingerprint),
              _buildInfoRow('Nama Lengkap', widget.user.fullName, Icons.person),
              _buildInfoRow('Email', widget.user.email, Icons.email),
              _buildInfoRow(
                'Role',
                widget.user.role.toUpperCase(),
                Icons.admin_panel_settings,
              ),
              _buildInfoRow(
                'Status',
                widget.user.status == 'active' ? 'Aktif' : 'Tidak Aktif',
                Icons.toggle_on,
              ),
            ]),

            const SizedBox(height: 24),

            // System Information
            _buildSectionHeader('Informasi Sistem'),
            const SizedBox(height: 16),

            _buildInfoCard([
              _buildInfoRow(
                'Dibuat Pada',
                widget.user.createdAt != null
                    ? _formatDate(widget.user.createdAt!)
                    : 'Tidak tersedia',
                Icons.calendar_today,
              ),
              _buildInfoRow(
                'Dibuat Oleh',
                widget.user.createdBy ?? 'Tidak tersedia',
                Icons.person_add,
              ),
            ]),

            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.textWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textHint.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final currentUserId = authProvider.currentUser?.id;
        final canEdit =
            currentUserId != widget.user.id; // Tidak bisa edit diri sendiri

        return Column(
          children: [
            // Edit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canEdit
                    ? () {
                        Navigator.of(
                          context,
                        ).pushNamed(AppRoutes.editUser, arguments: widget.user);
                      }
                    : null,
                icon: const Icon(Icons.edit),
                label: Text(
                  'Edit Pengguna',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textWhite,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Toggle Status Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: canEdit
                    ? () {
                        _toggleUserStatus(context);
                      }
                    : null,
                icon: Icon(
                  widget.user.status == 'active'
                      ? Icons.block
                      : Icons.check_circle,
                ),
                label: Text(
                  widget.user.status == 'active' ? 'Nonaktifkan' : 'Aktifkan',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: widget.user.status == 'active'
                      ? AppColors.error
                      : AppColors.success,
                  side: BorderSide(
                    color: widget.user.status == 'active'
                        ? AppColors.error
                        : AppColors.success,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            if (canEdit) ...[
              const SizedBox(height: 12),

              // Delete Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _deleteUser(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: Text(
                    'Hapus Pengguna',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _toggleUserStatus(BuildContext context) {
    final newStatus = widget.user.status == 'active' ? 'inactive' : 'active';
    final action = widget.user.status == 'active'
        ? 'menonaktifkan'
        : 'mengaktifkan';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text(
          'Apakah Anda yakin ingin $action pengguna "${widget.user.fullName}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              navigator.pop();

              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              final success = await userProvider.updateUserStatus(
                widget.user.id,
                newStatus,
                authProvider.currentUser!.id,
              );

              if (success) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Status pengguna berhasil diubah'),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Gagal mengubah status pengguna'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newStatus == 'active'
                  ? AppColors.success
                  : AppColors.error,
            ),
            child: Text('Ya, ${action.substring(0, action.length - 2)}'),
          ),
        ],
      ),
    );
  }

  void _deleteUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus pengguna "${widget.user.fullName}"? Tindakan ini tidak dapat dibatalkan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);

              navigator.pop();

              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              final success = await userProvider.deleteUser(
                widget.user.id,
                authProvider.currentUser!.id,
              );

              if (success) {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Pengguna berhasil dihapus'),
                    backgroundColor: AppColors.success,
                  ),
                );
                navigator.pop(); // Kembali ke user management
              } else {
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus pengguna'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text('Ya, Hapus'),
          ),
        ],
      ),
    );
  }
}
