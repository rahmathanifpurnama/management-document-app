import 'package:flutter/material.dart';
import '../../models/activity_model.dart';
import '../../models/activity_types.dart';
import 'polymorphic_activity_tile.dart';

/// Factory widget that creates the appropriate activity tile based on activity type
class ActivityTileFactory extends StatelessWidget {
  final BaseActivity activity;
  final bool isLast;
  final VoidCallback? onTap;
  final bool showContextInfo;
  final bool showTimestamp;

  const ActivityTileFactory({
    super.key,
    required this.activity,
    this.isLast = false,
    this.onTap,
    this.showContextInfo = true,
    this.showTimestamp = true,
  });

  @override
  Widget build(BuildContext context) {
    // Return specialized tile based on activity type
    if (activity is AuthActivity) {
      return AuthActivityTile(
        activity: activity,
        isLast: isLast,
        onTap: onTap,
      );
    }
    
    if (activity is FileActivity) {
      return FileActivityTile(
        activity: activity,
        isLast: isLast,
        onTap: onTap,
      );
    }
    
    // Default polymorphic tile for other activity types
    return PolymorphicActivityTile(
      activity: activity,
      isLast: isLast,
      onTap: onTap,
      showContextInfo: showContextInfo,
      showTimestamp: showTimestamp,
    );
  }
}

/// Enhanced activity list widget that uses polymorphic rendering
class PolymorphicActivityList extends StatelessWidget {
  final List<BaseActivity> activities;
  final Function(BaseActivity)? onActivityTap;
  final bool showContextInfo;
  final bool showTimestamp;
  final Widget? emptyState;
  final EdgeInsetsGeometry? padding;

  const PolymorphicActivityList({
    super.key,
    required this.activities,
    this.onActivityTap,
    this.showContextInfo = true,
    this.showTimestamp = true,
    this.emptyState,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return emptyState ?? const Center(
        child: Text('No activities found'),
      );
    }

    return ListView.builder(
      padding: padding,
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;

        return ActivityTileFactory(
          activity: activity,
          isLast: isLast,
          onTap: onActivityTap != null ? () => onActivityTap!(activity) : null,
          showContextInfo: showContextInfo,
          showTimestamp: showTimestamp,
        );
      },
    );
  }
}

/// Activity container with consistent styling
class ActivityListContainer extends StatelessWidget {
  final List<BaseActivity> activities;
  final Function(BaseActivity)? onActivityTap;
  final bool showContextInfo;
  final bool showTimestamp;
  final Widget? emptyState;
  final bool showAnimations;

  const ActivityListContainer({
    super.key,
    required this.activities,
    this.onActivityTap,
    this.showContextInfo = true,
    this.showTimestamp = true,
    this.emptyState,
    this.showAnimations = true,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: emptyState ?? const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 48,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                'No activities found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          final isLast = index == activities.length - 1;

          Widget tile = ActivityTileFactory(
            activity: activity,
            isLast: isLast,
            onTap: onActivityTap != null ? () => onActivityTap!(activity) : null,
            showContextInfo: showContextInfo,
            showTimestamp: showTimestamp,
          );

          // Add animations if enabled
          if (showAnimations) {
            return TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 200 + (index * 50)),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Opacity(
                    opacity: value,
                    child: child,
                  ),
                );
              },
              child: tile,
            );
          }

          return tile;
        }).toList(),
      ),
    );
  }
}

/// Activity group widget for categorizing activities
class ActivityGroup extends StatelessWidget {
  final String title;
  final List<BaseActivity> activities;
  final Function(BaseActivity)? onActivityTap;
  final bool isExpanded;
  final VoidCallback? onToggleExpanded;
  final IconData? icon;
  final Color? color;

  const ActivityGroup({
    super.key,
    required this.title,
    required this.activities,
    this.onActivityTap,
    this.isExpanded = true,
    this.onToggleExpanded,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group header
        InkWell(
          onTap: onToggleExpanded,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: color ?? Colors.grey.shade600,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color ?? Colors.grey.shade800,
                    ),
                  ),
                ),
                Text(
                  '${activities.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                if (onToggleExpanded != null)
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Colors.grey.shade600,
                  ),
              ],
            ),
          ),
        ),
        
        // Group content
        if (isExpanded) ...[
          const SizedBox(height: 8),
          ActivityListContainer(
            activities: activities,
            onActivityTap: onActivityTap,
            showAnimations: false, // Disable animations in groups
          ),
        ],
      ],
    );
  }
}
