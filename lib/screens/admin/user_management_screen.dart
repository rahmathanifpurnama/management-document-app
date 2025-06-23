import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/optimized_loading_widget.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../widgets/common/app_bottom_navigation.dart';
import '../../widgets/common/reusable_search_widget.dart';

import '../../widgets/user/user_card.dart';
import '../../widgets/common/empty_state_widget.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRole = 'all';
  String _selectedStatus = 'all';
  Timer? _searchTimer;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Use Future.microtask to prevent blocking UI
    await Future.microtask(() async {
      await userProvider.refreshUsers(clearFilters: true);
    });

    // Reset local filter states
    if (mounted) {
      _searchController.clear();
      _selectedRole = 'all';
      _selectedStatus = 'all';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldWithNavigation(
      title: 'User Management',
      currentNavIndex: 3, // Add User is index 3 for admin
      showAppBar: true, // Ensure app bar is shown
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: _showFilterDialog,
        ),
      ],
      body: Consumer2<UserProvider, AuthProvider>(
        builder: (context, userProvider, authProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: OptimizedLoadingWidget(
                message: 'Loading users...',
                color: AppColors.primary,
                size: 50,
                showMessage: true,
              ),
            );
          }

          if (userProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    userProvider.errorMessage!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadUsers,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final users = userProvider.users;

          if (users.isEmpty) {
            return EmptyStateWidget.noUsers(
              actionButton: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.createUser);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
              ),
            );
          }

          return Column(
            children: [
              // Search Section
              ReusableSearchWidget(
                controller: _searchController,
                hintText: 'Search users by name or email...',
                onChanged: _onSearchChanged,
                onClear: _clearSearch,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),

              // Header Section with Add User Button
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surface,
                child: Column(
                  children: [
                    // Add User Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(
                            context,
                          ).pushNamed(AppRoutes.createUser).then((_) {
                            _loadUsers(); // Refresh list after creating user
                          });
                        },
                        icon: const Icon(Icons.person_add),
                        label: const Text('Add New User'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.textWhite,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Active Filters
              if (userProvider.searchQuery.isNotEmpty ||
                  userProvider.selectedRole != 'all' ||
                  userProvider.selectedStatus != 'all')
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.filter_list,
                        size: 16,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _getActiveFiltersText(userProvider),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          userProvider.clearFilters();
                          _searchController.clear();
                          _selectedRole = 'all';
                          _selectedStatus = 'all';
                        },
                        child: const Text(
                          'Clear Filters',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),

              // Users List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _loadUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return UserCard(
                        user: user,
                        onTap: () => _showUserDetails(user),
                        onEdit: () => _editUser(user),
                        onDelete: () => _deleteUser(user),
                        onToggleStatus: () => _toggleUserStatus(user),
                        currentUserId: authProvider.currentUser?.id,
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getActiveFiltersText(UserProvider userProvider) {
    List<String> filters = [];

    if (userProvider.searchQuery.isNotEmpty) {
      filters.add('Search: "${userProvider.searchQuery}"');
    }

    if (userProvider.selectedRole != 'all') {
      filters.add('Role: ${userProvider.selectedRole}');
    }

    if (userProvider.selectedStatus != 'all') {
      filters.add('Status: ${userProvider.selectedStatus}');
    }

    return filters.join(' • ');
  }

  void _onSearchChanged(String query) {
    if (_searchTimer?.isActive ?? false) _searchTimer!.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.searchUsers(query);
    });
  }

  void _clearSearch() {
    _searchController.clear();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.clearFilters();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                return AlertDialog(
                  title: const Text('Filter Users'),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Statistics Section
                        const Text(
                          'User Statistics:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Statistics Grid
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.textHint.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatInfo(
                                      'Total',
                                      userProvider.totalUsersCount.toString(),
                                      AppColors.primary,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatInfo(
                                      'Active',
                                      userProvider.activeUsersCount.toString(),
                                      AppColors.success,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatInfo(
                                      'Inactive',
                                      userProvider.inactiveUsersCount
                                          .toString(),
                                      AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildStatInfo(
                                      'Admin',
                                      userProvider.adminUsersCount.toString(),
                                      AppColors.admin,
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildStatInfo(
                                      'User',
                                      userProvider.regularUsersCount.toString(),
                                      AppColors.user,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Filter Section
                        const Text(
                          'Filter Users:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),

                        DropdownButtonFormField<String>(
                          value: _selectedRole,
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(
                                'All Roles (${userProvider.totalUsersCount})',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'admin',
                              child: Text(
                                'Admin (${userProvider.adminUsersCount})',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'user',
                              child: Text(
                                'User (${userProvider.regularUsersCount})',
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(
                                'All Status (${userProvider.totalUsersCount})',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'active',
                              child: Text(
                                'Active (${userProvider.activeUsersCount})',
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'inactive',
                              child: Text(
                                'Inactive (${userProvider.inactiveUsersCount})',
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedStatus = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final userProvider = Provider.of<UserProvider>(
                          context,
                          listen: false,
                        );
                        userProvider.filterByRole(_selectedRole);
                        userProvider.filterByStatus(_selectedStatus);
                        Navigator.of(context).pop();
                      },
                      child: const Text('Apply'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildStatInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showUserDetails(UserModel user) {
    Navigator.of(context).pushNamed(AppRoutes.userDetails, arguments: user);
  }

  void _editUser(UserModel user) {
    Navigator.of(context).pushNamed(AppRoutes.editUser, arguments: user);
  }

  Future<void> _deleteUser(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text(
            'Are you sure you want to delete user "${user.fullName}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUserId = authProvider.currentUser!.id;

      final success = await userProvider.deleteUser(user.id, currentUserId);

      if (mounted) {
        if (success) {
          Fluttertoast.showToast(
            msg: 'User deleted successfully',
            backgroundColor: AppColors.success,
          );
        } else {
          Fluttertoast.showToast(
            msg: userProvider.errorMessage ?? 'Failed to delete user',
            backgroundColor: AppColors.error,
          );
        }
      }
    }
  }

  Future<void> _toggleUserStatus(UserModel user) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final newStatus = user.status == 'active' ? 'inactive' : 'active';

    final success = await userProvider.updateUserStatus(
      user.id,
      newStatus,
      authProvider.currentUser!.id,
    );

    if (success) {
      Fluttertoast.showToast(
        msg: 'User status updated successfully',
        backgroundColor: AppColors.success,
      );
    } else {
      Fluttertoast.showToast(
        msg: userProvider.errorMessage ?? 'Failed to update user status',
        backgroundColor: AppColors.error,
      );
    }
  }
}
