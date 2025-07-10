import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/optimized_loading_widget.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/auth/bloc/auth_state.dart';
import '../../features/users/bloc/user_bloc.dart';
import '../../features/users/bloc/user_event.dart';
import '../../features/users/bloc/user_state.dart';
import '../../models/user_model.dart';
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
    _loadUsersWithAutoSync();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchTimer?.cancel();
    super.dispose();
  }

  /// Load users with auto-sync (for initial load)
  Future<void> _loadUsersWithAutoSync() async {
    if (!mounted) return;

    try {
      // First, perform auto-sync in background
      context.read<UserBloc>().add(
        const UserEvent.syncFirebaseAuthUsers(silent: false),
      );

      // Then load users with clear filters
      context.read<UserBloc>().add(
        const UserEvent.refreshUsers(clearFilters: true),
      );

      // Reset local filter states
      if (mounted) {
        _searchController.clear();
        _selectedRole = 'all';
        _selectedStatus = 'all';
      }
    } catch (e) {
      // If auto-sync fails, still try to load existing users
      if (mounted) {
        context.read<UserBloc>().add(
          const UserEvent.refreshUsers(clearFilters: true),
        );
        _searchController.clear();
        _selectedRole = 'all';
        _selectedStatus = 'all';
      }
    }
  }

  /// Load users with auto-sync (for pull to refresh)
  Future<void> _loadUsers() async {
    if (!mounted) return;

    try {
      // Perform auto-sync first
      context.read<UserBloc>().add(
        const UserEvent.syncFirebaseAuthUsers(silent: false),
      );

      // Then refresh users
      context.read<UserBloc>().add(
        const UserEvent.refreshUsers(clearFilters: true),
      );

      // Reset local filter states
      if (mounted) {
        _searchController.clear();
        _selectedRole = 'all';
        _selectedStatus = 'all';
      }
    } catch (e) {
      // If auto-sync fails, still try to refresh existing users
      if (mounted) {
        context.read<UserBloc>().add(
          const UserEvent.refreshUsers(clearFilters: true),
        );
        _searchController.clear();
        _selectedRole = 'all';
        _selectedStatus = 'all';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Management'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Main content
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                return BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    // Handle loading state
                    if (userState.maybeMap(
                      loading: (_) => true,
                      performingOperation: (_) => true,
                      orElse: () => false,
                    )) {
                      return const Center(
                        child: OptimizedLoadingWidget(
                          message: 'Loading users...',
                          color: AppColors.primary,
                          size: 50,
                          showMessage: true,
                        ),
                      );
                    }

                    // Handle error state
                    final errorMessage = userState.maybeMap(
                      error: (state) => state.message,
                      orElse: () => null,
                    );

                    if (errorMessage != null) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: AppColors.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              errorMessage,
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

                    // Get users from state
                    final users = userState.maybeMap(
                      loaded: (state) => state.filteredUsers,
                      orElse: () => <UserModel>[],
                    );

                    if (users.isEmpty) {
                      return EmptyStateWidget.noUsers(
                        actionButton: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(
                              context,
                            ).pushNamed(AppRoutes.createUser);
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
                        // Combined Search and Add User Section
                        Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.border.withValues(alpha: 0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Search Widget
                                ReusableSearchWidget(
                                  controller: _searchController,
                                  hintText: 'Search users by name or email...',
                                  onChanged: _onSearchChanged,
                                  onClear: _clearSearch,
                                  margin: EdgeInsets
                                      .zero, // Remove margin since we're inside a container
                                ),

                                const SizedBox(height: 16),

                                // Add User Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamed(AppRoutes.createUser).then((
                                        _,
                                      ) {
                                        _loadUsers(); // Refresh list after creating user
                                      });
                                    },
                                    icon: const Icon(Icons.person_add),
                                    label: const Text('Add New User'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.textWhite,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Active Filters
                        if (userState.maybeMap(
                          loaded: (state) =>
                              state.searchQuery.isNotEmpty ||
                              state.selectedRole != 'all' ||
                              state.selectedStatus != 'all',
                          orElse: () => false,
                        ))
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            color: AppColors.primaryLight.withValues(
                              alpha: 0.1,
                            ),
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
                                    _getActiveFiltersText(userState),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context.read<UserBloc>().add(
                                      const UserEvent.clearFilters(),
                                    );
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
                                  currentUserId: authState.maybeMap(
                                    authenticated: (state) => state.user.id,
                                    orElse: () => null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getActiveFiltersText(UserState userState) {
    List<String> filters = [];

    userState.maybeMap(
      loaded: (state) {
        if (state.searchQuery.isNotEmpty) {
          filters.add('Search: "${state.searchQuery}"');
        }

        if (state.selectedRole != 'all') {
          filters.add('Role: ${state.selectedRole}');
        }

        if (state.selectedStatus != 'all') {
          filters.add('Status: ${state.selectedStatus}');
        }
      },
      orElse: () {},
    );

    return filters.join(' • ');
  }

  void _onSearchChanged(String query) {
    if (_searchTimer?.isActive ?? false) _searchTimer!.cancel();

    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<UserBloc>().add(UserEvent.searchUsers(query));
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<UserBloc>().add(const UserEvent.clearFilters());
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
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
                          child: userState.maybeMap(
                            loaded: (state) => Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatInfo(
                                        'Total',
                                        state.users.length.toString(),
                                        AppColors.primary,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildStatInfo(
                                        'Active',
                                        state.users
                                            .where((u) => u.status == 'active')
                                            .length
                                            .toString(),
                                        AppColors.success,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildStatInfo(
                                        'Inactive',
                                        state.users
                                            .where(
                                              (u) => u.status == 'inactive',
                                            )
                                            .length
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
                                        state.users
                                            .where((u) => u.role == 'admin')
                                            .length
                                            .toString(),
                                        AppColors.admin,
                                      ),
                                    ),
                                    Expanded(
                                      child: _buildStatInfo(
                                        'User',
                                        state.users
                                            .where((u) => u.role == 'user')
                                            .length
                                            .toString(),
                                        AppColors.user,
                                      ),
                                    ),
                                    const Expanded(child: SizedBox()),
                                  ],
                                ),
                              ],
                            ),
                            orElse: () => const Center(
                              child: CircularProgressIndicator(),
                            ),
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
                          items: userState.maybeMap(
                            loaded: (state) => [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text(
                                  'All Roles (${state.users.length})',
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'admin',
                                child: Text(
                                  'Admin (${state.users.where((u) => u.role == 'admin').length})',
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'user',
                                child: Text(
                                  'User (${state.users.where((u) => u.role == 'user').length})',
                                ),
                              ),
                            ],
                            orElse: () => [
                              const DropdownMenuItem(
                                value: 'all',
                                child: Text('All Roles'),
                              ),
                              const DropdownMenuItem(
                                value: 'admin',
                                child: Text('Admin'),
                              ),
                              const DropdownMenuItem(
                                value: 'user',
                                child: Text('User'),
                              ),
                            ],
                          ),
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
                          items: userState.maybeMap(
                            loaded: (state) => [
                              DropdownMenuItem(
                                value: 'all',
                                child: Text(
                                  'All Status (${state.users.length})',
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'active',
                                child: Text(
                                  'Active (${state.users.where((u) => u.status == 'active').length})',
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'inactive',
                                child: Text(
                                  'Inactive (${state.users.where((u) => u.status == 'inactive').length})',
                                ),
                              ),
                            ],
                            orElse: () => [
                              const DropdownMenuItem(
                                value: 'all',
                                child: Text('All Status'),
                              ),
                              const DropdownMenuItem(
                                value: 'active',
                                child: Text('Active'),
                              ),
                              const DropdownMenuItem(
                                value: 'inactive',
                                child: Text('Inactive'),
                              ),
                            ],
                          ),
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
                        context.read<UserBloc>().add(
                          UserEvent.filterByRole(_selectedRole),
                        );
                        context.read<UserBloc>().add(
                          UserEvent.filterByStatus(_selectedStatus),
                        );
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
      final authState = context.read<AuthBloc>().state;
      final currentUserId = authState.maybeMap(
        authenticated: (state) => state.user.id,
        orElse: () => '',
      );

      context.read<UserBloc>().add(
        UserEvent.deleteUser(userId: user.id, deletedBy: currentUserId),
      );

      // Show success message - the BLoC will handle the actual deletion
      if (mounted) {
        Fluttertoast.showToast(
          msg: 'User deletion initiated',
          backgroundColor: AppColors.success,
        );
      }
    }
  }

  Future<void> _toggleUserStatus(UserModel user) async {
    final authState = context.read<AuthBloc>().state;
    final currentUserId = authState.maybeMap(
      authenticated: (state) => state.user.id,
      orElse: () => '',
    );

    final newStatus = user.status == 'active' ? 'inactive' : 'active';

    context.read<UserBloc>().add(
      UserEvent.updateUserStatus(
        userId: user.id,
        status: newStatus,
        updatedBy: currentUserId,
      ),
    );

    Fluttertoast.showToast(
      msg: 'User status update initiated',
      backgroundColor: AppColors.success,
    );
  }
}
