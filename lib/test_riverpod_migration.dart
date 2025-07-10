import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/settings/providers/settings_providers.dart';
import 'features/file_selection/providers/file_selection_providers.dart';
import 'features/notification/providers/notification_providers.dart';

/// Test widget to verify Riverpod providers work correctly
class TestRiverpodMigration extends ConsumerWidget {
  const TestRiverpodMigration({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Test settings provider
    final settings = ref.watch(settingsProvider);
    final settingsActions = ref.watch(settingsActionsProvider);

    // Test file selection provider
    final fileSelection = ref.watch(fileSelectionProvider);
    final fileSelectionActions = ref.watch(fileSelectionActionsProvider);

    // Test notification provider
    final notification = ref.watch(notificationProvider);
    final notificationActions = ref.watch(notificationActionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riverpod Migration Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Settings test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Settings Provider Test', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Dark Mode: ${settings.darkModeEnabled}'),
                    Text('Language: ${settings.selectedLanguage}'),
                    Text('Notifications: ${settings.notificationsEnabled}'),
                    Text('Loading: ${settings.isLoading}'),
                    ElevatedButton(
                      onPressed: () => settingsActions.setDarkModeEnabled(!settings.darkModeEnabled),
                      child: const Text('Toggle Dark Mode'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // File Selection test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('File Selection Provider Test', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Selection Mode: ${fileSelection.isSelectionMode}'),
                    Text('Selected Count: ${fileSelection.selectedCount}'),
                    Text('Available Files: ${fileSelection.availableFiles.length}'),
                    ElevatedButton(
                      onPressed: () => fileSelectionActions.exitSelectionMode(),
                      child: const Text('Exit Selection Mode'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Notification test
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Notification Provider Test', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Loading: ${notification.isLoading}'),
                    Text('Notifications Count: ${notification.notifications.length}'),
                    Text('Unread Count: ${notification.unreadCount}'),
                    Text('Has Email Warning: ${notification.hasUnverifiedEmailWarning}'),
                    ElevatedButton(
                      onPressed: () => notificationActions.refresh(),
                      child: const Text('Refresh Notifications'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
