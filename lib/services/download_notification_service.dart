import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/document_model.dart';

/// Enum for notification states
enum NotificationState { created, inProgress, completed, failed, cancelled }

/// Class to track notification state
class NotificationTracker {
  final int id;
  final String documentId;
  NotificationState state;
  final DateTime createdAt;
  DateTime? lastUpdated;

  NotificationTracker({
    required this.id,
    required this.documentId,
    required this.state,
    required this.createdAt,
    this.lastUpdated,
  });

  void updateState(NotificationState newState) {
    state = newState;
    lastUpdated = DateTime.now();
  }
}

/// Service for managing download notifications in the Android notification bar
class DownloadNotificationService {
  static final DownloadNotificationService _instance =
      DownloadNotificationService._internal();
  factory DownloadNotificationService() => _instance;
  DownloadNotificationService._internal();

  static const String _channelId = 'download_channel';
  static const String _channelName = 'File Downloads';
  static const String _channelDescription =
      'Notifications for file download progress';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  int _notificationIdCounter = 1000;

  // State management for notifications
  final Map<int, NotificationTracker> _activeNotifications = {};
  final Map<String, int> _documentToNotificationId = {};

  /// Initialize the notification service
  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/launcher_icon',
      );

      // iOS initialization settings (for future compatibility)
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      final initialized = await _notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      if (initialized == true) {
        await _createNotificationChannel();
        _isInitialized = true;

        // Clean up old notifications on initialization
        _cleanupOldNotifications();

        debugPrint('✅ DownloadNotificationService initialized successfully');
        return true;
      }

      debugPrint('❌ Failed to initialize DownloadNotificationService');
      return false;
    } catch (e) {
      debugPrint('❌ Error initializing DownloadNotificationService: $e');
      return false;
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.low, // Low importance for progress notifications
      enableVibration: false,
      playSound: false,
      showBadge: false,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);
  }

  /// Handle notification tap events
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('📱 Notification tapped: ${response.payload}');
    // Handle notification tap if needed (e.g., open downloads folder)
  }

  /// Request notification permissions (Android 13+)
  Future<bool> requestPermissions() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      debugPrint('📱 Notification permission granted: $granted');
      return granted ?? false;
    }

    return true; // Assume granted for older Android versions
  }

  /// Show download start notification
  Future<int> showDownloadStarted({
    required DocumentModel document,
    bool isBulkDownload = false,
    int? totalFiles,
  }) async {
    if (!_isInitialized) {
      final initialized = await initialize();
      if (!initialized) return -1;
    }

    final notificationId = _getNextNotificationId();
    final title = isBulkDownload
        ? 'Downloading $totalFiles files'
        : 'Downloading file';
    final body = isBulkDownload
        ? 'Preparing to download $totalFiles files...'
        : 'Preparing to download ${document.fileName}';

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: 0,
      indeterminate: true,
      ongoing: true,
      autoCancel: false,
      enableVibration: false,
      playSound: false,
      icon: '@mipmap/launcher_icon',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: 'download_${document.id}',
    );

    // Register notification in state management
    _registerNotification(
      notificationId,
      document.id,
      NotificationState.created,
    );

    debugPrint('📱 Download notification started: ID $notificationId');
    return notificationId;
  }

  /// Update download progress notification
  Future<void> updateDownloadProgress({
    required int notificationId,
    required DocumentModel document,
    required double progress,
    bool isBulkDownload = false,
    int? completedFiles,
    int? totalFiles,
  }) async {
    if (!_isInitialized) return;

    // Check if notification is still valid for progress updates
    if (!_isNotificationInProgress(notificationId) &&
        !_activeNotifications.containsKey(notificationId)) {
      debugPrint(
        '⚠️ Skipping progress update for invalid notification: $notificationId',
      );
      return;
    }

    final progressPercent = (progress * 100).round();
    final title = isBulkDownload
        ? 'Downloading files ($completedFiles/$totalFiles)'
        : 'Downloading file';
    final body = isBulkDownload
        ? 'Progress: $progressPercent% - ${document.fileName}'
        : '${document.fileName} - $progressPercent%';

    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.low,
      priority: Priority.low,
      showProgress: true,
      maxProgress: 100,
      progress: progressPercent,
      indeterminate: false,
      ongoing: true,
      autoCancel: false,
      enableVibration: false,
      playSound: false,
      icon: '@mipmap/launcher_icon',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: 'download_${document.id}',
    );

    // Update notification state to in progress
    _updateNotificationState(notificationId, NotificationState.inProgress);
  }

  /// Show download completed notification
  Future<void> showDownloadCompleted({
    required int notificationId,
    required DocumentModel document,
    bool isBulkDownload = false,
    int? totalFiles,
    int? failedFiles,
  }) async {
    if (!_isInitialized) return;

    try {
      // CRITICAL FIX: Cancel the progress notification first
      await cancelNotification(notificationId);

      // Add small delay to ensure the cancellation is processed
      await Future.delayed(const Duration(milliseconds: 100));

      String title;
      String body;

      if (isBulkDownload) {
        if (failedFiles != null && failedFiles > 0) {
          title = 'Download completed with errors';
          body =
              'Downloaded ${(totalFiles ?? 0) - failedFiles}/$totalFiles files successfully';
        } else {
          title = 'All files downloaded';
          body = 'Successfully downloaded $totalFiles files';
        }
      } else {
        title = 'Download completed';
        body = '${document.fileName} downloaded successfully';
      }

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showProgress: false,
        ongoing: false, // CRITICAL: Ensure not sticky
        autoCancel: true, // CRITICAL: Allow swipe to dismiss
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/launcher_icon',
        // Additional properties to ensure dismissible behavior
        category: AndroidNotificationCategory.status,
        visibility: NotificationVisibility.public,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: 'download_complete_${document.id}',
      );

      // Update notification state to completed
      _updateNotificationState(notificationId, NotificationState.completed);

      debugPrint(
        '📱 Download completed notification shown: ID $notificationId',
      );
    } catch (e) {
      debugPrint('❌ Error showing download completed notification: $e');
    }
  }

  /// Show download failed notification
  Future<void> showDownloadFailed({
    required int notificationId,
    required DocumentModel document,
    required String error,
    bool isBulkDownload = false,
  }) async {
    if (!_isInitialized) return;

    try {
      // CRITICAL FIX: Cancel the progress notification first
      await cancelNotification(notificationId);

      // Add small delay to ensure the cancellation is processed
      await Future.delayed(const Duration(milliseconds: 100));

      final title = isBulkDownload ? 'Bulk download failed' : 'Download failed';
      final body = isBulkDownload
          ? 'Failed to download files: $error'
          : 'Failed to download ${document.fileName}: $error';

      final androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showProgress: false,
        ongoing: false, // CRITICAL: Ensure not sticky
        autoCancel: true, // CRITICAL: Allow swipe to dismiss
        enableVibration: true,
        playSound: true,
        icon: '@mipmap/launcher_icon',
        // Additional properties to ensure dismissible behavior
        category: AndroidNotificationCategory.error,
        visibility: NotificationVisibility.public,
      );

      final notificationDetails = NotificationDetails(android: androidDetails);

      await _notificationsPlugin.show(
        notificationId,
        title,
        body,
        notificationDetails,
        payload: 'download_failed_${document.id}',
      );

      // Update notification state to failed
      _updateNotificationState(notificationId, NotificationState.failed);

      debugPrint('📱 Download failed notification shown: ID $notificationId');
    } catch (e) {
      debugPrint('❌ Error showing download failed notification: $e');
    }
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);

    // Update state and unregister
    _updateNotificationState(notificationId, NotificationState.cancelled);
    _unregisterNotification(notificationId);

    debugPrint('📱 Cancelled notification: ID $notificationId');
  }

  /// Cancel all download notifications
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('📱 Cancelled all notifications');
  }

  /// Get next available notification ID
  int _getNextNotificationId() {
    return _notificationIdCounter++;
  }

  /// Register a new notification in state management
  void _registerNotification(
    int notificationId,
    String documentId,
    NotificationState state,
  ) {
    final tracker = NotificationTracker(
      id: notificationId,
      documentId: documentId,
      state: state,
      createdAt: DateTime.now(),
    );

    _activeNotifications[notificationId] = tracker;
    _documentToNotificationId[documentId] = notificationId;

    debugPrint(
      '📱 Registered notification: ID $notificationId for document $documentId',
    );
  }

  /// Update notification state
  void _updateNotificationState(
    int notificationId,
    NotificationState newState,
  ) {
    final tracker = _activeNotifications[notificationId];
    if (tracker != null) {
      tracker.updateState(newState);
      debugPrint('📱 Updated notification $notificationId state to $newState');
    }
  }

  /// Remove notification from state management
  void _unregisterNotification(int notificationId) {
    final tracker = _activeNotifications.remove(notificationId);
    if (tracker != null) {
      _documentToNotificationId.remove(tracker.documentId);
      debugPrint('📱 Unregistered notification: ID $notificationId');
    }
  }

  /// Check if notification is in progress state
  bool _isNotificationInProgress(int notificationId) {
    final tracker = _activeNotifications[notificationId];
    return tracker?.state == NotificationState.inProgress;
  }

  /// Get notification ID for document (if exists)
  int? getNotificationIdForDocument(String documentId) {
    return _documentToNotificationId[documentId];
  }

  /// Clean up old completed/failed notifications (older than 1 hour)
  void _cleanupOldNotifications() {
    final cutoffTime = DateTime.now().subtract(const Duration(hours: 1));
    final toRemove = <int>[];

    for (final entry in _activeNotifications.entries) {
      final tracker = entry.value;
      if ((tracker.state == NotificationState.completed ||
              tracker.state == NotificationState.failed) &&
          (tracker.lastUpdated ?? tracker.createdAt).isBefore(cutoffTime)) {
        toRemove.add(entry.key);
      }
    }

    for (final id in toRemove) {
      _unregisterNotification(id);
    }

    if (toRemove.isNotEmpty) {
      debugPrint('📱 Cleaned up ${toRemove.length} old notifications');
    }
  }

  /// Check if notifications are enabled
  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final enabled = await androidPlugin.areNotificationsEnabled();
      return enabled ?? false;
    }

    return true;
  }

  /// Test notification dismissal behavior
  Future<void> testNotificationDismissal() async {
    if (!_isInitialized) {
      await initialize();
    }

    // Create a test document
    final testDocument = DocumentModel(
      id: 'test_notification_${DateTime.now().millisecondsSinceEpoch}',
      fileName: 'Test Notification.pdf',
      fileSize: 1024000,
      fileType: 'pdf',
      filePath: 'test/notification.pdf',
      uploadedBy: 'test_user',
      uploadedAt: DateTime.now(),
      category: 'Test',
      permissions: [],
      metadata: DocumentMetadata(
        description: 'Test notification for dismissal behavior',
        tags: ['test'],
      ),
    );

    try {
      debugPrint('🧪 Testing notification dismissal behavior...');

      // Test 1: Progress notification (should be sticky)
      final progressId = await showDownloadStarted(
        document: testDocument,
        isBulkDownload: false,
      );

      debugPrint('📱 Created progress notification: $progressId');
      await Future.delayed(const Duration(seconds: 2));

      // Test 2: Update progress
      await updateDownloadProgress(
        notificationId: progressId,
        document: testDocument,
        progress: 0.5,
      );

      debugPrint('📱 Updated progress to 50%');
      await Future.delayed(const Duration(seconds: 2));

      // Test 3: Complete notification (should be dismissible)
      await showDownloadCompleted(
        notificationId: progressId,
        document: testDocument,
      );

      debugPrint('✅ Test completed - Check if notification can be swiped away');
      debugPrint('📱 Notification ID: $progressId should now be dismissible');

      // Clean up after test
      await Future.delayed(const Duration(seconds: 5));
      await cancelNotification(progressId);
    } catch (e) {
      debugPrint('❌ Test failed: $e');
    }
  }

  /// Get diagnostic information about notifications
  Map<String, dynamic> getDiagnosticInfo() {
    return {
      'isInitialized': _isInitialized,
      'activeNotifications': _activeNotifications.length,
      'notificationIdCounter': _notificationIdCounter,
      'activeNotificationDetails': _activeNotifications.map(
        (id, tracker) => MapEntry(id.toString(), {
          'documentId': tracker.documentId,
          'state': tracker.state.toString(),
          'createdAt': tracker.createdAt.toIso8601String(),
          'lastUpdated': tracker.lastUpdated?.toIso8601String(),
        }),
      ),
      'documentToNotificationMapping': _documentToNotificationId,
    };
  }

  /// Force cleanup of all notifications (for testing)
  Future<void> forceCleanupAllNotifications() async {
    await cancelAllNotifications();
    _activeNotifications.clear();
    _documentToNotificationId.clear();
    debugPrint('🧹 Force cleaned up all notifications');
  }
}
