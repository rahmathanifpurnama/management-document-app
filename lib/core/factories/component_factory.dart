import 'package:flutter/material.dart';
import '../../screens/common/home_screen.dart';
import '../../widgets/statistics/responsive_stats_grid.dart';
import '../../models/document_model.dart';
import '../services/greeting_service.dart';

/// Factory pattern implementation for creating different types of components
/// Provides polymorphic component creation based on user roles and app state

// ============================================================================
// COMPONENT FACTORY INTERFACE
// ============================================================================

/// Abstract factory for creating home screen components
abstract class ComponentFactory {
  /// Create greeting component
  Widget createGreetingComponent({required Map<String, dynamic> context});

  /// Create search component
  Widget createSearchComponent({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  });

  /// Create file list component
  Widget createFileListComponent({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  });

  /// Create statistics component
  Widget? createStatisticsComponent({
    required Map<String, dynamic> context,
    Function(String)? onStatTap,
  });

  /// Get factory name
  String get factoryName;
}

// ============================================================================
// CONCRETE FACTORIES
// ============================================================================

/// Factory for admin user components
class AdminComponentFactory extends ComponentFactory {
  @override
  Widget createGreetingComponent({required Map<String, dynamic> context}) {
    final authState = context['authState'];
    final currentGreeting = context['currentGreeting'] as GreetingSet?;
    final onProfileTap = context['onProfileTap'] as VoidCallback?;

    return HomeGreetingSection(
      authState: authState,
      currentGreeting:
          currentGreeting ??
          GreetingSet(
            personalGreeting: 'Good Morning',
            mainGreeting: 'Welcome Admin',
          ),
      onProfileTap: onProfileTap,
    );
  }

  @override
  Widget createSearchComponent({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  }) {
    return HomeSearchSection(
      searchController: controller,
      onSearchChanged: onSearchChanged,
    );
  }

  @override
  Widget createFileListComponent({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  }) {
    return HomeFileListSection(
      searchQuery: searchQuery ?? '',
      onDocumentTap: onDocumentTap,
      onDocumentMenu: onDocumentMenu,
      onFilterTap: onFilterTap,
    );
  }

  @override
  Widget? createStatisticsComponent({
    required Map<String, dynamic> context,
    Function(String)? onStatTap,
  }) {
    final statsData = context['statsData'] as Map<String, dynamic>? ?? {};
    final isLoading = context['isLoading'] as bool? ?? false;

    return StatsGrid(
      statsData: statsData,
      onStatTap: onStatTap,
      isLoading: isLoading,
    );
  }

  @override
  String get factoryName => 'Admin';
}

/// Factory for regular user components
class UserComponentFactory extends ComponentFactory {
  @override
  Widget createGreetingComponent({required Map<String, dynamic> context}) {
    final authState = context['authState'];
    final currentGreeting = context['currentGreeting'] as GreetingSet?;
    final onProfileTap = context['onProfileTap'] as VoidCallback?;

    return HomeGreetingSection(
      authState: authState,
      currentGreeting:
          currentGreeting ??
          GreetingSet(personalGreeting: 'Hello', mainGreeting: 'Welcome back'),
      onProfileTap: onProfileTap,
    );
  }

  @override
  Widget createSearchComponent({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  }) {
    return HomeSearchSection(
      searchController: controller,
      onSearchChanged: onSearchChanged,
    );
  }

  @override
  Widget createFileListComponent({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  }) {
    return HomeFileListSection(
      searchQuery: searchQuery ?? '',
      onDocumentTap: onDocumentTap,
      onDocumentMenu: onDocumentMenu,
      onFilterTap: onFilterTap,
    );
  }

  @override
  Widget? createStatisticsComponent({
    required Map<String, dynamic> context,
    Function(String)? onStatTap,
  }) {
    // Regular users don't see statistics
    return null;
  }

  @override
  String get factoryName => 'User';
}

/// Factory for guest/limited access components
class GuestComponentFactory extends ComponentFactory {
  @override
  Widget createGreetingComponent({required Map<String, dynamic> context}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Text(
        'Welcome Guest',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget createSearchComponent({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        enabled: false,
        decoration: const InputDecoration(
          hintText: 'Search not available for guests',
          prefixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  @override
  Widget createFileListComponent({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  }) {
    return const Center(
      child: Text(
        'Please log in to view files',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  @override
  Widget? createStatisticsComponent({
    required Map<String, dynamic> context,
    Function(String)? onStatTap,
  }) {
    // Guests don't see statistics
    return null;
  }

  @override
  String get factoryName => 'Guest';
}

/// Factory for mobile-optimized components
class MobileComponentFactory extends ComponentFactory {
  final ComponentFactory _baseFactory;

  MobileComponentFactory(this._baseFactory);

  @override
  Widget createGreetingComponent({required Map<String, dynamic> context}) {
    // Use base factory but wrap in mobile-optimized container
    final baseComponent = _baseFactory.createGreetingComponent(
      context: context,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: baseComponent,
    );
  }

  @override
  Widget createSearchComponent({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  }) {
    // Mobile-optimized search with larger touch targets
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16), // Prevent zoom on iOS
        decoration: InputDecoration(
          hintText: 'Search files...',
          prefixIcon: const Icon(Icons.search, size: 24),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 24),
                  onPressed: () {
                    controller.clear();
                    onSearchChanged?.call();
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        onChanged: (_) => onSearchChanged?.call(),
      ),
    );
  }

  @override
  Widget createFileListComponent({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  }) {
    return _baseFactory.createFileListComponent(
      searchQuery: searchQuery,
      onDocumentTap: onDocumentTap,
      onDocumentMenu: onDocumentMenu,
      onFilterTap: onFilterTap,
    );
  }

  @override
  Widget? createStatisticsComponent({
    required Map<String, dynamic> context,
    Function(String)? onStatTap,
  }) {
    return _baseFactory.createStatisticsComponent(
      context: context,
      onStatTap: onStatTap,
    );
  }

  @override
  String get factoryName => 'Mobile-${_baseFactory.factoryName}';
}

// ============================================================================
// FACTORY MANAGER
// ============================================================================

/// Manager class that selects appropriate component factory
class ComponentFactoryManager {
  static final ComponentFactoryManager _instance =
      ComponentFactoryManager._internal();
  factory ComponentFactoryManager() => _instance;
  ComponentFactoryManager._internal();

  static ComponentFactoryManager get instance => _instance;

  final Map<String, ComponentFactory> _factories = {
    'admin': AdminComponentFactory(),
    'user': UserComponentFactory(),
    'guest': GuestComponentFactory(),
  };

  /// Get factory based on user role and device type
  ComponentFactory getFactory({
    required String userRole,
    bool isMobile = false,
  }) {
    ComponentFactory baseFactory;

    switch (userRole.toLowerCase()) {
      case 'admin':
        baseFactory = _factories['admin']!;
        break;
      case 'user':
        baseFactory = _factories['user']!;
        break;
      default:
        baseFactory = _factories['guest']!;
        break;
    }

    // Wrap in mobile factory if needed
    if (isMobile) {
      return MobileComponentFactory(baseFactory);
    }

    return baseFactory;
  }

  /// Register a custom factory
  void registerFactory(String key, ComponentFactory factory) {
    _factories[key] = factory;
  }

  /// Get all available factories
  Map<String, ComponentFactory> get availableFactories =>
      Map.unmodifiable(_factories);
}

// ============================================================================
// COMPONENT BUILDER
// ============================================================================

/// Builder class for creating components with fluent interface
class ComponentBuilder {
  final ComponentFactory _factory;
  final Map<String, dynamic> _context = {};

  ComponentBuilder(this._factory);

  /// Add context data
  ComponentBuilder withContext(String key, dynamic value) {
    _context[key] = value;
    return this;
  }

  /// Add multiple context data
  ComponentBuilder withContextMap(Map<String, dynamic> context) {
    _context.addAll(context);
    return this;
  }

  /// Build greeting component
  Widget buildGreeting() {
    return _factory.createGreetingComponent(context: _context);
  }

  /// Build search component
  Widget buildSearch({
    required TextEditingController controller,
    VoidCallback? onSearchChanged,
  }) {
    return _factory.createSearchComponent(
      controller: controller,
      onSearchChanged: onSearchChanged,
    );
  }

  /// Build file list component
  Widget buildFileList({
    String? searchQuery,
    Function(DocumentModel)? onDocumentTap,
    Function(DocumentModel)? onDocumentMenu,
    VoidCallback? onFilterTap,
  }) {
    return _factory.createFileListComponent(
      searchQuery: searchQuery,
      onDocumentTap: onDocumentTap,
      onDocumentMenu: onDocumentMenu,
      onFilterTap: onFilterTap,
    );
  }

  /// Build statistics component
  Widget? buildStatistics({Function(String)? onStatTap}) {
    return _factory.createStatisticsComponent(
      context: _context,
      onStatTap: onStatTap,
    );
  }
}
