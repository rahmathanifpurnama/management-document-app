import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../models/user_model.dart';

part 'user_state.freezed.dart';

/// States for User BLoC
/// Represents all possible states during user operations
@freezed
class UserState with _$UserState {
  /// Initial state when BLoC is first created
  const factory UserState.initial() = UserInitial;

  /// Loading state for general operations
  const factory UserState.loading() = UserLoading;

  /// State when users are successfully loaded
  const factory UserState.loaded({
    required List<UserModel> users,
    required List<UserModel> filteredUsers,
    @Default('') String searchQuery,
    @Default('all') String selectedRole,
    @Default('all') String selectedStatus,
    @Default(false) bool isFiltered,
  }) = UserLoaded;

  /// State when performing specific operations (create, update, delete)
  const factory UserState.performingOperation({
    required List<UserModel> users,
    required List<UserModel> filteredUsers,
    @Default('') String searchQuery,
    @Default('all') String selectedRole,
    @Default('all') String selectedStatus,
    @Default(false) bool isFiltered,
    required String operationType,
  }) = UserPerformingOperation;

  /// State when syncing Firebase Auth users
  const factory UserState.syncing({
    required List<UserModel> users,
    required List<UserModel> filteredUsers,
    @Default('') String searchQuery,
    @Default('all') String selectedRole,
    @Default('all') String selectedStatus,
    @Default(false) bool isFiltered,
  }) = UserSyncing;

  /// Error state with error message and optional retry capability
  const factory UserState.error({
    required String message,
    List<UserModel>? users,
    List<UserModel>? filteredUsers,
    @Default('') String searchQuery,
    @Default('all') String selectedRole,
    @Default('all') String selectedStatus,
    @Default(false) bool isFiltered,
    @Default(false) bool canRetry,
    String? lastFailedOperation,
  }) = UserError;
}

/// Extension to provide convenient getters for UserState
extension UserStateExtension on UserState {
  /// Check if state is loading
  bool get isLoading => when(
    initial: () => false,
    loading: () => true,
    loaded: (_, __, ___, ____, _____, ______) => false,
    performingOperation: (_, __, ___, ____, _____, ______, _______) => true,
    syncing: (_, __, ___, ____, _____, ______) => true,
    error: (_, __, ___, ____, _____, ______, _______, ________) => false,
  );

  /// Check if state has data
  bool get hasData => when(
    initial: () => false,
    loading: () => false,
    loaded: (_, __, ___, ____, _____, ______) => true,
    performingOperation: (_, __, ___, ____, _____, ______, _______) => true,
    syncing: (_, __, ___, ____, _____, ______) => true,
    error: (_, users, __, ___, ____, _____, ______, _______) => users != null,
  );

  /// Get current users list
  List<UserModel> get currentUsers => when(
    initial: () => [],
    loading: () => [],
    loaded: (users, _, __, ___, ____, _____) => users,
    performingOperation: (users, _, __, ___, ____, _____, ______) => users,
    syncing: (users, _, __, ___, ____, _____) => users,
    error: (_, users, __, ___, ____, _____, ______, _______) => users ?? [],
  );

  /// Get current filtered users list
  List<UserModel> get currentFilteredUsers => when(
    initial: () => [],
    loading: () => [],
    loaded: (_, filteredUsers, __, ___, ____, _____) => filteredUsers,
    performingOperation: (_, filteredUsers, __, ___, ____, _____, ______) =>
        filteredUsers,
    syncing: (_, filteredUsers, __, ___, ____, _____) => filteredUsers,
    error: (_, __, filteredUsers, ___, ____, _____, ______, _______) =>
        filteredUsers ?? [],
  );

  /// Get current search query
  String get currentSearchQuery => when(
    initial: () => '',
    loading: () => '',
    loaded: (_, __, searchQuery, ___, ____, _____) => searchQuery,
    performingOperation: (_, __, searchQuery, ___, ____, _____, ______) =>
        searchQuery,
    syncing: (_, __, searchQuery, ___, ____, _____) => searchQuery,
    error: (_, __, ___, searchQuery, ____, _____, ______, _______) =>
        searchQuery,
  );

  /// Get current selected role
  String get currentSelectedRole => when(
    initial: () => 'all',
    loading: () => 'all',
    loaded: (_, __, ___, selectedRole, ____, _____) => selectedRole,
    performingOperation: (_, __, ___, selectedRole, ____, _____, ______) =>
        selectedRole,
    syncing: (_, __, ___, selectedRole, ____, _____) => selectedRole,
    error: (_, __, ___, ____, selectedRole, _____, ______, _______) =>
        selectedRole,
  );

  /// Get current selected status
  String get currentSelectedStatus => when(
    initial: () => 'all',
    loading: () => 'all',
    loaded: (_, __, ___, ____, selectedStatus, _____) => selectedStatus,
    performingOperation: (_, __, ___, ____, selectedStatus, _____, ______) =>
        selectedStatus,
    syncing: (_, __, ___, ____, selectedStatus, _____) => selectedStatus,
    error: (_, __, ___, ____, _____, selectedStatus, ______, _______) =>
        selectedStatus,
  );
}
