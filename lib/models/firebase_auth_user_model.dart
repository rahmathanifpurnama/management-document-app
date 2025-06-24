import 'package:cloud_firestore/cloud_firestore.dart';

/// Model for Firebase Auth user data
class FirebaseAuthUserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final bool emailVerified;
  final bool disabled;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  const FirebaseAuthUserModel({
    required this.uid,
    this.email,
    this.displayName,
    required this.emailVerified,
    required this.disabled,
    this.creationTime,
    this.lastSignInTime,
  });

  /// Create from Firebase Auth user data
  factory FirebaseAuthUserModel.fromMap(Map<String, dynamic> map) {
    return FirebaseAuthUserModel(
      uid: map['uid'] as String,
      email: map['email'] as String?,
      displayName: map['displayName'] as String?,
      emailVerified: map['emailVerified'] as bool? ?? false,
      disabled: map['disabled'] as bool? ?? false,
      creationTime: map['metadata']?['creationTime'] != null
          ? DateTime.parse(map['metadata']['creationTime'] as String)
          : null,
      lastSignInTime: map['metadata']?['lastSignInTime'] != null
          ? DateTime.parse(map['metadata']['lastSignInTime'] as String)
          : null,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'emailVerified': emailVerified,
      'disabled': disabled,
      'metadata': {
        'creationTime': creationTime?.toIso8601String(),
        'lastSignInTime': lastSignInTime?.toIso8601String(),
      },
    };
  }

  @override
  String toString() {
    return 'FirebaseAuthUserModel(uid: $uid, email: $email, displayName: $displayName, emailVerified: $emailVerified, disabled: $disabled)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirebaseAuthUserModel && other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}

/// Combined model for Firebase Auth user with Firestore user data
class CombinedUserModel {
  final FirebaseAuthUserModel authUser;
  final Map<String, dynamic>? firestoreUser;

  const CombinedUserModel({
    required this.authUser,
    this.firestoreUser,
  });

  /// Check if user exists in Firestore
  bool get existsInFirestore => firestoreUser != null;

  /// Get display name from either source
  String get displayName {
    if (firestoreUser != null && firestoreUser!['fullName'] != null) {
      return firestoreUser!['fullName'] as String;
    }
    if (authUser.displayName != null && authUser.displayName!.isNotEmpty) {
      return authUser.displayName!;
    }
    if (authUser.email != null) {
      return authUser.email!.split('@').first;
    }
    return 'Unknown User';
  }

  /// Get email from either source
  String get email {
    if (firestoreUser != null && firestoreUser!['email'] != null) {
      return firestoreUser!['email'] as String;
    }
    return authUser.email ?? '';
  }

  /// Get role from Firestore or default
  String get role {
    if (firestoreUser != null && firestoreUser!['role'] != null) {
      return firestoreUser!['role'] as String;
    }
    return 'user'; // Default role
  }

  /// Get status from Firestore or derive from auth
  String get status {
    if (firestoreUser != null && firestoreUser!['status'] != null) {
      return firestoreUser!['status'] as String;
    }
    return authUser.disabled ? 'inactive' : 'active';
  }

  /// Check if user is active
  bool get isActive {
    if (firestoreUser != null && firestoreUser!['isActive'] != null) {
      return firestoreUser!['isActive'] as bool;
    }
    return !authUser.disabled;
  }

  /// Create from Cloud Function response
  factory CombinedUserModel.fromMap(Map<String, dynamic> map) {
    return CombinedUserModel(
      authUser: FirebaseAuthUserModel.fromMap(map['authUser'] as Map<String, dynamic>),
      firestoreUser: map['firestoreUser'] as Map<String, dynamic>?,
    );
  }

  /// Convert to map
  Map<String, dynamic> toMap() {
    return {
      'authUser': authUser.toMap(),
      'firestoreUser': firestoreUser,
    };
  }

  @override
  String toString() {
    return 'CombinedUserModel(authUser: $authUser, existsInFirestore: $existsInFirestore)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CombinedUserModel && other.authUser.uid == authUser.uid;
  }

  @override
  int get hashCode => authUser.uid.hashCode;
}
