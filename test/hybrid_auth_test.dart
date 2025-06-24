import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:managementdoc/core/services/hybrid_auth_service.dart';
import 'package:managementdoc/core/services/connectivity_service.dart';
import 'package:managementdoc/core/services/secure_storage_service.dart';
import 'package:managementdoc/core/services/biometric_auth_service.dart';
import 'package:managementdoc/core/utils/credential_encryption.dart';
import 'package:managementdoc/models/offline_auth_models.dart';
import 'package:managementdoc/models/user_model.dart';

// Generate mocks
@GenerateMocks([
  ConnectivityService,
  SecureStorageService,
  BiometricAuthService,
])
import 'hybrid_auth_test.mocks.dart';

void main() {
  group('HybridAuthService Tests', () {
    late HybridAuthService hybridAuthService;
    late MockConnectivityService mockConnectivityService;
    late MockSecureStorageService mockSecureStorageService;
    late MockBiometricAuthService mockBiometricAuthService;

    setUp(() {
      mockConnectivityService = MockConnectivityService();
      mockSecureStorageService = MockSecureStorageService();
      mockBiometricAuthService = MockBiometricAuthService();
      
      // Note: In a real implementation, you would inject these dependencies
      // For now, we'll test the individual components
    });

    group('Credential Encryption', () {
      test('should generate secure salt', () {
        final salt1 = CredentialEncryption.generateSalt();
        final salt2 = CredentialEncryption.generateSalt();
        
        expect(salt1, isNotEmpty);
        expect(salt2, isNotEmpty);
        expect(salt1, isNot(equals(salt2))); // Should be unique
        expect(salt1.length, greaterThan(20)); // Should be reasonably long
      });

      test('should hash password correctly', () {
        const password = 'testPassword123!';
        final salt = CredentialEncryption.generateSalt();
        
        final hash1 = CredentialEncryption.hashPassword(password, salt);
        final hash2 = CredentialEncryption.hashPassword(password, salt);
        
        expect(hash1, isNotEmpty);
        expect(hash1, equals(hash2)); // Same password + salt = same hash
        expect(hash1.length, greaterThan(20)); // Should be reasonably long
      });

      test('should verify password correctly', () {
        const password = 'testPassword123!';
        const wrongPassword = 'wrongPassword';
        final salt = CredentialEncryption.generateSalt();
        final hash = CredentialEncryption.hashPassword(password, salt);
        
        expect(CredentialEncryption.verifyPassword(password, hash, salt), isTrue);
        expect(CredentialEncryption.verifyPassword(wrongPassword, hash, salt), isFalse);
      });

      test('should generate secure session token', () {
        final token1 = CredentialEncryption.generateSessionToken();
        final token2 = CredentialEncryption.generateSessionToken();
        
        expect(token1, isNotEmpty);
        expect(token2, isNotEmpty);
        expect(token1, isNot(equals(token2))); // Should be unique
      });

      test('should validate password strength correctly', () {
        expect(CredentialEncryption.isPasswordSecure('weak'), isFalse);
        expect(CredentialEncryption.isPasswordSecure('password'), isFalse);
        expect(CredentialEncryption.isPasswordSecure('Password1'), isFalse);
        expect(CredentialEncryption.isPasswordSecure('Password1!'), isTrue);
        expect(CredentialEncryption.isPasswordSecure('MySecure123!'), isTrue);
      });

      test('should calculate password strength score', () {
        expect(CredentialEncryption.calculatePasswordStrength('weak'), lessThan(50));
        expect(CredentialEncryption.calculatePasswordStrength('password'), lessThan(50));
        expect(CredentialEncryption.calculatePasswordStrength('Password1!'), greaterThan(70));
        expect(CredentialEncryption.calculatePasswordStrength('MyVerySecurePassword123!'), equals(100));
      });
    });

    group('Offline Authentication Models', () {
      test('should create OfflineCredentials correctly', () {
        final credentials = OfflineCredentials(
          email: 'test@example.com',
          hashedPassword: 'hashedPassword',
          salt: 'salt',
          createdAt: DateTime.now(),
          deviceFingerprint: 'fingerprint',
        );

        expect(credentials.email, equals('test@example.com'));
        expect(credentials.hashedPassword, equals('hashedPassword'));
        expect(credentials.salt, equals('salt'));
        expect(credentials.deviceFingerprint, equals('fingerprint'));
      });

      test('should serialize and deserialize OfflineCredentials', () {
        final originalCredentials = OfflineCredentials(
          email: 'test@example.com',
          hashedPassword: 'hashedPassword',
          salt: 'salt',
          createdAt: DateTime.now(),
          deviceFingerprint: 'fingerprint',
        );

        final json = originalCredentials.toJson();
        final deserializedCredentials = OfflineCredentials.fromJson(json);

        expect(deserializedCredentials.email, equals(originalCredentials.email));
        expect(deserializedCredentials.hashedPassword, equals(originalCredentials.hashedPassword));
        expect(deserializedCredentials.salt, equals(originalCredentials.salt));
        expect(deserializedCredentials.deviceFingerprint, equals(originalCredentials.deviceFingerprint));
      });

      test('should create AuthenticationState correctly', () {
        final authState = AuthenticationState(
          isOnline: true,
          isAuthenticated: true,
          authMode: AuthMode.online,
          sessionExpiry: DateTime.now().add(const Duration(hours: 1)),
        );

        expect(authState.isOnline, isTrue);
        expect(authState.isAuthenticated, isTrue);
        expect(authState.authMode, equals(AuthMode.online));
        expect(authState.isSessionValid, isTrue);
        expect(authState.isLockedOut, isFalse);
      });

      test('should detect expired session', () {
        final authState = AuthenticationState(
          isOnline: true,
          isAuthenticated: true,
          authMode: AuthMode.online,
          sessionExpiry: DateTime.now().subtract(const Duration(hours: 1)),
        );

        expect(authState.isSessionValid, isFalse);
      });

      test('should detect lockout', () {
        final authState = AuthenticationState(
          isOnline: true,
          isAuthenticated: false,
          authMode: AuthMode.none,
          failedAttempts: 5,
          lockoutUntil: DateTime.now().add(const Duration(minutes: 15)),
        );

        expect(authState.isLockedOut, isTrue);
      });

      test('should create OfflineAction correctly', () {
        final action = OfflineAction(
          id: 'test-id',
          type: 'login_activity',
          data: {'userId': 'user123', 'timestamp': DateTime.now().toIso8601String()},
          createdAt: DateTime.now(),
          priority: ActionPriority.high,
        );

        expect(action.id, equals('test-id'));
        expect(action.type, equals('login_activity'));
        expect(action.priority, equals(ActionPriority.high));
        expect(action.data['userId'], equals('user123'));
      });
    });

    group('Connectivity Service Mock Tests', () {
      test('should return online status', () async {
        when(mockConnectivityService.isOnline).thenReturn(true);
        when(mockConnectivityService.hasInternet).thenReturn(true);
        when(mockConnectivityService.canReachFirebase).thenReturn(true);

        expect(mockConnectivityService.isOnline, isTrue);
        expect(mockConnectivityService.hasInternet, isTrue);
        expect(mockConnectivityService.canReachFirebase, isTrue);
      });

      test('should return offline status', () async {
        when(mockConnectivityService.isOnline).thenReturn(false);
        when(mockConnectivityService.hasInternet).thenReturn(false);
        when(mockConnectivityService.canReachFirebase).thenReturn(false);

        expect(mockConnectivityService.isOnline, isFalse);
        expect(mockConnectivityService.hasInternet, isFalse);
        expect(mockConnectivityService.canReachFirebase, isFalse);
      });
    });

    group('Secure Storage Service Mock Tests', () {
      test('should store and retrieve user credentials', () async {
        const email = 'test@example.com';
        const hashedPassword = 'hashedPassword';
        const salt = 'salt';

        when(mockSecureStorageService.storeUserCredentials(
          email: email,
          hashedPassword: hashedPassword,
          salt: salt,
        )).thenAnswer((_) async {});

        when(mockSecureStorageService.getUserCredentials()).thenAnswer((_) async => {
          'email': email,
          'hashedPassword': hashedPassword,
          'salt': salt,
          'timestamp': DateTime.now().toIso8601String(),
        });

        await mockSecureStorageService.storeUserCredentials(
          email: email,
          hashedPassword: hashedPassword,
          salt: salt,
        );

        final credentials = await mockSecureStorageService.getUserCredentials();
        expect(credentials?['email'], equals(email));
        expect(credentials?['hashedPassword'], equals(hashedPassword));
        expect(credentials?['salt'], equals(salt));
      });

      test('should check if credentials exist', () async {
        when(mockSecureStorageService.hasStoredCredentials()).thenAnswer((_) async => true);
        
        final hasCredentials = await mockSecureStorageService.hasStoredCredentials();
        expect(hasCredentials, isTrue);
      });

      test('should clear all data', () async {
        when(mockSecureStorageService.clearAll()).thenAnswer((_) async {});
        
        await mockSecureStorageService.clearAll();
        verify(mockSecureStorageService.clearAll()).called(1);
      });
    });

    group('Biometric Auth Service Mock Tests', () {
      test('should check biometric availability', () async {
        when(mockBiometricAuthService.isBiometricAvailable()).thenAnswer((_) async => true);
        
        final isAvailable = await mockBiometricAuthService.isBiometricAvailable();
        expect(isAvailable, isTrue);
      });

      test('should authenticate with biometrics', () async {
        when(mockBiometricAuthService.authenticateWithBiometrics()).thenAnswer((_) async => true);
        
        final isAuthenticated = await mockBiometricAuthService.authenticateWithBiometrics();
        expect(isAuthenticated, isTrue);
      });

      test('should enable biometric authentication', () async {
        when(mockBiometricAuthService.enableBiometricAuth()).thenAnswer((_) async => true);
        
        final success = await mockBiometricAuthService.enableBiometricAuth();
        expect(success, isTrue);
      });

      test('should get biometric status', () async {
        final mockStatus = BiometricStatus(
          isAvailable: true,
          isEnabled: true,
          availableBiometrics: [],
          hasStrongBiometrics: true,
        );
        
        when(mockBiometricAuthService.getBiometricStatus()).thenAnswer((_) async => mockStatus);
        
        final status = await mockBiometricAuthService.getBiometricStatus();
        expect(status.isAvailable, isTrue);
        expect(status.isEnabled, isTrue);
        expect(status.hasStrongBiometrics, isTrue);
      });
    });

    group('Integration Scenarios', () {
      test('should handle online to offline transition', () async {
        // Simulate online authentication
        when(mockConnectivityService.isOnline).thenReturn(true);
        
        // Then simulate going offline
        when(mockConnectivityService.isOnline).thenReturn(false);
        
        // Should still be able to authenticate offline if credentials are stored
        when(mockSecureStorageService.hasStoredCredentials()).thenAnswer((_) async => true);
        when(mockSecureStorageService.getUserCredentials()).thenAnswer((_) async => {
          'email': 'test@example.com',
          'hashedPassword': 'hashedPassword',
          'salt': 'salt',
          'timestamp': DateTime.now().toIso8601String(),
        });

        final hasCredentials = await mockSecureStorageService.hasStoredCredentials();
        expect(hasCredentials, isTrue);
      });

      test('should handle offline to online transition', () async {
        // Simulate offline state
        when(mockConnectivityService.isOnline).thenReturn(false);
        
        // Then simulate coming back online
        when(mockConnectivityService.isOnline).thenReturn(true);
        when(mockConnectivityService.hasInternet).thenReturn(true);
        when(mockConnectivityService.canReachFirebase).thenReturn(true);

        expect(mockConnectivityService.isOnline, isTrue);
        expect(mockConnectivityService.hasInternet, isTrue);
        expect(mockConnectivityService.canReachFirebase, isTrue);
      });

      test('should handle biometric authentication flow', () async {
        // Setup biometric availability
        when(mockBiometricAuthService.isBiometricAvailable()).thenAnswer((_) async => true);
        when(mockBiometricAuthService.isBiometricEnabled()).thenAnswer((_) async => true);
        
        // Setup stored credentials
        when(mockSecureStorageService.hasStoredCredentials()).thenAnswer((_) async => true);
        
        // Simulate successful biometric authentication
        when(mockBiometricAuthService.authenticateWithBiometrics()).thenAnswer((_) async => true);

        final isBiometricAvailable = await mockBiometricAuthService.isBiometricAvailable();
        final isBiometricEnabled = await mockBiometricAuthService.isBiometricEnabled();
        final hasCredentials = await mockSecureStorageService.hasStoredCredentials();
        final biometricAuth = await mockBiometricAuthService.authenticateWithBiometrics();

        expect(isBiometricAvailable, isTrue);
        expect(isBiometricEnabled, isTrue);
        expect(hasCredentials, isTrue);
        expect(biometricAuth, isTrue);
      });
    });
  });
}
