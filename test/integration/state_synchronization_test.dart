import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:managementdoc/features/settings/providers/settings_providers.dart';
import 'package:managementdoc/features/file_selection/providers/file_selection_providers.dart';
import 'package:managementdoc/features/notification/providers/notification_providers.dart';
import 'package:managementdoc/features/documents/bloc/document_bloc.dart';
import 'package:managementdoc/features/upload/bloc/upload_bloc.dart';
import 'package:managementdoc/features/categories/bloc/category_bloc.dart';

void main() {
  group('State Synchronization Tests', () {
    
    test('Riverpod state changes trigger BLoC events correctly', () async {
      final container = ProviderContainer();
      
      // Create mock BLoC instances
      late DocumentBloc documentBloc;
      late UploadBloc uploadBloc;
      
      // Set up BLoC instances
      documentBloc = DocumentBloc();
      uploadBloc = UploadBloc();
      
      // Test 1: File selection change triggers upload BLoC event
      var uploadEventTriggered = false;
      uploadBloc.stream.listen((state) {
        if (state is UploadFileSelected) {
          uploadEventTriggered = true;
        }
      });
      
      // Trigger file selection in Riverpod
      container.read(fileSelectionProvider.notifier).selectFile('test_file.pdf');
      
      // Wait for async operations
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify upload BLoC received the event
      expect(uploadEventTriggered, isTrue);
      
      // Test 2: Settings change triggers document refresh
      var documentRefreshTriggered = false;
      documentBloc.stream.listen((state) {
        if (state is DocumentLoading) {
          documentRefreshTriggered = true;
        }
      });
      
      // Trigger settings change
      container.read(settingsProvider.notifier).updateTheme(ThemeMode.dark);
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify document BLoC refreshed
      expect(documentRefreshTriggered, isTrue);
      
      // Cleanup
      await documentBloc.close();
      await uploadBloc.close();
      container.dispose();
    });

    test('BLoC state changes update Riverpod computed providers', () async {
      final container = ProviderContainer();
      
      // Create BLoC instance
      final documentBloc = DocumentBloc();
      
      // Test: Document BLoC state change updates notification provider
      var notificationUpdated = false;
      container.listen(notificationProvider, (previous, next) {
        if (next.hasNewDocuments) {
          notificationUpdated = true;
        }
      });
      
      // Trigger document loaded state in BLoC
      documentBloc.add(const LoadDocuments());
      
      // Wait for state change
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Verify notification provider was updated
      expect(notificationUpdated, isTrue);
      
      // Cleanup
      await documentBloc.close();
      container.dispose();
    });

    test('Multiple provider updates maintain consistency', () async {
      final container = ProviderContainer();
      
      // Track state changes
      var settingsChangeCount = 0;
      var fileSelectionChangeCount = 0;
      var notificationChangeCount = 0;
      
      // Listen to multiple providers
      container.listen(settingsProvider, (previous, next) {
        settingsChangeCount++;
      });
      
      container.listen(fileSelectionProvider, (previous, next) {
        fileSelectionChangeCount++;
      });
      
      container.listen(notificationProvider, (previous, next) {
        notificationChangeCount++;
      });
      
      // Trigger multiple rapid changes (race condition test)
      container.read(settingsProvider.notifier).updateTheme(ThemeMode.dark);
      container.read(fileSelectionProvider.notifier).selectFile('file1.pdf');
      container.read(fileSelectionProvider.notifier).selectFile('file2.pdf');
      container.read(settingsProvider.notifier).updateLanguage('en');
      container.read(fileSelectionProvider.notifier).clearSelection();
      
      // Wait for all async operations
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Verify all changes were processed
      expect(settingsChangeCount, greaterThan(0));
      expect(fileSelectionChangeCount, greaterThan(0));
      
      // Verify final state consistency
      final finalSettings = container.read(settingsProvider);
      final finalSelection = container.read(fileSelectionProvider);
      
      expect(finalSettings.themeMode, equals(ThemeMode.dark));
      expect(finalSettings.language, equals('en'));
      expect(finalSelection.selectedFiles, isEmpty);
      
      container.dispose();
    });

    test('Provider dependency chain maintains correct order', () async {
      final container = ProviderContainer();
      
      // Track the order of updates
      final updateOrder = <String>[];
      
      // Listen to providers in dependency chain
      container.listen(settingsProvider, (previous, next) {
        updateOrder.add('settings');
      });
      
      container.listen(notificationProvider, (previous, next) {
        updateOrder.add('notification');
      });
      
      // Trigger change that should cascade through dependencies
      container.read(settingsProvider.notifier).updateTheme(ThemeMode.dark);
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify correct update order
      expect(updateOrder.first, equals('settings'));
      expect(updateOrder.contains('notification'), isTrue);
      
      container.dispose();
    });

    test('BLoC to BLoC communication through Riverpod bridge', () async {
      final container = ProviderContainer();
      
      // Create BLoC instances
      final documentBloc = DocumentBloc();
      final categoryBloc = CategoryBloc();
      
      // Test: Document upload triggers category update
      var categoryUpdateTriggered = false;
      categoryBloc.stream.listen((state) {
        if (state is CategoryStatsUpdated) {
          categoryUpdateTriggered = true;
        }
      });
      
      // Simulate document upload completion
      documentBloc.add(const UploadDocumentCompleted(
        documentId: 'test_doc_123',
        categoryId: 'work_category',
      ));
      
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Verify category BLoC was notified
      expect(categoryUpdateTriggered, isTrue);
      
      // Cleanup
      await documentBloc.close();
      await categoryBloc.close();
      container.dispose();
    });

    test('Error state propagation across providers and BLoCs', () async {
      final container = ProviderContainer();
      
      // Create BLoC with error state
      final uploadBloc = UploadBloc();
      
      // Track error propagation
      var errorPropagated = false;
      container.listen(notificationProvider, (previous, next) {
        if (next.hasErrors) {
          errorPropagated = true;
        }
      });
      
      // Trigger error in upload BLoC
      uploadBloc.add(const UploadFile(filePath: 'invalid_file.pdf'));
      
      await Future.delayed(const Duration(milliseconds: 200));
      
      // Verify error was propagated to notification provider
      expect(errorPropagated, isTrue);
      
      // Cleanup
      await uploadBloc.close();
      container.dispose();
    });

    test('State persistence across provider rebuilds', () async {
      final container = ProviderContainer();
      
      // Set initial state
      container.read(fileSelectionProvider.notifier).selectFile('persistent_file.pdf');
      container.read(settingsProvider.notifier).updateTheme(ThemeMode.dark);
      
      // Get current state
      final initialSelection = container.read(fileSelectionProvider);
      final initialSettings = container.read(settingsProvider);
      
      // Force provider rebuild (simulate app restart)
      container.invalidate(fileSelectionProvider);
      container.invalidate(settingsProvider);
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify state was restored
      final restoredSelection = container.read(fileSelectionProvider);
      final restoredSettings = container.read(settingsProvider);
      
      expect(restoredSelection.selectedFiles, equals(initialSelection.selectedFiles));
      expect(restoredSettings.themeMode, equals(initialSettings.themeMode));
      
      container.dispose();
    });
  });
}
