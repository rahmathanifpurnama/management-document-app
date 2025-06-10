import 'dart:math';

/// Utility class for formatting file sizes
class FileSizeFormatter {
  /// Format bytes to human readable format (e.g., 1.5 MB, 2.3 GB)
  static String formatBytes(int bytes, {int decimals = 1}) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Format bytes to human readable format with more precise control
  static String formatBytesDetailed(int bytes) {
    if (bytes <= 0) return '0 bytes';
    if (bytes == 1) return '1 byte';
    
    const suffixes = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB'];
    final i = (log(bytes) / log(1024)).floor();
    final size = bytes / pow(1024, i);
    
    // Use different decimal places based on size
    int decimals;
    if (i == 0) {
      decimals = 0; // bytes - no decimals
    } else if (size < 10) {
      decimals = 2; // less than 10 - 2 decimals
    } else if (size < 100) {
      decimals = 1; // less than 100 - 1 decimal
    } else {
      decimals = 0; // 100 or more - no decimals
    }
    
    return '${size.toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  /// Convert bytes to KB
  static double bytesToKB(int bytes) {
    return bytes / 1024;
  }

  /// Convert bytes to MB
  static double bytesToMB(int bytes) {
    return bytes / (1024 * 1024);
  }

  /// Convert bytes to GB
  static double bytesToGB(int bytes) {
    return bytes / (1024 * 1024 * 1024);
  }

  /// Get file size category
  static String getSizeCategory(int bytes) {
    if (bytes < 1024) {
      return 'Very Small'; // < 1 KB
    } else if (bytes < 1024 * 1024) {
      return 'Small'; // < 1 MB
    } else if (bytes < 10 * 1024 * 1024) {
      return 'Medium'; // < 10 MB
    } else if (bytes < 100 * 1024 * 1024) {
      return 'Large'; // < 100 MB
    } else {
      return 'Very Large'; // >= 100 MB
    }
  }

  /// Check if file size is within limit
  static bool isWithinLimit(int bytes, int limitInMB) {
    return bytes <= (limitInMB * 1024 * 1024);
  }

  /// Get progress percentage for file operations
  static String formatProgress(int current, int total) {
    if (total <= 0) return '0%';
    final percentage = (current / total * 100).clamp(0, 100);
    return '${percentage.toStringAsFixed(0)}%';
  }

  /// Format transfer speed (bytes per second)
  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond <= 0) return '0 B/s';
    
    const suffixes = ['B/s', 'KB/s', 'MB/s', 'GB/s'];
    final i = (log(bytesPerSecond) / log(1024)).floor().clamp(0, suffixes.length - 1);
    final speed = bytesPerSecond / pow(1024, i);
    
    return '${speed.toStringAsFixed(1)} ${suffixes[i]}';
  }

  /// Estimate time remaining for file transfer
  static String estimateTimeRemaining(int remainingBytes, double bytesPerSecond) {
    if (bytesPerSecond <= 0 || remainingBytes <= 0) return 'Unknown';
    
    final seconds = remainingBytes / bytesPerSecond;
    
    if (seconds < 60) {
      return '${seconds.round()}s';
    } else if (seconds < 3600) {
      final minutes = (seconds / 60).round();
      return '${minutes}m';
    } else {
      final hours = (seconds / 3600).floor();
      final minutes = ((seconds % 3600) / 60).round();
      return '${hours}h ${minutes}m';
    }
  }

  /// Compare file sizes
  static int compareFileSize(int size1, int size2) {
    return size1.compareTo(size2);
  }

  /// Get human readable size with units for sorting
  static String formatForSorting(int bytes) {
    // Returns format like "000001024KB" for sorting purposes
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    final i = (log(bytes) / log(1024)).floor().clamp(0, suffixes.length - 1);
    final size = bytes / pow(1024, i);
    
    // Pad with zeros for proper sorting
    final sizeStr = size.toStringAsFixed(0).padLeft(8, '0');
    return '$sizeStr${suffixes[i]}';
  }

  /// Check if file is considered large (> 50MB)
  static bool isLargeFile(int bytes) {
    return bytes > (50 * 1024 * 1024);
  }

  /// Check if file is considered huge (> 500MB)
  static bool isHugeFile(int bytes) {
    return bytes > (500 * 1024 * 1024);
  }

  /// Get appropriate warning message for file size
  static String? getSizeWarning(int bytes) {
    if (isHugeFile(bytes)) {
      return 'This is a very large file (${formatBytes(bytes)}). Upload may take a long time.';
    } else if (isLargeFile(bytes)) {
      return 'This is a large file (${formatBytes(bytes)}). Please ensure stable internet connection.';
    }
    return null;
  }
}
