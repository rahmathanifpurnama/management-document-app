import 'package:flutter/material.dart';
import 'dart:async';
import '../core/services/user_service.dart';
import '../services/cloud_functions_service.dart';
import '../models/user_model.dart';
import '../models/firebase_auth_user_model.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService.instance;
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];
  List<CombinedUserModel> _firebaseAuthUsers = [];
  List<CombinedUserModel> _filteredFirebaseAuthUsers = [];
  bool _isLoading = false;
  bool _isLoadingFirebaseAuth = false;
  String? _errorMessage;
  String _searchQuery = '';
  String _selectedRole = 'all';
  String _selectedStatus = 'all';

  // Debouncing timer for search
  Timer? _searchDebounceTimer;

  // Getters
  List<UserModel> get users => _filteredUsers;
  List<UserModel> get allUsers => _users;
  List<CombinedUserModel> get firebaseAuthUsers => _filteredFirebaseAuthUsers;
  bool get isLoading => _isLoading;
  bool get isLoadingFirebaseAuth => _isLoadingFirebaseAuth;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;
  String get selectedRole => _selectedRole;
  String get selectedStatus => _selectedStatus;

  // Load all users with timeout and non-blocking operations
  Future<void> loadUsers() async {
    _setLoading(true);
    _clearError();

    try {
      // Add timeout to prevent hanging
      _users = await _userService.getAllUsers().timeout(
        const Duration(seconds: 10),
      );

      // Apply filters asynchronously to prevent UI blocking
      await _applyFiltersAsync();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Create new user
  Future<bool> createUser({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String createdBy,
    UserPermissions? permissions,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      UserModel newUser = await _userService.createUser(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        createdBy: createdBy,
        permissions: permissions,
      );

      _users.insert(0, newUser);
      _applyFilters();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user
  Future<bool> updateUser(UserModel user, String updatedBy) async {
    _setLoading(true);
    _clearError();

    try {
      await _userService.updateUser(user, updatedBy);

      // Update local list
      int index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        _applyFilters();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update user status with optimized loading
  Future<bool> updateUserStatus(
    String userId,
    String status,
    String updatedBy,
  ) async {
    // Don't show loading for quick operations
    _clearError();

    try {
      // Add timeout for the operation
      await _userService
          .updateUserStatus(userId, status, updatedBy)
          .timeout(const Duration(seconds: 5));

      // Update local list without blocking UI
      await Future.microtask(() {
        int index = _users.indexWhere((u) => u.id == userId);
        if (index != -1) {
          _users[index] = _users[index].copyWith(status: status);
        }
      });

      // Apply filters asynchronously
      await _applyFiltersAsync();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  // Update user permissions
  Future<bool> updateUserPermissions(
    String userId,
    UserPermissions permissions,
    String updatedBy,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _userService.updateUserPermissions(userId, permissions, updatedBy);

      // Update local list
      int index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index] = _users[index].copyWith(permissions: permissions);
        _applyFilters();
      }

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Delete user
  Future<bool> deleteUser(String userId, String deletedBy) async {
    _setLoading(true);
    _clearError();

    try {
      await _userService.deleteUser(userId, deletedBy);

      // Remove from local list
      _users.removeWhere((u) => u.id == userId);
      _applyFilters();

      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Search users with debouncing to prevent excessive filtering
  void searchUsers(String query) {
    _searchQuery = query;

    // Cancel previous timer
    _searchDebounceTimer?.cancel();

    // Set new timer for debounced search
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyFiltersAsync();
    });
  }

  // Filter by role
  void filterByRole(String role) {
    _selectedRole = role;
    _applyFilters();
  }

  // Filter by status
  void filterByStatus(String status) {
    _selectedStatus = status;
    _applyFilters();
  }

  // Apply filters asynchronously to prevent UI blocking
  Future<void> _applyFiltersAsync() async {
    // Use Future.microtask to prevent blocking the main thread
    await Future.microtask(() {
      _filteredUsers = _users.where((user) {
        // Search filter
        bool matchesSearch =
            _searchQuery.isEmpty ||
            user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            user.email.toLowerCase().contains(_searchQuery.toLowerCase());

        // Role filter
        bool matchesRole = _selectedRole == 'all' || user.role == _selectedRole;

        // Status filter
        bool matchesStatus =
            _selectedStatus == 'all' || user.status == _selectedStatus;

        return matchesSearch && matchesRole && matchesStatus;
      }).toList();
    });

    notifyListeners();
  }

  // Apply filters synchronously (for backward compatibility)
  void _applyFilters() {
    _filteredUsers = _users.where((user) {
      // Search filter
      bool matchesSearch =
          _searchQuery.isEmpty ||
          user.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          user.email.toLowerCase().contains(_searchQuery.toLowerCase());

      // Role filter
      bool matchesRole = _selectedRole == 'all' || user.role == _selectedRole;

      // Status filter
      bool matchesStatus =
          _selectedStatus == 'all' || user.status == _selectedStatus;

      return matchesSearch && matchesRole && matchesStatus;
    }).toList();

    notifyListeners();
  }

  // Clear filters
  void clearFilters() {
    _searchQuery = '';
    _selectedRole = 'all';
    _selectedStatus = 'all';
    _applyFilters();
  }

  // Get user by ID
  UserModel? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.id == userId);
    } catch (e) {
      return null;
    }
  }

  // Get users by role
  List<UserModel> getUsersByRole(String role) {
    return _users.where((user) => user.role == role).toList();
  }

  // Get active users count
  int get activeUsersCount {
    return _users.where((user) => user.status == 'active').length;
  }

  // Get inactive users count
  int get inactiveUsersCount {
    return _users.where((user) => user.status == 'inactive').length;
  }

  // Get total users count
  int get totalUsersCount {
    return _users.length;
  }

  // Get admin users count
  int get adminUsersCount {
    return _users.where((user) => user.role == 'admin').length;
  }

  // Get regular users count
  int get regularUsersCount {
    return _users.where((user) => user.role == 'user').length;
  }

  // Refresh users
  Future<void> refreshUsers({bool clearFilters = false}) async {
    if (clearFilters) {
      _searchQuery = '';
      _selectedRole = 'all';
      _selectedStatus = 'all';
    }
    await loadUsers();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }

  // Firebase Auth User Management Methods

  /// Fetch Firebase Auth users
  Future<void> fetchFirebaseAuthUsers({bool refresh = false}) async {
    if (_isLoadingFirebaseAuth && !refresh) return;

    _isLoadingFirebaseAuth = true;
    _clearError();
    notifyListeners();

    try {
      final result = await _cloudFunctions.getFirebaseAuthUsers();

      if (result['success'] == true && result['users'] != null) {
        final usersList = result['users'] as List;
        _firebaseAuthUsers = usersList
            .map(
              (user) => CombinedUserModel.fromMap(user as Map<String, dynamic>),
            )
            .toList();

        _applyFirebaseAuthFilters();
      }
    } catch (e) {
      _setError('Failed to fetch Firebase Auth users: ${e.toString()}');
    } finally {
      _isLoadingFirebaseAuth = false;
      notifyListeners();
    }
  }

  /// Sync Firebase Auth user with Firestore
  Future<bool> syncFirebaseAuthUser(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _cloudFunctions.syncFirebaseAuthUser(userId: userId);

      if (result['success'] == true) {
        // Refresh both lists
        await Future.wait([
          refreshUsers(),
          fetchFirebaseAuthUsers(refresh: true),
        ]);
        return true;
      }
      return false;
    } catch (e) {
      _setError('Failed to sync Firebase Auth user: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Apply filters to Firebase Auth users
  void _applyFirebaseAuthFilters() {
    _filteredFirebaseAuthUsers = _firebaseAuthUsers.where((user) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesName = user.displayName.toLowerCase().contains(query);
        final matchesEmail = user.email.toLowerCase().contains(query);
        if (!matchesName && !matchesEmail) return false;
      }

      // Role filter
      if (_selectedRole != 'all') {
        if (user.role != _selectedRole) return false;
      }

      // Status filter
      if (_selectedStatus != 'all') {
        if (_selectedStatus == 'active' && !user.isActive) return false;
        if (_selectedStatus == 'inactive' && user.isActive) return false;
      }

      return true;
    }).toList();
  }

  /// Search Firebase Auth users
  void searchFirebaseAuthUsers(String query) {
    _searchQuery = query;
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      _applyFirebaseAuthFilters();
      notifyListeners();
    });
  }

  /// Filter Firebase Auth users by role
  void filterFirebaseAuthUsersByRole(String role) {
    _selectedRole = role;
    _applyFirebaseAuthFilters();
    notifyListeners();
  }

  /// Filter Firebase Auth users by status
  void filterFirebaseAuthUsersByStatus(String status) {
    _selectedStatus = status;
    _applyFirebaseAuthFilters();
    notifyListeners();
  }

  /// Clear Firebase Auth filters
  void clearFirebaseAuthFilters() {
    _searchQuery = '';
    _selectedRole = 'all';
    _selectedStatus = 'all';
    _applyFirebaseAuthFilters();
    notifyListeners();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    super.dispose();
  }
}
