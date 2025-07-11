import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/material.dart';

part 'settings_state.freezed.dart';
part 'settings_state.g.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool notificationsEnabled,
    @Default(false) bool darkModeEnabled,
    @Default('English') String selectedLanguage,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}

/// Extension to provide computed properties
extension SettingsStateX on SettingsState {
  /// Get theme data based on dark mode setting
  ThemeData get themeData {
    return darkModeEnabled ? ThemeData.dark() : ThemeData.light();
  }

  /// Check if settings are in error state
  bool get hasError => errorMessage != null;

  /// Get available languages (instance property for compatibility)
  List<String> get availableLanguages => const [
    'English',
    'Indonesian',
    'Spanish',
    'French',
    'German',
  ];

  /// Get theme mode based on dark mode setting
  ThemeMode get themeMode => darkModeEnabled ? ThemeMode.dark : ThemeMode.light;

  /// Get language (alias for selectedLanguage)
  String get language => selectedLanguage;

  /// Check if language is available
  bool get isLanguageValid => availableLanguages.contains(selectedLanguage);
}
