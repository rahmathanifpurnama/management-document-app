import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/riverpod/notifiers.dart';
import '../models/settings_state.dart';

class SettingsNotifier extends BaseNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadSettings();
  }

  static const String _notificationsKey = 'notifications_enabled';
  static const String _darkModeKey = 'dark_mode_enabled';
  static const String _languageKey = 'selected_language';

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    try {
      safeUpdate(() => state.copyWith(isLoading: true));

      final prefs = await SharedPreferences.getInstance();

      final notificationsEnabled = prefs.getBool(_notificationsKey) ?? true;
      final darkModeEnabled = prefs.getBool(_darkModeKey) ?? false;
      final selectedLanguage = prefs.getString(_languageKey) ?? 'English';

      safeUpdate(
        () => state.copyWith(
          notificationsEnabled: notificationsEnabled,
          darkModeEnabled: darkModeEnabled,
          selectedLanguage: selectedLanguage,
          isLoading: false,
          errorMessage: null,
        ),
      );
    } catch (e) {
      debugPrint('Error loading settings: $e');
      safeUpdate(
        () => state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load settings: ${e.toString()}',
        ),
      );
    }
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await Future.wait([
        prefs.setBool(_notificationsKey, state.notificationsEnabled),
        prefs.setBool(_darkModeKey, state.darkModeEnabled),
        prefs.setString(_languageKey, state.selectedLanguage),
      ]);
    } catch (e) {
      debugPrint('Error saving settings: $e');
      safeUpdate(
        () => state.copyWith(
          errorMessage: 'Failed to save settings: ${e.toString()}',
        ),
      );
    }
  }

  /// Update notifications setting
  Future<void> setNotificationsEnabled(bool enabled) async {
    if (state.notificationsEnabled != enabled) {
      safeUpdate(
        () => state.copyWith(notificationsEnabled: enabled, errorMessage: null),
      );
      await _saveSettings();
    }
  }

  /// Update dark mode setting
  Future<void> setDarkModeEnabled(bool enabled) async {
    if (state.darkModeEnabled != enabled) {
      safeUpdate(
        () => state.copyWith(darkModeEnabled: enabled, errorMessage: null),
      );
      await _saveSettings();
    }
  }

  /// Update language setting
  Future<void> setSelectedLanguage(String language) async {
    if (state.availableLanguages.contains(language) &&
        state.selectedLanguage != language) {
      safeUpdate(
        () => state.copyWith(selectedLanguage: language, errorMessage: null),
      );
      await _saveSettings();
    }
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    safeUpdate(
      () => const SettingsState(
        notificationsEnabled: true,
        darkModeEnabled: false,
        selectedLanguage: 'English',
      ),
    );
    await _saveSettings();
  }

  /// Clear any error messages
  void clearError() {
    safeUpdate(() => state.copyWith(errorMessage: null));
  }

  /// Update theme mode (for integration tests)
  Future<void> updateTheme(ThemeMode themeMode) async {
    final isDarkMode = themeMode == ThemeMode.dark;
    await setDarkModeEnabled(isDarkMode);
  }

  /// Update language (for integration tests)
  Future<void> updateLanguage(String languageCode) async {
    // Map language codes to full language names
    final languageMap = {
      'en': 'English',
      'id': 'Indonesian',
      'es': 'Spanish',
      'fr': 'French',
      'de': 'German',
    };

    final languageName = languageMap[languageCode] ?? languageCode;
    await setSelectedLanguage(languageName);
  }

  @override
  void reset() {
    state = const SettingsState();
  }
}
