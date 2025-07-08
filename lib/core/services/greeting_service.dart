import 'dart:math';
import '../constants/app_strings.dart';

class GreetingService {
  static final GreetingService _instance = GreetingService._internal();
  factory GreetingService() => _instance;
  GreetingService._internal();

  static GreetingService get instance => _instance;

  final Random _random = Random();

  /// Get a random greeting based on current time
  String getTimeBasedGreeting() {
    final now = DateTime.now();
    final hour = now.hour;

    List<String> greetings;

    if (hour >= 5 && hour < 12) {
      // Morning: 5 AM - 12 PM
      greetings = AppStrings.morningGreetings;
    } else if (hour >= 12 && hour < 17) {
      // Afternoon: 12 PM - 5 PM
      greetings = AppStrings.afternoonGreetings;
    } else if (hour >= 17 && hour < 21) {
      // Evening: 5 PM - 9 PM
      greetings = AppStrings.eveningGreetings;
    } else {
      // Night: 9 PM - 5 AM
      greetings = AppStrings.nightGreetings;
    }

    return greetings[_random.nextInt(greetings.length)];
  }

  /// Get a random general greeting (not time-based)
  String getGeneralGreeting() {
    return AppStrings.generalGreetings[_random.nextInt(
      AppStrings.generalGreetings.length,
    )];
  }

  /// Get a mixed greeting (combines time-based and general greetings)
  String getMixedGreeting() {
    // 70% chance for time-based greeting, 30% for general greeting
    if (_random.nextDouble() < 0.7) {
      return getTimeBasedGreeting();
    } else {
      return getGeneralGreeting();
    }
  }

  /// Get greeting with user's name
  String getPersonalizedGreeting(String? userName) {
    // Use full name instead of just first name, with fallback to 'User'
    final fullName = userName?.trim().isNotEmpty == true ? userName! : 'User';

    // Vary the personal greeting format - removed commas and exclamation marks
    final greetingFormats = [
      'Hi $fullName',
      'Hello $fullName',
      'Hey $fullName',
      'Good to see you $fullName',
      'Welcome $fullName',
    ];

    return greetingFormats[_random.nextInt(greetingFormats.length)];
  }

  /// Get the main greeting message (what appears as the larger text)
  String getMainGreeting() {
    return getMixedGreeting();
  }

  /// Get motivational quotes occasionally
  String getMotivationalQuote() {
    final quotes = [
      'Let\'s make today count!',
      'Time to be productive!',
      'Great day to get things done!',
      'Let\'s achieve our goals today!',
      'Stay focused and motivated!',
      'Today is full of opportunities!',
      'Time to create something amazing!',
      'Success starts today!',
      'Let\'s make today meaningful!',
      'Every day is a new opportunity!',
    ];

    return quotes[_random.nextInt(quotes.length)];
  }

  /// Get a complete greeting set (personal + main greeting)
  GreetingSet getCompleteGreeting(String? userName) {
    return GreetingSet(
      personalGreeting: getPersonalizedGreeting(userName),
      mainGreeting: getMainGreeting(),
    );
  }

  /// Get greeting with occasional motivational quote
  GreetingSet getGreetingWithMotivation(String? userName) {
    // 20% chance to show motivational quote instead of regular greeting
    final showMotivation = _random.nextDouble() < 0.2;

    return GreetingSet(
      personalGreeting: getPersonalizedGreeting(userName),
      mainGreeting: showMotivation ? getMotivationalQuote() : getMainGreeting(),
    );
  }

  /// Get special greetings for specific days
  String getSpecialDayGreeting() {
    final now = DateTime.now();
    final dayOfWeek = now.weekday;

    switch (dayOfWeek) {
      case DateTime.monday:
        return _random.nextBool()
            ? 'Monday Motivation!'
            : 'Great Start to the Week!';
      case DateTime.friday:
        return _random.nextBool()
            ? 'Friday Feeling!'
            : 'Productive End to the Week!';
      case DateTime.saturday:
      case DateTime.sunday:
        return _random.nextBool() ? 'Happy Weekend!' : 'Enjoy Your Weekend!';
      default:
        return getMixedGreeting();
    }
  }

  /// Get greeting that considers special days
  GreetingSet getSmartGreeting(String? userName) {
    // 30% chance to use special day greeting
    final useSpecialDay = _random.nextDouble() < 0.3;

    return GreetingSet(
      personalGreeting: getPersonalizedGreeting(userName),
      mainGreeting: useSpecialDay ? getSpecialDayGreeting() : getMainGreeting(),
    );
  }
}

/// Data class to hold greeting information
class GreetingSet {
  final String personalGreeting;
  final String mainGreeting;

  GreetingSet({required this.personalGreeting, required this.mainGreeting});
}
