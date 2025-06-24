import 'dart:convert';

/// Model for storing offline user credentials securely
class OfflineCredentials {
  final String email;
  final String hashedPassword;
  final String salt;
  final DateTime createdAt;
  final DateTime? lastUsed;
  final String deviceFingerprint;

  OfflineCredentials({
    required this.email,
    required this.hashedPassword,
    required this.salt,
    required this.createdAt,
    this.lastUsed,
    required this.deviceFingerprint,
  });

  /// Create from JSON map
  factory OfflineCredentials.fromJson(Map<String, dynamic> json) {
    return OfflineCredentials(
      email: json['email'] as String,
      hashedPassword: json['hashedPassword'] as String,
      salt: json['salt'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsed: json['lastUsed'] != null 
          ? DateTime.parse(json['lastUsed'] as String) 
          : null,
      deviceFingerprint: json['deviceFingerprint'] as String,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'hashedPassword': hashedPassword,
      'salt': salt,
      'createdAt': createdAt.toIso8601String(),
      'lastUsed': lastUsed?.toIso8601String(),
      'deviceFingerprint': deviceFingerprint,
    };
  }

  /// Create a copy with updated fields
  OfflineCredentials copyWith({
    String? email,
    String? hashedPassword,
    String? salt,
    DateTime? createdAt,
    DateTime? lastUsed,
    String? deviceFingerprint,
  }) {
    return OfflineCredentials(
      email: email ?? this.email,
      hashedPassword: hashedPassword ?? this.hashedPassword,
      salt: salt ?? this.salt,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      deviceFingerprint: deviceFingerprint ?? this.deviceFingerprint,
    );
  }

  @override
  String toString() {
    return 'OfflineCredentials(email: $email, createdAt: $createdAt, lastUsed: $lastUsed)';
  }
}

/// Model for authentication state management
class AuthenticationState {
  final bool isOnline;
  final bool isAuthenticated;
  final AuthMode authMode;
  final DateTime? lastOnlineAuth;
  final DateTime? lastOfflineAuth;
  final String? sessionToken;
  final DateTime? sessionExpiry;
  final bool biometricEnabled;
  final int failedAttempts;
  final DateTime? lockoutUntil;

  AuthenticationState({
    required this.isOnline,
    required this.isAuthenticated,
    required this.authMode,
    this.lastOnlineAuth,
    this.lastOfflineAuth,
    this.sessionToken,
    this.sessionExpiry,
    this.biometricEnabled = false,
    this.failedAttempts = 0,
    this.lockoutUntil,
  });

  /// Create from JSON map
  factory AuthenticationState.fromJson(Map<String, dynamic> json) {
    return AuthenticationState(
      isOnline: json['isOnline'] as bool,
      isAuthenticated: json['isAuthenticated'] as bool,
      authMode: AuthMode.values.firstWhere(
        (mode) => mode.name == json['authMode'],
        orElse: () => AuthMode.none,
      ),
      lastOnlineAuth: json['lastOnlineAuth'] != null
          ? DateTime.parse(json['lastOnlineAuth'] as String)
          : null,
      lastOfflineAuth: json['lastOfflineAuth'] != null
          ? DateTime.parse(json['lastOfflineAuth'] as String)
          : null,
      sessionToken: json['sessionToken'] as String?,
      sessionExpiry: json['sessionExpiry'] != null
          ? DateTime.parse(json['sessionExpiry'] as String)
          : null,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      failedAttempts: json['failedAttempts'] as int? ?? 0,
      lockoutUntil: json['lockoutUntil'] != null
          ? DateTime.parse(json['lockoutUntil'] as String)
          : null,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'isOnline': isOnline,
      'isAuthenticated': isAuthenticated,
      'authMode': authMode.name,
      'lastOnlineAuth': lastOnlineAuth?.toIso8601String(),
      'lastOfflineAuth': lastOfflineAuth?.toIso8601String(),
      'sessionToken': sessionToken,
      'sessionExpiry': sessionExpiry?.toIso8601String(),
      'biometricEnabled': biometricEnabled,
      'failedAttempts': failedAttempts,
      'lockoutUntil': lockoutUntil?.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  AuthenticationState copyWith({
    bool? isOnline,
    bool? isAuthenticated,
    AuthMode? authMode,
    DateTime? lastOnlineAuth,
    DateTime? lastOfflineAuth,
    String? sessionToken,
    DateTime? sessionExpiry,
    bool? biometricEnabled,
    int? failedAttempts,
    DateTime? lockoutUntil,
  }) {
    return AuthenticationState(
      isOnline: isOnline ?? this.isOnline,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      authMode: authMode ?? this.authMode,
      lastOnlineAuth: lastOnlineAuth ?? this.lastOnlineAuth,
      lastOfflineAuth: lastOfflineAuth ?? this.lastOfflineAuth,
      sessionToken: sessionToken ?? this.sessionToken,
      sessionExpiry: sessionExpiry ?? this.sessionExpiry,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: lockoutUntil ?? this.lockoutUntil,
    );
  }

  /// Check if session is valid
  bool get isSessionValid {
    if (sessionToken == null || sessionExpiry == null) return false;
    return DateTime.now().isBefore(sessionExpiry!);
  }

  /// Check if account is locked out
  bool get isLockedOut {
    if (lockoutUntil == null) return false;
    return DateTime.now().isBefore(lockoutUntil!);
  }

  @override
  String toString() {
    return 'AuthenticationState(isOnline: $isOnline, isAuthenticated: $isAuthenticated, authMode: $authMode)';
  }
}

/// Model for offline sync status and queued actions
class OfflineSyncStatus {
  final List<OfflineAction> pendingActions;
  final DateTime? lastSyncAttempt;
  final DateTime? lastSuccessfulSync;
  final int failedSyncAttempts;
  final SyncState syncState;
  final String? lastSyncError;

  OfflineSyncStatus({
    required this.pendingActions,
    this.lastSyncAttempt,
    this.lastSuccessfulSync,
    this.failedSyncAttempts = 0,
    this.syncState = SyncState.idle,
    this.lastSyncError,
  });

  /// Create from JSON map
  factory OfflineSyncStatus.fromJson(Map<String, dynamic> json) {
    final actionsJson = json['pendingActions'] as List<dynamic>? ?? [];
    final actions = actionsJson
        .map((actionJson) => OfflineAction.fromJson(actionJson as Map<String, dynamic>))
        .toList();

    return OfflineSyncStatus(
      pendingActions: actions,
      lastSyncAttempt: json['lastSyncAttempt'] != null
          ? DateTime.parse(json['lastSyncAttempt'] as String)
          : null,
      lastSuccessfulSync: json['lastSuccessfulSync'] != null
          ? DateTime.parse(json['lastSuccessfulSync'] as String)
          : null,
      failedSyncAttempts: json['failedSyncAttempts'] as int? ?? 0,
      syncState: SyncState.values.firstWhere(
        (state) => state.name == json['syncState'],
        orElse: () => SyncState.idle,
      ),
      lastSyncError: json['lastSyncError'] as String?,
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'pendingActions': pendingActions.map((action) => action.toJson()).toList(),
      'lastSyncAttempt': lastSyncAttempt?.toIso8601String(),
      'lastSuccessfulSync': lastSuccessfulSync?.toIso8601String(),
      'failedSyncAttempts': failedSyncAttempts,
      'syncState': syncState.name,
      'lastSyncError': lastSyncError,
    };
  }

  /// Create a copy with updated fields
  OfflineSyncStatus copyWith({
    List<OfflineAction>? pendingActions,
    DateTime? lastSyncAttempt,
    DateTime? lastSuccessfulSync,
    int? failedSyncAttempts,
    SyncState? syncState,
    String? lastSyncError,
  }) {
    return OfflineSyncStatus(
      pendingActions: pendingActions ?? this.pendingActions,
      lastSyncAttempt: lastSyncAttempt ?? this.lastSyncAttempt,
      lastSuccessfulSync: lastSuccessfulSync ?? this.lastSuccessfulSync,
      failedSyncAttempts: failedSyncAttempts ?? this.failedSyncAttempts,
      syncState: syncState ?? this.syncState,
      lastSyncError: lastSyncError ?? this.lastSyncError,
    );
  }

  @override
  String toString() {
    return 'OfflineSyncStatus(pendingActions: ${pendingActions.length}, syncState: $syncState)';
  }
}

/// Model for individual offline actions
class OfflineAction {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final int retryCount;
  final DateTime? scheduledFor;
  final ActionPriority priority;

  OfflineAction({
    required this.id,
    required this.type,
    required this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.scheduledFor,
    this.priority = ActionPriority.normal,
  });

  /// Create from JSON map
  factory OfflineAction.fromJson(Map<String, dynamic> json) {
    return OfflineAction(
      id: json['id'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
      scheduledFor: json['scheduledFor'] != null
          ? DateTime.parse(json['scheduledFor'] as String)
          : null,
      priority: ActionPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => ActionPriority.normal,
      ),
    );
  }

  /// Convert to JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'data': data,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
      'scheduledFor': scheduledFor?.toIso8601String(),
      'priority': priority.name,
    };
  }

  /// Create a copy with updated fields
  OfflineAction copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? data,
    DateTime? createdAt,
    int? retryCount,
    DateTime? scheduledFor,
    ActionPriority? priority,
  }) {
    return OfflineAction(
      id: id ?? this.id,
      type: type ?? this.type,
      data: data ?? this.data,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
      scheduledFor: scheduledFor ?? this.scheduledFor,
      priority: priority ?? this.priority,
    );
  }

  @override
  String toString() {
    return 'OfflineAction(id: $id, type: $type, priority: $priority)';
  }
}

/// Enumeration for authentication modes
enum AuthMode {
  none,
  online,
  offline,
  biometric,
  hybrid,
}

/// Enumeration for sync states
enum SyncState {
  idle,
  syncing,
  completed,
  failed,
  paused,
}

/// Enumeration for action priorities
enum ActionPriority {
  low,
  normal,
  high,
  critical,
}
