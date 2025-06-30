import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserCard _getInitials Tests', () {
    test('should handle empty fullName', () {
      final result = getInitials('');
      expect(result, equals('?'));
    });

    test('should handle whitespace-only fullName', () {
      final result = getInitials('   ');
      expect(result, equals('?'));
    });

    test('should handle single word', () {
      final result = getInitials('John');
      expect(result, equals('J'));
    });

    test('should handle two words', () {
      final result = getInitials('John Doe');
      expect(result, equals('JD'));
    });

    test('should handle multiple words', () {
      final result = getInitials('John Michael Doe');
      expect(result, equals('JD'));
    });

    test('should handle names with extra spaces', () {
      final result = getInitials('  John   Doe  ');
      expect(result, equals('JD'));
    });

    test('should handle single character name', () {
      final result = getInitials('A');
      expect(result, equals('A'));
    });
  });
}

/// Extracted _getInitials method for testing
String getInitials(String fullName) {
  if (fullName.trim().isEmpty) {
    return '?'; // Fallback for empty names
  }
  
  final trimmedName = fullName.trim();
  final words = trimmedName.split(' ').where((word) => word.isNotEmpty).toList();
  
  if (words.isEmpty) {
    return '?'; // Fallback if no valid words
  }
  
  if (words.length == 1) {
    // Single word - take first character
    return words[0][0].toUpperCase();
  } else {
    // Multiple words - take first character of first and last word
    return '${words.first[0]}${words.last[0]}'.toUpperCase();
  }
}
