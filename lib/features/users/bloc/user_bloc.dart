import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import 'user_event.dart';
import 'user_state.dart';

/// BLoC for managing user operations and state
/// Handles all user-related business logic with debouncing, error handling, and retry mechanisms
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository _repository;

  // Debouncing timer for search
  Timer? _searchDebounceTimer;

  // Store last failed operation for retry
  UserEvent? _lastFailedOperation;

  // Stream subscription for real-time updates
  StreamSubscription<List<UserModel>>? _usersStreamSubscription;

  UserBloc({UserRepository? repository})
    : _repository = repository ?? UserRepositoryImpl(),
      super(const UserState.initial()) {
    // Register event handlers
    on<LoadUsers>(_onLoadUsers);
    on<RefreshUsers>(_onRefreshUsers);
    on<SearchUsers>(_onSearchUsers);
    on<FilterByRole>(_onFilterByRole);
    on<FilterByStatus>(_onFilterByStatus);
    on<ClearFilters>(_onClearFilters);
    on<CreateUser>(_onCreateUser);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserStatus>(_onUpdateUserStatus);
    on<UpdateUserPermissions>(_onUpdateUserPermissions);
    on<DeleteUser>(_onDeleteUser);
    on<SyncFirebaseAuthUsers>(_onSyncFirebaseAuthUsers);
    on<ClearError>(_onClearError);
    on<RetryLastOperation>(_onRetryLastOperation);
  }

  /// Load all users
  Future<void> _onLoadUsers(LoadUsers event, Emitter<UserState> emit) async {
    try {
      emit(const UserState.loading());

      final users = await _repository.getAllUsers();

      emit(UserState.loaded(users: users, filteredUsers: users));

      // Setup real-time updates after initial load
      _setupUsersStream();
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to load users - $e');
      _lastFailedOperation = event;
      emit(
        UserState.error(
          message: e.toString(),
          canRetry: true,
          lastFailedOperation: 'loadUsers',
        ),
      );
    }
  }

  /// Refresh users with optional filter clearing
  Future<void> _onRefreshUsers(
    RefreshUsers event,
    Emitter<UserState> emit,
  ) async {
    try {
      final currentState = state;

      // Keep current filters unless explicitly clearing
      String searchQuery = event.clearFilters
          ? ''
          : currentState.currentSearchQuery;
      String selectedRole = event.clearFilters
          ? 'all'
          : currentState.currentSelectedRole;
      String selectedStatus = event.clearFilters
          ? 'all'
          : currentState.currentSelectedStatus;

      emit(const UserState.loading());

      final users = await _repository.getAllUsers();
      final filteredUsers = _applyFilters(
        users,
        searchQuery,
        selectedRole,
        selectedStatus,
      );

      emit(
        UserState.loaded(
          users: users,
          filteredUsers: filteredUsers,
          searchQuery: searchQuery,
          selectedRole: selectedRole,
          selectedStatus: selectedStatus,
          isFiltered: _isFiltered(searchQuery, selectedRole, selectedStatus),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to refresh users - $e');
      _lastFailedOperation = event;
      emit(
        UserState.error(
          message: e.toString(),
          users: state.currentUsers,
          filteredUsers: state.currentFilteredUsers,
          searchQuery: state.currentSearchQuery,
          selectedRole: state.currentSelectedRole,
          selectedStatus: state.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'refreshUsers',
        ),
      );
    }
  }

  /// Search users with debouncing
  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Update state immediately with new search query
    if (currentState is UserLoaded) {
      emit(currentState.copyWith(searchQuery: event.query));
    }

    // Set new timer for debounced search
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (!isClosed) {
        _performSearch(event.query, emit);
      }
    });
  }

  /// Perform actual search operation
  void _performSearch(String query, Emitter<UserState> emit) {
    final currentState = state;

    if (currentState.hasData) {
      final filteredUsers = _applyFilters(
        currentState.currentUsers,
        query,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: currentState.currentUsers,
          filteredUsers: filteredUsers,
          searchQuery: query,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            query,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    }
  }

  /// Filter users by role
  Future<void> _onFilterByRole(
    FilterByRole event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState.hasData) {
      final filteredUsers = _applyFilters(
        currentState.currentUsers,
        currentState.currentSearchQuery,
        event.role,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: currentState.currentUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: event.role,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            event.role,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    }
  }

  /// Filter users by status
  Future<void> _onFilterByStatus(
    FilterByStatus event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState.hasData) {
      final filteredUsers = _applyFilters(
        currentState.currentUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        event.status,
      );

      emit(
        UserState.loaded(
          users: currentState.currentUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: event.status,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            event.status,
          ),
        ),
      );
    }
  }

  /// Clear all filters
  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<UserState> emit,
  ) async {
    final currentState = state;

    if (currentState.hasData) {
      emit(
        UserState.loaded(
          users: currentState.currentUsers,
          filteredUsers: currentState.currentUsers,
          searchQuery: '',
          selectedRole: 'all',
          selectedStatus: 'all',
          isFiltered: false,
        ),
      );
    }
  }

  /// Create new user
  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      final currentState = state;

      emit(
        UserState.performingOperation(
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
          operationType: 'create',
        ),
      );

      final newUser = await _repository.createUser(
        fullName: event.fullName,
        email: event.email,
        password: event.password,
        role: event.role,
        createdBy: event.createdBy,
        permissions: event.permissions,
      );

      // Add new user to the beginning of the list
      final updatedUsers = [newUser, ...currentState.currentUsers];
      final filteredUsers = _applyFilters(
        updatedUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: updatedUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to create user - $e');
      _lastFailedOperation = event;
      final currentState = state;
      emit(
        UserState.error(
          message: e.toString(),
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'createUser',
        ),
      );
    }
  }

  /// Update existing user
  Future<void> _onUpdateUser(UpdateUser event, Emitter<UserState> emit) async {
    try {
      final currentState = state;

      emit(
        UserState.performingOperation(
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
          operationType: 'update',
        ),
      );

      await _repository.updateUser(event.user, event.updatedBy);

      // Update user in the list
      final updatedUsers = currentState.currentUsers.map((user) {
        return user.id == event.user.id ? event.user : user;
      }).toList();

      final filteredUsers = _applyFilters(
        updatedUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: updatedUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to update user - $e');
      _lastFailedOperation = event;
      final currentState = state;
      emit(
        UserState.error(
          message: e.toString(),
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'updateUser',
        ),
      );
    }
  }

  /// Update user status
  Future<void> _onUpdateUserStatus(
    UpdateUserStatus event,
    Emitter<UserState> emit,
  ) async {
    try {
      final currentState = state;

      // Don't show loading for quick operations
      await _repository.updateUserStatus(
        event.userId,
        event.status,
        event.updatedBy,
      );

      // Update user status in the list
      final updatedUsers = currentState.currentUsers.map((user) {
        return user.id == event.userId
            ? user.copyWith(status: event.status)
            : user;
      }).toList();

      final filteredUsers = _applyFilters(
        updatedUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: updatedUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to update user status - $e');
      _lastFailedOperation = event;
      final currentState = state;
      emit(
        UserState.error(
          message: e.toString(),
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'updateUserStatus',
        ),
      );
    }
  }

  /// Update user permissions
  Future<void> _onUpdateUserPermissions(
    UpdateUserPermissions event,
    Emitter<UserState> emit,
  ) async {
    try {
      final currentState = state;

      emit(
        UserState.performingOperation(
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
          operationType: 'updatePermissions',
        ),
      );

      await _repository.updateUserPermissions(
        event.userId,
        event.permissions,
        event.updatedBy,
      );

      // Update user permissions in the list
      final updatedUsers = currentState.currentUsers.map((user) {
        return user.id == event.userId
            ? user.copyWith(permissions: event.permissions)
            : user;
      }).toList();

      final filteredUsers = _applyFilters(
        updatedUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: updatedUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to update user permissions - $e');
      _lastFailedOperation = event;
      final currentState = state;
      emit(
        UserState.error(
          message: e.toString(),
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'updateUserPermissions',
        ),
      );
    }
  }

  /// Delete user
  Future<void> _onDeleteUser(DeleteUser event, Emitter<UserState> emit) async {
    try {
      final currentState = state;

      emit(
        UserState.performingOperation(
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
          operationType: 'delete',
        ),
      );

      await _repository.deleteUser(event.userId, event.deletedBy);

      // Remove user from the list
      final updatedUsers = currentState.currentUsers
          .where((user) => user.id != event.userId)
          .toList();
      final filteredUsers = _applyFilters(
        updatedUsers,
        currentState.currentSearchQuery,
        currentState.currentSelectedRole,
        currentState.currentSelectedStatus,
      );

      emit(
        UserState.loaded(
          users: updatedUsers,
          filteredUsers: filteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          isFiltered: _isFiltered(
            currentState.currentSearchQuery,
            currentState.currentSelectedRole,
            currentState.currentSelectedStatus,
          ),
        ),
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to delete user - $e');
      _lastFailedOperation = event;
      final currentState = state;
      emit(
        UserState.error(
          message: e.toString(),
          users: currentState.currentUsers,
          filteredUsers: currentState.currentFilteredUsers,
          searchQuery: currentState.currentSearchQuery,
          selectedRole: currentState.currentSelectedRole,
          selectedStatus: currentState.currentSelectedStatus,
          canRetry: true,
          lastFailedOperation: 'deleteUser',
        ),
      );
    }
  }

  /// Sync Firebase Auth users
  Future<void> _onSyncFirebaseAuthUsers(
    SyncFirebaseAuthUsers event,
    Emitter<UserState> emit,
  ) async {
    try {
      final currentState = state;

      if (!event.silent) {
        emit(
          UserState.syncing(
            users: currentState.currentUsers,
            filteredUsers: currentState.currentFilteredUsers,
            searchQuery: currentState.currentSearchQuery,
            selectedRole: currentState.currentSelectedRole,
            selectedStatus: currentState.currentSelectedStatus,
            isFiltered: _isFiltered(
              currentState.currentSearchQuery,
              currentState.currentSelectedRole,
              currentState.currentSelectedStatus,
            ),
          ),
        );
      }

      await _repository.syncFirebaseAuthUsers(silent: event.silent);

      // Refresh users after sync
      if (!event.silent) {
        final users = await _repository.getAllUsers();
        final filteredUsers = _applyFilters(
          users,
          currentState.currentSearchQuery,
          currentState.currentSelectedRole,
          currentState.currentSelectedStatus,
        );

        emit(
          UserState.loaded(
            users: users,
            filteredUsers: filteredUsers,
            searchQuery: currentState.currentSearchQuery,
            selectedRole: currentState.currentSelectedRole,
            selectedStatus: currentState.currentSelectedStatus,
            isFiltered: _isFiltered(
              currentState.currentSearchQuery,
              currentState.currentSelectedRole,
              currentState.currentSelectedStatus,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to sync Firebase Auth users - $e');
      _lastFailedOperation = event;
      final currentState = state;
      if (!event.silent) {
        emit(
          UserState.error(
            message: e.toString(),
            users: currentState.currentUsers,
            filteredUsers: currentState.currentFilteredUsers,
            searchQuery: currentState.currentSearchQuery,
            selectedRole: currentState.currentSelectedRole,
            selectedStatus: currentState.currentSelectedStatus,
            canRetry: true,
            lastFailedOperation: 'syncFirebaseAuthUsers',
          ),
        );
      }
    }
  }

  /// Clear error state
  Future<void> _onClearError(ClearError event, Emitter<UserState> emit) async {
    final currentState = state;

    if (currentState is UserError && currentState.users != null) {
      emit(
        UserState.loaded(
          users: currentState.users!,
          filteredUsers: currentState.filteredUsers ?? currentState.users!,
          searchQuery: currentState.searchQuery,
          selectedRole: currentState.selectedRole,
          selectedStatus: currentState.selectedStatus,
          isFiltered: currentState.isFiltered,
        ),
      );
    }
  }

  /// Retry last failed operation
  Future<void> _onRetryLastOperation(
    RetryLastOperation event,
    Emitter<UserState> emit,
  ) async {
    if (_lastFailedOperation != null) {
      debugPrint(
        '🔄 UserBloc: Retrying last failed operation: ${_lastFailedOperation.runtimeType}',
      );
      add(_lastFailedOperation!);
      _lastFailedOperation = null;
    }
  }

  /// Setup real-time users stream
  void _setupUsersStream() {
    _usersStreamSubscription?.cancel();

    try {
      _usersStreamSubscription = _repository.getUsersStream().listen(
        (users) {
          if (!isClosed) {
            final currentState = state;
            if (currentState.hasData) {
              final filteredUsers = _applyFilters(
                users,
                currentState.currentSearchQuery,
                currentState.currentSelectedRole,
                currentState.currentSelectedStatus,
              );

              emit(
                UserState.loaded(
                  users: users,
                  filteredUsers: filteredUsers,
                  searchQuery: currentState.currentSearchQuery,
                  selectedRole: currentState.currentSelectedRole,
                  selectedStatus: currentState.currentSelectedStatus,
                  isFiltered: _isFiltered(
                    currentState.currentSearchQuery,
                    currentState.currentSelectedRole,
                    currentState.currentSelectedStatus,
                  ),
                ),
              );
            }
          }
        },
        onError: (error) {
          debugPrint('❌ UserBloc: Users stream error - $error');
          if (!isClosed) {
            final currentState = state;
            emit(
              UserState.error(
                message: 'Real-time updates failed: $error',
                users: currentState.currentUsers,
                filteredUsers: currentState.currentFilteredUsers,
                searchQuery: currentState.currentSearchQuery,
                selectedRole: currentState.currentSelectedRole,
                selectedStatus: currentState.currentSelectedStatus,
                canRetry: false,
              ),
            );
          }
        },
      );
    } catch (e) {
      debugPrint('❌ UserBloc: Failed to setup users stream - $e');
    }
  }

  /// Apply filters to users list
  List<UserModel> _applyFilters(
    List<UserModel> users,
    String searchQuery,
    String selectedRole,
    String selectedStatus,
  ) {
    return users.where((user) {
      // Search filter
      bool matchesSearch =
          searchQuery.isEmpty ||
          user.fullName.toLowerCase().contains(searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(searchQuery.toLowerCase());

      // Role filter
      bool matchesRole = selectedRole == 'all' || user.role == selectedRole;

      // Status filter
      bool matchesStatus =
          selectedStatus == 'all' || user.status == selectedStatus;

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();
  }

  /// Check if any filters are applied
  bool _isFiltered(
    String searchQuery,
    String selectedRole,
    String selectedStatus,
  ) {
    return searchQuery.isNotEmpty ||
        selectedRole != 'all' ||
        selectedStatus != 'all';
  }

  /// Get user statistics from current state
  Map<String, int> get userStatistics {
    final users = state.currentUsers;
    return {
      'total': users.length,
      'active': users.where((u) => u.status == 'active').length,
      'inactive': users.where((u) => u.status == 'inactive').length,
      'admin': users.where((u) => u.role == 'admin').length,
      'user': users.where((u) => u.role == 'user').length,
    };
  }

  /// Get user by ID from current state
  UserModel? getUserById(String userId) {
    final users = state.currentUsers;
    try {
      return users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  /// Get users by role from current state
  List<UserModel> getUsersByRole(String role) {
    final users = state.currentUsers;
    return users.where((user) => user.role == role).toList();
  }

  /// Get users by status from current state
  List<UserModel> getUsersByStatus(String status) {
    final users = state.currentUsers;
    return users.where((user) => user.status == status).toList();
  }

  @override
  Future<void> close() {
    _searchDebounceTimer?.cancel();
    _usersStreamSubscription?.cancel();
    return super.close();
  }
}
