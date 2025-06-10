import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Theme data getter
  ThemeData get themeData {
    if (_darkModeEnabled) {
      return ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF03DAC6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      );
    } else {
      return ThemeData.light().copyWith(
        primaryColor: const Color(0xFF1976D2),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1976D2),
          secondary: Color(0xFF03DAC6),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1976D2),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
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
    if (_availableLanguages.contains(language) && _selectedLanguage != language) {
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
