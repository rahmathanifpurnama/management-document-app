import 'package:flutter/material.dart';
import '../interfaces/service_interfaces.dart';
import '../interfaces/segregated_interfaces.dart';
import '../implementations/segregated_implementations.dart';
import '../services/greeting_service.dart';
import '../../services/optimized_statistics_service.dart';
import '../../services/share_service.dart';
import '../../services/file_download_service.dart';
import '../../models/document_model.dart';

/// Dependency Injection Service Locator
/// Implements Service Locator pattern for dependency management
class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();
  factory ServiceLocator() => _instance;
  ServiceLocator._internal();

  static ServiceLocator get instance => _instance;

  final Map<Type, dynamic> _services = {};
  final Map<Type, Function> _factories = {};

  /// Register a singleton service
  void registerSingleton<T>(T service) {
    _services[T] = service;
  }

  /// Register a factory for creating services
  void registerFactory<T>(T Function() factory) {
    _factories[T] = factory;
  }

  /// Register a lazy singleton (created on first access)
  void registerLazySingleton<T>(T Function() factory) {
    _factories[T] = () {
      final service = factory();
      _services[T] = service;
      return service;
    };
  }

  /// Get a service instance
  T get<T>() {
    // Check if singleton exists
    if (_services.containsKey(T)) {
      return _services[T] as T;
    }

    // Check if factory exists
    if (_factories.containsKey(T)) {
      final factory = _factories[T] as T Function();
      final service = factory();

      // If it's a lazy singleton, store it
      if (_services.containsKey(T)) {
        return _services[T] as T;
      }

      return service;
    }

    throw Exception('Service of type $T is not registered');
  }

  /// Check if service is registered
  bool isRegistered<T>() {
    return _services.containsKey(T) || _factories.containsKey(T);
  }

  /// Clear all services (useful for testing)
  void reset() {
    _services.clear();
    _factories.clear();
  }

  /// Initialize all default services
  void initializeServices() {
    // Register greeting service
    registerLazySingleton<IGreetingService>(() => GreetingServiceImpl());

    // Register statistics service
    registerLazySingleton<IStatisticsService>(
      () => OptimizedStatisticsServiceImpl(),
    );

    // Register share service
    registerLazySingleton<IShareService>(() => ShareServiceImpl());

    // Register file operation service
    registerLazySingleton<IFileOperationService>(
      () => FileOperationServiceImpl(),
    );

    // Register segregated interfaces
    _initializeSegregatedServices();
  }

  /// Initialize segregated services following Interface Segregation Principle
  void _initializeSegregatedServices() {
    // Greeting services
    final greetingProvider = GreetingServiceProvider();
    registerSingleton<IGreetingProvider>(greetingProvider);
    registerSingleton<ISmartGreetingProvider>(greetingProvider);
    registerSingleton<IMotivationalGreetingProvider>(greetingProvider);

    // Statistics services
    final statisticsProvider = StatisticsServiceProvider();
    registerSingleton<IStatisticsProvider>(statisticsProvider);
    registerSingleton<IStatisticsCacheManager>(statisticsProvider);
    registerSingleton<IRealtimeStatisticsProvider>(statisticsProvider);

    // Sharing services
    final sharingProvider = SharingServiceProvider();
    registerSingleton<IFileSharer>(sharingProvider);
    registerSingleton<IGoogleDriveSharer>(sharingProvider);
    registerSingleton<IBulkSharer>(sharingProvider);
    registerSingleton<ILinkSharer>(sharingProvider);

    // File operation services
    final fileOperationProvider = FileOperationServiceProvider();
    registerSingleton<IFileDownloader>(fileOperationProvider);
    registerSingleton<IFileDeleter>(fileOperationProvider);
    registerSingleton<IFileRestorer>(fileOperationProvider);
    registerSingleton<IFileMetadataManager>(fileOperationProvider);

    // Navigation services
    final navigationProvider = NavigationServiceProvider();
    registerSingleton<INavigator>(navigationProvider);
    registerSingleton<IFileNavigator>(navigationProvider);
    registerSingleton<IUserNavigator>(navigationProvider);
    registerSingleton<ICategoryNavigator>(navigationProvider);
    registerSingleton<IModalManager>(navigationProvider);
  }
}

/// Concrete implementation of IGreetingService
class GreetingServiceImpl implements IGreetingService {
  final GreetingService _greetingService = GreetingService.instance;

  @override
  GreetingSet getSmartGreeting(String? userName) {
    return _greetingService.getSmartGreeting(userName);
  }

  @override
  GreetingSet getGreetingWithMotivation(String? userName) {
    return _greetingService.getGreetingWithMotivation(userName);
  }

  @override
  String getPersonalizedGreeting(String? userName) {
    return _greetingService.getPersonalizedGreeting(userName);
  }

  @override
  String getMainGreeting() {
    return _greetingService.getMainGreeting();
  }
}

/// Concrete implementation of IStatisticsService
class OptimizedStatisticsServiceImpl implements IStatisticsService {
  final OptimizedStatisticsService _statisticsService =
      OptimizedStatisticsService.instance;

  @override
  Future<Map<String, dynamic>> getAggregatedStatistics({
    bool forceRefresh = false,
  }) {
    return _statisticsService.getAggregatedStatistics(
      forceRefresh: forceRefresh,
    );
  }

  @override
  Future<void> invalidateCache({String? reason}) {
    return _statisticsService.invalidateCache(reason: reason);
  }

  @override
  Stream<Map<String, dynamic>> getStatisticsStream() {
    return _statisticsService.getStatisticsStream();
  }
}

/// Concrete implementation of IShareService
class ShareServiceImpl implements IShareService {
  final ShareService _shareService = ShareService();

  @override
  Future<void> shareGoogleDriveLink(
    DocumentModel document, {
    Function(double progress)? onProgress,
    String? customMessage,
  }) {
    return _shareService.shareGoogleDriveLink(
      document,
      onProgress: onProgress,
      customMessage: customMessage,
    );
  }

  @override
  Future<void> shareFileWithLink({
    required DocumentModel document,
    Duration? linkExpiration,
    String? customMessage,
    Function(double progress)? onProgress,
  }) {
    return _shareService.shareFileWithLink(
      document: document,
      linkExpiration: linkExpiration,
      customMessage: customMessage,
      onProgress: onProgress,
    );
  }

  @override
  Future<void> shareBulkFiles({
    required List<DocumentModel> documents,
    Duration? linkExpiration,
    String? customMessage,
    Function(int completed, int total, String currentFile)? onProgress,
  }) {
    return _shareService.shareBulkFiles(
      documents: documents,
      linkExpiration: linkExpiration,
      customMessage: customMessage,
      onProgress: onProgress,
    );
  }
}

/// Concrete implementation of IFileOperationService
class FileOperationServiceImpl implements IFileOperationService {
  final FileDownloadService _downloadService = FileDownloadService();

  @override
  Future<void> downloadFile(DocumentModel document) {
    return _downloadService.downloadFile(document);
  }

  @override
  Future<void> deleteFile(DocumentModel document) {
    // Implementation would go here
    throw UnimplementedError('Delete file not implemented yet');
  }

  @override
  Future<void> restoreFile(DocumentModel document) {
    // Implementation would go here
    throw UnimplementedError('Restore file not implemented yet');
  }
}
