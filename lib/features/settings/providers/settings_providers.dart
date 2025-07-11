import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../notifiers/settings_notifier.dart';
import '../models/settings_state.dart';

/// Main settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    return SettingsNotifier();
  },
);

/// Computed providers for specific settings
final notificationsEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).notificationsEnabled;
});

final darkModeEnabledProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).darkModeEnabled;
});

final selectedLanguageProvider = Provider<String>((ref) {
  return ref.watch(settingsProvider).selectedLanguage;
});

final settingsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isLoading;
});

final settingsErrorProvider = Provider<String?>((ref) {
  return ref.watch(settingsProvider).errorMessage;
});

/// Theme data provider based on dark mode setting
final themeDataProvider = Provider<ThemeData>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.themeData;
});

/// Available languages provider
final availableLanguagesProvider = Provider<List<String>>((ref) {
  return const ['English', 'Indonesian', 'Spanish', 'French', 'German'];
});

/// Settings actions provider
final settingsActionsProvider = Provider<SettingsActions>((ref) {
  return SettingsActions(ref);
});

/// Settings actions class for easy access to notifier methods
class SettingsActions {
  final Ref _ref;

  SettingsActions(this._ref);

  SettingsNotifier get _notifier => _ref.read(settingsProvider.notifier);

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _notifier.setNotificationsEnabled(enabled);
  }

  Future<void> setDarkModeEnabled(bool enabled) async {
    await _notifier.setDarkModeEnabled(enabled);
  }

  Future<void> setSelectedLanguage(String language) async {
    await _notifier.setSelectedLanguage(language);
  }

  Future<void> resetToDefaults() async {
    await _notifier.resetToDefaults();
  }

  void clearError() {
    _notifier.clearError();
  }
}
