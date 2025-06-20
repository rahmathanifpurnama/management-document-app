import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/document_model.dart';

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
      ongoing: false,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/launcher_icon',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: 'download_complete_${document.id}',
    );

    debugPrint('📱 Download completed notification shown: ID $notificationId');
  }

  /// Show download failed notification
  Future<void> showDownloadFailed({
    required int notificationId,
    required DocumentModel document,
    required String error,
    bool isBulkDownload = false,
  }) async {
    if (!_isInitialized) return;

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
      ongoing: false,
      autoCancel: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/launcher_icon',
    );

    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      notificationId,
      title,
      body,
      notificationDetails,
      payload: 'download_failed_${document.id}',
    );

    debugPrint('📱 Download failed notification shown: ID $notificationId');
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int notificationId) async {
    await _notificationsPlugin.cancel(notificationId);
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
}
