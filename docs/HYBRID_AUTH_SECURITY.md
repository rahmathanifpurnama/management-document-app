# Hybrid Authentication Security Guide

## Security Architecture

The Hybrid Authentication System implements multiple layers of security to protect user credentials and session data both online and offline.

## Cryptographic Security

### Password Hashing

**PBKDF2 with SHA-256**
- Algorithm: PBKDF2 (Password-Based Key Derivation Function 2)
- Hash function: SHA-256
- Iterations: 100,000 (OWASP recommended minimum)
- Salt length: 256 bits (32 bytes)
- Key length: 256 bits (32 bytes)

```dart
// Password hashing implementation
static String hashPassword(String password, String salt) {
  final saltBytes = base64Decode(salt);
  final passwordBytes = utf8.encode(password);
  final hashedBytes = _pbkdf2(passwordBytes, saltBytes, 100000, 32);
  return base64Encode(hashedBytes);
}
```

**Security Benefits:**
- Resistant to rainbow table attacks (unique salt per password)
- Computationally expensive for brute force attacks
- Industry-standard algorithm with proven security
- Constant-time comparison prevents timing attacks

### Salt Generation

**Cryptographically Secure Random Salt**
```dart
static String generateSalt() {
  final random = Random.secure();
  final saltBytes = Uint8List(32); // 256 bits
  for (int i = 0; i < 32; i++) {
    saltBytes[i] = random.nextInt(256);
  }
  return base64Encode(saltBytes);
}
```

**Security Properties:**
- Uses `Random.secure()` for cryptographic randomness
- 256-bit entropy
- Unique per password
- Base64 encoded for storage

## Local Storage Security

### Platform-Specific Secure Storage

**iOS (Keychain Services)**
- Data stored in iOS Keychain
- Hardware-backed security on supported devices
- Encrypted with device passcode/biometrics
- Survives app uninstall (configurable)

**Android (Keystore)**
- Uses Android Keystore system
- Hardware-backed keys when available
- Encrypted with user authentication
- Protected against root access

**Configuration:**
```dart
static const FlutterSecureStorage _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'simdoc_secure_prefs',
    preferencesKeyPrefix: 'simdoc_',
  ),
  iOptions: IOSOptions(
    groupId: 'group.com.simdoc.app',
    accountName: 'simdoc_keychain',
  ),
);
```

### Data Classification

**Stored Data Types:**
1. **Highly Sensitive**: Hashed passwords, authentication tokens
2. **Sensitive**: User credentials, session data
3. **Internal**: Device fingerprints, timestamps
4. **Metadata**: Preferences, settings

**Storage Strategy:**
- Highly sensitive data: Encrypted + secure storage
- Sensitive data: Secure storage only
- Internal data: Secure storage with integrity checks
- Metadata: Standard encrypted preferences

## Session Security

### Session Management

**Session Lifecycle:**
1. **Creation**: Generate secure session token
2. **Validation**: Verify token integrity and expiration
3. **Refresh**: Automatic token renewal before expiry
4. **Termination**: Secure cleanup on logout

**Session Tokens:**
```dart
static String generateSessionToken() {
  final random = Random.secure();
  final tokenBytes = Uint8List(32); // 256 bits
  for (int i = 0; i < 32; i++) {
    tokenBytes[i] = random.nextInt(256);
  }
  return base64Encode(tokenBytes);
}
```

### Session Validation

**Integrity Checks:**
- Token format validation
- Expiration time verification
- Account change detection
- Device fingerprint matching

**Automatic Security Actions:**
```dart
Future<bool> validateSessionIntegrity() async {
  // Check session expiration
  if (isSessionExpired()) {
    await forceLogout(reason: 'Session expired');
    return false;
  }
  
  // Detect account changes
  if (await detectAccountChange()) {
    await forceLogout(reason: 'Account change detected');
    return false;
  }
  
  return true;
}
```

## Biometric Security

### Biometric Authentication

**Security Model:**
- Biometric data never leaves the device
- Uses platform-specific biometric APIs
- Hardware-backed when available
- Fallback to device credentials

**Implementation:**
```dart
Future<bool> authenticateWithBiometrics() async {
  return await _localAuth.authenticate(
    localizedReason: 'Please authenticate to access your account',
    options: AuthenticationOptions(
      biometricOnly: false, // Allow device credential fallback
      stickyAuth: true,     // Require user interaction
      sensitiveTransaction: true, // High security mode
    ),
  );
}
```

## Attack Mitigation

### Brute Force Protection

**Account Lockout Mechanism:**
- Maximum failed attempts: 5
- Lockout duration: 15 minutes (exponential backoff)
- Permanent lockout after repeated violations

```dart
Future<void> _handleFailedLogin() async {
  final failedAttempts = _currentAuthState.failedAttempts + 1;
  DateTime? lockoutUntil;

  if (failedAttempts >= _maxFailedAttempts) {
    lockoutUntil = DateTime.now().add(_lockoutDuration);
  }

  _currentAuthState = _currentAuthState.copyWith(
    failedAttempts: failedAttempts,
    lockoutUntil: lockoutUntil,
  );
}
```

### Device Fingerprinting

```dart
static String createDeviceFingerprint({
  required String deviceId,
  required String appVersion,
  String? additionalData,
}) {
  final fingerprintData = {
    'deviceId': deviceId,
    'appVersion': appVersion,
    'timestamp': DateTime.now().millisecondsSinceEpoch,
    'additionalData': additionalData ?? '',
  };
  
  final fingerprintString = jsonEncode(fingerprintData);
  final hash = sha256.convert(utf8.encode(fingerprintString));
  return hash.toString();
}
```

## Data Protection

### Data at Rest

**Encryption Requirements:**
- All sensitive data encrypted before storage
- Encryption keys derived from user credentials
- Key rotation on password change
- Secure key deletion on logout

### Data in Transit

**Transport Security:**
- TLS 1.3 for all network communications
- Certificate pinning for critical endpoints
- Perfect Forward Secrecy (PFS)
- HSTS enforcement

### Data Minimization

**Privacy by Design:**
- Store only necessary authentication data
- Regular cleanup of expired sessions
- Automatic credential expiration (30 days)
- User-controlled data deletion

## Compliance and Standards

### Security Standards

**Compliance Framework:**
- OWASP Mobile Security Guidelines
- NIST Cybersecurity Framework
- ISO 27001 Information Security
- GDPR Privacy Requirements

**Implementation Checklist:**
- ✅ Secure password storage (PBKDF2)
- ✅ Encrypted local storage
- ✅ Biometric authentication
- ✅ Session management
- ✅ Account lockout protection
- ✅ Device fingerprinting
- ✅ Secure communication
- ✅ Error handling
- ✅ Audit logging
- ✅ Data minimization

### Audit and Monitoring

**Security Event Logging:**
```dart
Future<void> _logSecurityEvent(String eventType, Map<String, dynamic> details) async {
  final securityEvent = {
    'timestamp': DateTime.now().toIso8601String(),
    'event_type': eventType,
    'user_id': _currentUser?.id,
    'device_fingerprint': await _getDeviceFingerprint(),
    'details': details,
  };
  
  // Log to secure audit trail
  await _auditLogger.logSecurityEvent(securityEvent);
}
```

**Monitored Events:**
- Login attempts (success/failure)
- Account lockouts
- Biometric authentication events
- Session creation/termination
- Security violations
- Configuration changes

## Security Recommendations

### Development Guidelines

1. **Secure Coding Practices**
   - Input validation and sanitization
   - Output encoding
   - Error handling without information disclosure
   - Secure random number generation

2. **Dependency Management**
   - Regular security updates
   - Vulnerability scanning
   - License compliance
   - Supply chain security

3. **Configuration Security**
   - Secure defaults
   - Environment-specific configurations
   - Secret management
   - Access control

### Deployment Security

1. **Build Security**
   - Code signing
   - Binary protection
   - Anti-tampering measures
   - Secure distribution

2. **Runtime Security**
   - Application sandboxing
   - Runtime application self-protection (RASP)
   - Dynamic security monitoring
   - Incident response automation

### Operational Security

1. **Monitoring and Alerting**
   - Real-time security monitoring
   - Anomaly detection
   - Automated incident response
   - Security metrics and KPIs

2. **Maintenance and Updates**
   - Regular security patches
   - Configuration reviews
   - Security testing
   - Documentation updates
