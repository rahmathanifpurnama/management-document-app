import 'package:intl/intl.dart';

/// Utility class for formatting dates and times
class DateFormatter {
  // Date format patterns
  static const String _defaultDateFormat = 'dd MMM yyyy';
  static const String _defaultTimeFormat = 'HH:mm';
  static const String _defaultDateTimeFormat = 'dd MMM yyyy, HH:mm';
  static const String _fullDateTimeFormat = 'EEEE, dd MMMM yyyy HH:mm';
  static const String _shortDateFormat = 'dd/MM/yyyy';
  static const String _isoDateFormat = 'yyyy-MM-dd';
  static const String _fileNameDateFormat = 'yyyyMMdd_HHmmss';

  /// Format date to default format (e.g., "15 Jan 2024")
  static String formatDate(DateTime date) {
    return DateFormat(_defaultDateFormat).format(date);
  }

  /// Format time to default format (e.g., "14:30")
  static String formatTime(DateTime date) {
    return DateFormat(_defaultTimeFormat).format(date);
  }

  /// Format date and time to default format (e.g., "15 Jan 2024, 14:30")
  static String formatDateTime(DateTime date) {
    return DateFormat(_defaultDateTimeFormat).format(date);
  }

  /// Format date to full format (e.g., "Monday, 15 January 2024 14:30")
  static String formatFullDateTime(DateTime date) {
    return DateFormat(_fullDateTimeFormat).format(date);
  }

  /// Format date to short format (e.g., "15/01/2024")
  static String formatShortDate(DateTime date) {
    return DateFormat(_shortDateFormat).format(date);
  }

  /// Format date to ISO format (e.g., "2024-01-15")
  static String formatIsoDate(DateTime date) {
    return DateFormat(_isoDateFormat).format(date);
  }

  /// Format date for file names (e.g., "20240115_143000")
  static String formatForFileName(DateTime date) {
    return DateFormat(_fileNameDateFormat).format(date);
  }

  /// Format relative time (e.g., "2 hours ago", "Yesterday", "Last week")
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes minute${minutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours hour${hours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks == 1 ? '' : 's'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }

  /// Format relative time with more precision
  static String formatRelativeDetailed(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 30) {
      return 'Just now';
    } else if (difference.inMinutes < 1) {
      return '${difference.inSeconds} seconds ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  /// Check if date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Check if date is yesterday
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  /// Check if date is this week
  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Check if date is this month
  static bool isThisMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  /// Check if date is this year
  static bool isThisYear(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year;
  }

  /// Get time period description
  static String getTimePeriod(DateTime date) {
    if (isToday(date)) {
      return 'Today';
    } else if (isYesterday(date)) {
      return 'Yesterday';
    } else if (isThisWeek(date)) {
      return 'This Week';
    } else if (isThisMonth(date)) {
      return 'This Month';
    } else if (isThisYear(date)) {
      return 'This Year';
    } else {
      return 'Older';
    }
  }

  /// Format duration (e.g., "2h 30m", "45s")
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays}d ${duration.inHours % 24}h';
    } else if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Parse date from string with multiple format attempts
  static DateTime? parseDate(String dateString) {
    final formats = [
      _defaultDateTimeFormat,
      _defaultDateFormat,
      _shortDateFormat,
      _isoDateFormat,
      'yyyy-MM-dd HH:mm:ss',
      'dd-MM-yyyy',
      'MM/dd/yyyy',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Continue to next format
      }
    }

    // Try parsing as ISO string
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  /// Get age from date
  static String getAge(DateTime birthDate) {
    final now = DateTime.now();
    final age = now.difference(birthDate);

    if (age.inDays < 365) {
      final months = (age.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'}';
    } else {
      final years = (age.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'}';
    }
  }

  /// Format date range
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    if (startDate.year == endDate.year &&
        startDate.month == endDate.month &&
        startDate.day == endDate.day) {
      return formatDate(startDate);
    } else if (startDate.year == endDate.year &&
        startDate.month == endDate.month) {
      return '${startDate.day} - ${formatDate(endDate)}';
    } else if (startDate.year == endDate.year) {
      return '${DateFormat('dd MMM').format(startDate)} - ${formatDate(endDate)}';
    } else {
      return '${formatDate(startDate)} - ${formatDate(endDate)}';
    }
  }

  /// Get start of day
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get end of day
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// Get start of week (Monday)
  static DateTime startOfWeek(DateTime date) {
    final daysFromMonday = date.weekday - 1;
    return startOfDay(date.subtract(Duration(days: daysFromMonday)));
  }

  /// Get end of week (Sunday)
  static DateTime endOfWeek(DateTime date) {
    final daysToSunday = 7 - date.weekday;
    return endOfDay(date.add(Duration(days: daysToSunday)));
  }
}
