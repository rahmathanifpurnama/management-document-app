import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:managementdoc/providers/settings_provider.dart';

void main() {
  group('SettingsProvider Tests', () {
    late SettingsProvider settingsProvider;

    setUp(() {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      settingsProvider = SettingsProvider();
    });

    test('should have default values on initialization', () {
      expect(settingsProvider.notificationsEnabled, true);
      expect(settingsProvider.darkModeEnabled, false);
      expect(settingsProvider.selectedLanguage, 'English');
      expect(settingsProvider.availableLanguages.length, 5);
    });

    test('should update notifications setting', () async {
      await settingsProvider.setNotificationsEnabled(false);
      expect(settingsProvider.notificationsEnabled, false);
    });

    test('should update dark mode setting', () async {
      await settingsProvider.setDarkModeEnabled(true);
      expect(settingsProvider.darkModeEnabled, true);
    });

    test('should update language setting', () async {
      await settingsProvider.setSelectedLanguage('Bahasa Indonesia');
      expect(settingsProvider.selectedLanguage, 'Bahasa Indonesia');
    });

    test('should not update language to invalid value', () async {
      const originalLanguage = 'English';
      await settingsProvider.setSelectedLanguage('Invalid Language');
      expect(settingsProvider.selectedLanguage, originalLanguage);
    });

    test('should reset to defaults', () async {
      // Change some settings
      await settingsProvider.setNotificationsEnabled(false);
      await settingsProvider.setDarkModeEnabled(true);
      await settingsProvider.setSelectedLanguage('Bahasa Indonesia');

      // Reset to defaults
      await settingsProvider.resetToDefaults();

      expect(settingsProvider.notificationsEnabled, true);
      expect(settingsProvider.darkModeEnabled, false);
      expect(settingsProvider.selectedLanguage, 'English');
    });

    test('should provide correct theme data for light mode', () {
      final themeData = settingsProvider.themeData;
      expect(themeData.brightness, Brightness.light);
    });

    test('should provide correct theme data for dark mode', () async {
      await settingsProvider.setDarkModeEnabled(true);
      final themeData = settingsProvider.themeData;
      expect(themeData.brightness, Brightness.dark);
    });
  });
}
