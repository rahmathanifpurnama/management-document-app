import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class SettingsProvider extends ChangeNotifier {
  // Settings state
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguage = 'English';

  // Available languages
  final List<String> _availableLanguages = [
    'English',
    'Bahasa Indonesia',
    'Español',
    'Français',
    'Deutsch',
  ];

  // Getters
  bool get notificationsEnabled => _notificationsEnabled;
  bool get darkModeEnabled => _darkModeEnabled;
  String get selectedLanguage => _selectedLanguage;
  List<String> get availableLanguages => List.unmodifiable(_availableLanguages);

  // Enhanced theme data getter with beautiful dark mode
  ThemeData get themeData {
    if (_darkModeEnabled) {
      return ThemeData.dark().copyWith(
        primaryColor: AppColorsDark.primary,
        scaffoldBackgroundColor: AppColorsDark.background,
        colorScheme: ColorScheme.dark(
          primary: AppColorsDark.primary,
          secondary: AppColorsDark.secondary,
          surface: AppColorsDark.surface,
          background: AppColorsDark.background,
          error: AppColorsDark.error,
          onPrimary: AppColorsDark.textWhite,
          onSecondary: AppColorsDark.textWhite,
          onSurface: AppColorsDark.textPrimary,
          onBackground: AppColorsDark.textPrimary,
          onError: AppColorsDark.textWhite,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColorsDark.surface,
          foregroundColor: AppColorsDark.textPrimary,
          elevation: 0,
          shadowColor: AppColorsDark.shadow,
        ),
        cardTheme: CardThemeData(
          color: AppColorsDark.cardBackground,
          shadowColor: AppColorsDark.cardShadow,
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColorsDark.primary,
            foregroundColor: AppColorsDark.textWhite,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColorsDark.inputBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColorsDark.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColorsDark.inputFocused),
          ),
        ),
        dividerTheme: DividerThemeData(color: AppColorsDark.divider),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.light(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          background: AppColors.background,
          error: AppColors.error,
          onPrimary: AppColors.textWhite,
          onSecondary: AppColors.textWhite,
          onSurface: AppColors.textPrimary,
          onBackground: AppColors.textPrimary,
          onError: AppColors.textWhite,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textWhite,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.cardBackground,
          shadowColor: AppColors.cardShadow,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.textWhite,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.inputBorder),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.inputFocused),
          ),
        ),
        dividerTheme: DividerThemeData(color: AppColors.divider),
      );
    }
  }

  // Initialize settings from SharedPreferences
  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      _selectedLanguage = prefs.getString('selected_language') ?? 'English';

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await Future.wait([
        prefs.setBool('notifications_enabled', _notificationsEnabled),
        prefs.setBool('dark_mode_enabled', _darkModeEnabled),
        prefs.setString('selected_language', _selectedLanguage),
      ]);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Update notifications setting
  Future<void> setNotificationsEnabled(bool enabled) async {
    if (_notificationsEnabled != enabled) {
      _notificationsEnabled = enabled;
      notifyListeners();
      await _saveSettings();
    }
  }

  // Update dark mode setting
  Future<void> setDarkModeEnabled(bool enabled) async {
    if (_darkModeEnabled != enabled) {
      _darkModeEnabled = enabled;
      notifyListeners();
      await _saveSettings();
    }
  }

  // Update language setting
  Future<void> setSelectedLanguage(String language) async {
    if (_availableLanguages.contains(language) &&
        _selectedLanguage != language) {
      _selectedLanguage = language;
      notifyListeners();
      await _saveSettings();
    }
  }

  // Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _notificationsEnabled = true;
    _darkModeEnabled = false;
    _selectedLanguage = 'English';

    notifyListeners();
    await _saveSettings();
  }
}
