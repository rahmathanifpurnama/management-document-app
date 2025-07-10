import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sync_providers.dart';

/// Sync indicator widget for showing sync status using Riverpod
class SyncIndicatorWidget extends ConsumerWidget {
  final bool showText;
  final double size;

  const SyncIndicatorWidget({
    super.key,
    this.showText = true,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showSyncIndicator = ref.watch(showSyncIndicatorProvider);

    if (!showSyncIndicator) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'Syncing...',
            style: TextStyle(fontSize: size * 0.8, color: Colors.blue),
          ),
        ],
      ],
    );
  }
}
