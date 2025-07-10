import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';

class StartupOptimizer {
  static DateTime? _appStartTime;
  static DateTime? _firstFrameTime;
  static final Map<String, DateTime> _milestones = {};
  static final List<StartupTask> _deferredTasks = [];
  static bool _isInitialized = false;

  /// Mark app start time
  static void markAppStart() {
    _appStartTime = DateTime.now();
    debugPrint('🚀 App Start: ${_appStartTime!.millisecondsSinceEpoch}');
  }

  /// Mark first frame rendered
  static void markFirstFrame() {
    _firstFrameTime = DateTime.now();
    if (_appStartTime != null) {
      final startupTime = _firstFrameTime!.difference(_appStartTime!);
      debugPrint('⚡ Startup Time: ${startupTime.inMilliseconds}ms');
    }
    
    // Execute deferred tasks after first frame
    _executeDeferredTasks();
  }

  /// Mark milestone
  static void markMilestone(String name) {
    _milestones[name] = DateTime.now();
    if (_appStartTime != null) {
      final elapsed = _milestones[name]!.difference(_appStartTime!);
      debugPrint('📍 Milestone $name: ${elapsed.inMilliseconds}ms');
    }
  }

  /// Add task to be executed after first frame
  static void deferTask(String name, Future<void> Function() task, {int priority = 0}) {
    _deferredTasks.add(StartupTask(
      name: name,
      task: task,
      priority: priority,
    ));
    
    // Sort by priority (higher priority first)
    _deferredTasks.sort((a, b) => b.priority.compareTo(a.priority));
  }

  /// Execute deferred tasks
  static void _executeDeferredTasks() {
    if (_deferredTasks.isEmpty) return;
    
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      debugPrint('🔄 Executing ${_deferredTasks.length} deferred tasks...');
      
      for (final deferredTask in _deferredTasks) {
        try {
          final startTime = DateTime.now();
          await deferredTask.task();
          final duration = DateTime.now().difference(startTime);
          debugPrint('✅ Deferred task "${deferredTask.name}" completed in ${duration.inMilliseconds}ms');
        } catch (e) {
          debugPrint('❌ Deferred task "${deferredTask.name}" failed: $e');
        }
      }
      
      _deferredTasks.clear();
      debugPrint('🎉 All deferred tasks completed');
    });
  }

  /// Initialize startup optimization
  static void initialize() {
    if (_isInitialized) return;
    
    markAppStart();
    
    // Mark first frame when it's rendered
    SchedulerBinding.instance.addPostFrameCallback((_) {
      markFirstFrame();
    });
    
    _isInitialized = true;
  }

  /// Get startup metrics
  static StartupMetrics getMetrics() {
    return StartupMetrics(
      appStartTime: _appStartTime,
      firstFrameTime: _firstFrameTime,
      milestones: Map.from(_milestones),
    );
  }

  /// Clear all metrics
  static void clearMetrics() {
    _appStartTime = null;
    _firstFrameTime = null;
    _milestones.clear();
    _deferredTasks.clear();
    _isInitialized = false;
  }

  /// Get performance recommendations
  static List<String> getPerformanceRecommendations() {
    final recommendations = <String>[];
    final metrics = getMetrics();
    
    if (metrics.startupDuration != null) {
      final startupMs = metrics.startupDuration!.inMilliseconds;
      
      if (startupMs > 3000) {
        recommendations.add('Startup time is slow (${startupMs}ms). Consider deferring non-critical initialization.');
      } else if (startupMs > 1500) {
        recommendations.add('Startup time is moderate (${startupMs}ms). Look for optimization opportunities.');
      }
    }
    
    if (_milestones.isNotEmpty) {
      final sortedMilestones = _milestones.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      for (int i = 1; i < sortedMilestones.length; i++) {
        final current = sortedMilestones[i];
        final previous = sortedMilestones[i - 1];
        final gap = current.value.difference(previous.value);
        
        if (gap.inMilliseconds > 500) {
          recommendations.add('Large gap (${gap.inMilliseconds}ms) between "${previous.key}" and "${current.key}"');
        }
      }
    }
    
    return recommendations;
  }

  /// Optimize app startup by deferring common tasks
  static void optimizeCommonTasks() {
    // Defer analytics initialization
    deferTask('analytics_init', () async {
      // Analytics initialization code would go here
      await Future.delayed(const Duration(milliseconds: 100));
    }, priority: 1);
    
    // Defer crash reporting setup
    deferTask('crash_reporting_init', () async {
      // Crash reporting initialization code would go here
      await Future.delayed(const Duration(milliseconds: 50));
    }, priority: 2);
    
    // Defer non-critical service initialization
    deferTask('background_services_init', () async {
      // Background services initialization code would go here
      await Future.delayed(const Duration(milliseconds: 200));
    }, priority: 0);
    
    // Defer cache warming
    deferTask('cache_warming', () async {
      // Cache warming code would go here
      await Future.delayed(const Duration(milliseconds: 300));
    }, priority: -1);
  }
}

class StartupTask {
  final String name;
  final Future<void> Function() task;
  final int priority;

  StartupTask({
    required this.name,
    required this.task,
    required this.priority,
  });
}

class StartupMetrics {
  final DateTime? appStartTime;
  final DateTime? firstFrameTime;
  final Map<String, DateTime> milestones;

  StartupMetrics({
    required this.appStartTime,
    required this.firstFrameTime,
    required this.milestones,
  });

  Duration? get startupDuration {
    if (appStartTime != null && firstFrameTime != null) {
      return firstFrameTime!.difference(appStartTime!);
    }
    return null;
  }

  /// Get milestone durations relative to app start
  Map<String, Duration> get milestoneDurations {
    if (appStartTime == null) return {};
    
    return milestones.map((name, time) => 
      MapEntry(name, time.difference(appStartTime!))
    );
  }

  /// Get formatted metrics report
  String getFormattedReport() {
    final buffer = StringBuffer();
    buffer.writeln('🚀 Startup Metrics Report');
    buffer.writeln('=' * 30);
    
    if (startupDuration != null) {
      buffer.writeln('⚡ Total Startup Time: ${startupDuration!.inMilliseconds}ms');
    }
    
    if (milestones.isNotEmpty) {
      buffer.writeln('\n📍 Milestones:');
      final sortedMilestones = milestoneDurations.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      
      for (final entry in sortedMilestones) {
        buffer.writeln('  ${entry.key}: ${entry.value.inMilliseconds}ms');
      }
    }
    
    final recommendations = StartupOptimizer.getPerformanceRecommendations();
    if (recommendations.isNotEmpty) {
      buffer.writeln('\n💡 Recommendations:');
      for (final recommendation in recommendations) {
        buffer.writeln('  • $recommendation');
      }
    }
    
    return buffer.toString();
  }
}
