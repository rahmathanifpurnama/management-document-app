import 'dart:math';
import '../services/greeting_service.dart';

/// Strategy pattern implementation for different greeting types
/// Allows for polymorphic behavior based on context and user preferences

// ============================================================================
// BASE STRATEGY
// ============================================================================

/// Abstract base class for greeting strategies
abstract class GreetingStrategy {
  /// Generate a greeting set for the given user
  GreetingSet generateGreeting(String? userName);

  /// Get strategy name for identification
  String get strategyName;

  /// Get strategy priority (higher = more preferred)
  int get priority => 0;

  /// Check if this strategy should be used in current context
  bool shouldUse(Map<String, dynamic> context) => true;
}

// ============================================================================
// CONCRETE STRATEGIES
// ============================================================================

/// Standard greeting strategy - basic time-based greetings
class StandardGreetingStrategy extends GreetingStrategy {
  final Random _random = Random();

  @override
  GreetingSet generateGreeting(String? userName) {
    final hour = DateTime.now().hour;
    final personalGreeting = _getTimeBasedGreeting();
    final mainGreeting = _getWelcomeMessage(userName);

    return GreetingSet(
      personalGreeting: personalGreeting,
      mainGreeting: mainGreeting,
    );
  }

  String _getTimeBasedGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getWelcomeMessage(String? userName) {
    final name = userName?.trim().isNotEmpty == true ? userName! : 'User';
    final welcomeFormats = [
      'Welcome back, $name',
      'Hello $name',
      'Nice to see you, $name',
      'Welcome $name',
    ];
    
    return welcomeFormats[_random.nextInt(welcomeFormats.length)];
  }

  @override
  String get strategyName => 'Standard';

  @override
  int get priority => 5;
}

/// Motivational greeting strategy - includes inspirational quotes
class MotivationalGreetingStrategy extends GreetingStrategy {
  final Random _random = Random();

  final List<String> _motivationalQuotes = [
    'Every document tells a story',
    'Organization is the key to success',
    'Your files, perfectly managed',
    'Efficiency starts with good organization',
    'Making document management simple',
    'Your digital workspace, optimized',
    'Streamline your workflow today',
    'Documents organized, mind at peace',
  ];

  @override
  GreetingSet generateGreeting(String? userName) {
    final name = userName?.trim().isNotEmpty == true ? userName! : 'User';
    final personalGreeting = _getPersonalizedGreeting(name);
    final mainGreeting = _getMotivationalMessage();

    return GreetingSet(
      personalGreeting: personalGreeting,
      mainGreeting: mainGreeting,
    );
  }

  String _getPersonalizedGreeting(String name) {
    final greetings = [
      'Hi $name',
      'Hello $name',
      'Welcome $name',
      'Good to see you $name',
    ];
    
    return greetings[_random.nextInt(greetings.length)];
  }

  String _getMotivationalMessage() {
    return _motivationalQuotes[_random.nextInt(_motivationalQuotes.length)];
  }

  @override
  String get strategyName => 'Motivational';

  @override
  int get priority => 7;

  @override
  bool shouldUse(Map<String, dynamic> context) {
    // Use motivational greetings 30% of the time
    return _random.nextDouble() < 0.3;
  }
}

/// Casual greeting strategy - informal and friendly
class CasualGreetingStrategy extends GreetingStrategy {
  final Random _random = Random();

  final List<String> _casualGreetings = [
    'Hey there',
    'What\'s up',
    'Howdy',
    'Hi there',
    'Hello',
  ];

  final List<String> _casualMessages = [
    'Ready to get organized?',
    'Let\'s manage some files',
    'Time to get productive',
    'Your documents await',
    'Let\'s dive in',
    'Ready to work?',
  ];

  @override
  GreetingSet generateGreeting(String? userName) {
    final name = userName?.trim().isNotEmpty == true ? userName! : '';
    final personalGreeting = _getCasualGreeting(name);
    final mainGreeting = _getCasualMessage();

    return GreetingSet(
      personalGreeting: personalGreeting,
      mainGreeting: mainGreeting,
    );
  }

  String _getCasualGreeting(String name) {
    final greeting = _casualGreetings[_random.nextInt(_casualGreetings.length)];
    return name.isNotEmpty ? '$greeting $name' : greeting;
  }

  String _getCasualMessage() {
    return _casualMessages[_random.nextInt(_casualMessages.length)];
  }

  @override
  String get strategyName => 'Casual';

  @override
  int get priority => 3;

  @override
  bool shouldUse(Map<String, dynamic> context) {
    // Use casual greetings for younger users or in informal contexts
    final userAge = context['userAge'] as int?;
    final isInformalContext = context['isInformal'] as bool? ?? false;
    
    return (userAge != null && userAge < 30) || isInformalContext;
  }
}

/// Professional greeting strategy - formal and business-like
class ProfessionalGreetingStrategy extends GreetingStrategy {
  final Random _random = Random();

  @override
  GreetingSet generateGreeting(String? userName) {
    final name = userName?.trim().isNotEmpty == true ? userName! : 'User';
    final personalGreeting = _getProfessionalGreeting();
    final mainGreeting = _getProfessionalMessage(name);

    return GreetingSet(
      personalGreeting: personalGreeting,
      mainGreeting: mainGreeting,
    );
  }

  String _getProfessionalGreeting() {
    final hour = DateTime.now().hour;
    
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getProfessionalMessage(String name) {
    final messages = [
      'Welcome to your document management system, $name',
      'Your professional workspace awaits, $name',
      'Manage your documents efficiently, $name',
      'Your organized workspace, $name',
    ];
    
    return messages[_random.nextInt(messages.length)];
  }

  @override
  String get strategyName => 'Professional';

  @override
  int get priority => 8;

  @override
  bool shouldUse(Map<String, dynamic> context) {
    // Use professional greetings in business contexts or for admin users
    final userRole = context['userRole'] as String?;
    final isBusinessContext = context['isBusiness'] as bool? ?? false;
    
    return userRole == 'admin' || isBusinessContext;
  }
}

/// Special occasion greeting strategy - holiday and event-based
class SpecialOccasionGreetingStrategy extends GreetingStrategy {
  final Random _random = Random();

  @override
  GreetingSet generateGreeting(String? userName) {
    final name = userName?.trim().isNotEmpty == true ? userName! : 'User';
    final occasion = _getCurrentOccasion();
    
    if (occasion != null) {
      return GreetingSet(
        personalGreeting: _getOccasionGreeting(occasion),
        mainGreeting: _getOccasionMessage(name, occasion),
      );
    }

    // Fallback to standard greeting
    return StandardGreetingStrategy().generateGreeting(userName);
  }

  String? _getCurrentOccasion() {
    final now = DateTime.now();
    final month = now.month;
    final day = now.day;

    // Check for holidays and special occasions
    if (month == 1 && day == 1) return 'New Year';
    if (month == 12 && day >= 20 && day <= 31) return 'Holiday Season';
    if (month == 7 && day == 4) return 'Independence Day';
    if (month == 10 && day == 31) return 'Halloween';
    if (month == 11 && day >= 20 && day <= 30) return 'Thanksgiving';
    
    // Check for day of week special occasions
    final weekday = now.weekday;
    if (weekday == DateTime.monday) return 'Monday Motivation';
    if (weekday == DateTime.friday) return 'Friday Finish';

    return null;
  }

  String _getOccasionGreeting(String occasion) {
    switch (occasion) {
      case 'New Year':
        return 'Happy New Year';
      case 'Holiday Season':
        return 'Happy Holidays';
      case 'Independence Day':
        return 'Happy 4th of July';
      case 'Halloween':
        return 'Happy Halloween';
      case 'Thanksgiving':
        return 'Happy Thanksgiving';
      case 'Monday Motivation':
        return 'Monday Motivation';
      case 'Friday Finish':
        return 'Friday Finish Strong';
      default:
        return 'Special Day';
    }
  }

  String _getOccasionMessage(String name, String occasion) {
    switch (occasion) {
      case 'New Year':
        return 'New year, new organization goals, $name';
      case 'Holiday Season':
        return 'Wishing you organized holidays, $name';
      case 'Monday Motivation':
        return 'Let\'s start the week organized, $name';
      case 'Friday Finish':
        return 'Finish the week strong, $name';
      default:
        return 'Hope you have a great day, $name';
    }
  }

  @override
  String get strategyName => 'Special Occasion';

  @override
  int get priority => 10; // Highest priority when applicable

  @override
  bool shouldUse(Map<String, dynamic> context) {
    return _getCurrentOccasion() != null;
  }
}

// ============================================================================
// STRATEGY MANAGER
// ============================================================================

/// Manager class that selects appropriate greeting strategy
class GreetingStrategyManager {
  static final GreetingStrategyManager _instance = GreetingStrategyManager._internal();
  factory GreetingStrategyManager() => _instance;
  GreetingStrategyManager._internal();

  static GreetingStrategyManager get instance => _instance;

  final List<GreetingStrategy> _strategies = [
    StandardGreetingStrategy(),
    MotivationalGreetingStrategy(),
    CasualGreetingStrategy(),
    ProfessionalGreetingStrategy(),
    SpecialOccasionGreetingStrategy(),
  ];

  /// Get the best greeting strategy for the given context
  GreetingStrategy selectStrategy(Map<String, dynamic> context) {
    // Filter strategies that should be used in current context
    final applicableStrategies = _strategies
        .where((strategy) => strategy.shouldUse(context))
        .toList();

    if (applicableStrategies.isEmpty) {
      return StandardGreetingStrategy();
    }

    // Sort by priority (highest first)
    applicableStrategies.sort((a, b) => b.priority.compareTo(a.priority));

    return applicableStrategies.first;
  }

  /// Generate greeting using the best strategy for context
  GreetingSet generateContextualGreeting(
    String? userName,
    Map<String, dynamic> context,
  ) {
    final strategy = selectStrategy(context);
    return strategy.generateGreeting(userName);
  }

  /// Add a custom strategy
  void addStrategy(GreetingStrategy strategy) {
    _strategies.add(strategy);
  }

  /// Remove a strategy
  void removeStrategy(GreetingStrategy strategy) {
    _strategies.remove(strategy);
  }

  /// Get all available strategies
  List<GreetingStrategy> get availableStrategies => List.unmodifiable(_strategies);
}
