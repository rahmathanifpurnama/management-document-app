import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:managementdoc/features/settings/providers/settings_providers.dart';
import 'package:managementdoc/features/settings/notifiers/settings_notifier.dart';

void main() {
  group('Settings Riverpod Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with default settings', () {
      final settings = container.read(settingsProvider);

      expect(settings.darkModeEnabled, false);
      expect(settings.notificationsEnabled, true);
      expect(settings.selectedLanguage, 'English');
      expect(settings.isLoading, false);
    });

    test('should update dark mode setting', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      await notifier.setDarkModeEnabled(true);
      
      final settings = container.read(settingsProvider);
      expect(settings.darkModeEnabled, true);
    });

    test('should update notification setting', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      await notifier.setNotificationsEnabled(false);
      
      final settings = container.read(settingsProvider);
      expect(settings.notificationsEnabled, false);
    });

    test('should update language setting', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      await notifier.setSelectedLanguage('Indonesian');
      
      final settings = container.read(settingsProvider);
      expect(settings.selectedLanguage, 'Indonesian');
    });

    test('should persist settings to SharedPreferences', () async {
      final notifier = container.read(settingsProvider.notifier);
      await notifier.setDarkModeEnabled(true);
      await notifier.setSelectedLanguage('Indonesian');
      
      // Create new container to simulate app restart
      final newContainer = ProviderContainer();
      await Future.delayed(Duration.zero); // Allow async initialization
      
      final newSettings = newContainer.read(settingsProvider);
      expect(newSettings.darkModeEnabled, true);
      expect(newSettings.selectedLanguage, 'Indonesian');
      
      newContainer.dispose();
    });

    test('should handle loading states correctly', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      // Start async operation
      final future = notifier.setDarkModeEnabled(true);
      
      // Check loading state (might be brief)
      await Future.delayed(Duration.zero);
      
      // Wait for completion
      await future;
      
      final settings = container.read(settingsProvider);
      expect(settings.isLoading, false);
      expect(settings.darkModeEnabled, true);
    });

    test('should handle multiple rapid updates correctly', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      // Perform multiple rapid updates
      await Future.wait([
        notifier.setDarkModeEnabled(true),
        notifier.setNotificationsEnabled(false),
        notifier.setSelectedLanguage('Spanish'),
      ]);
      
      final settings = container.read(settingsProvider);
      expect(settings.darkModeEnabled, true);
      expect(settings.notificationsEnabled, false);
      expect(settings.selectedLanguage, 'Spanish');
    });

    test('should reset to defaults', () async {
      final notifier = container.read(settingsProvider.notifier);
      
      // Change settings
      await notifier.setDarkModeEnabled(true);
      await notifier.setNotificationsEnabled(false);
      await notifier.setSelectedLanguage('French');
      
      // Reset to defaults
      await notifier.resetToDefaults();
      
      final settings = container.read(settingsProvider);
      expect(settings.darkModeEnabled, false);
      expect(settings.notificationsEnabled, true);
      expect(settings.selectedLanguage, 'English');
    });
  });
}
