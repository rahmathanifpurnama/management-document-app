import 'dart:io';

void main() async {
  print('🧹 Starting cleanup verification...');

  final results = CleanupResults();

  // Check for old provider files
  await _checkOldProviders(results);

  // Check for unused imports
  await _checkUnusedImports(results);

  // Check for orphaned files
  await _checkOrphanedFiles(results);

  // Check dependencies
  await _checkDependencies(results);

  // Generate report
  _generateReport(results);
}

Future<void> _checkOldProviders(CleanupResults results) async {
  print('📁 Checking for old provider files...');

  final oldProviderFiles = [
    'lib/providers/auth_provider.dart',
    'lib/providers/user_provider.dart',
    'lib/providers/document_provider.dart',
    'lib/providers/category_provider.dart',
    'lib/providers/file_selection_provider.dart',
    'lib/providers/settings_provider.dart',
    'lib/providers/notification_provider.dart',
    'lib/providers/sync_provider.dart',
  ];

  for (final filePath in oldProviderFiles) {
    final file = File(filePath);
    if (await file.exists()) {
      results.remainingOldFiles.add(filePath);
      print('❌ Old provider file still exists: $filePath');
    } else {
      results.removedFiles.add(filePath);
      print('✅ Old provider file removed: $filePath');
    }
  }
}

Future<void> _checkUnusedImports(CleanupResults results) async {
  print('📦 Checking for unused imports...');

  final libDir = Directory('lib');
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();

      // Check for old provider imports (exclude valid Riverpod providers)
      final oldImports = [
        "import 'package:provider/provider.dart';",
        "import '../providers/",
        "import '../../providers/",
        "import '../../../providers/",
      ];

      // Valid provider paths that should not be flagged
      final validProviderPaths = [
        'features/auth/providers/',
        'features/settings/providers/',
        'features/notification/providers/',
        'features/file_selection/providers/',
        'features/sync/providers/',
        'features/category/providers/',
        'features/documents/providers/',
        'features/users/providers/',
        'features/upload/providers/',
      ];

      for (final import in oldImports) {
        if (content.contains(import)) {
          // Check if this is a valid provider path
          bool isValidProvider = false;
          final normalizedPath = entity.path.replaceAll('\\', '/');

          for (final validPath in validProviderPaths) {
            if (normalizedPath.contains(validPath)) {
              isValidProvider = true;
              break;
            }
          }

          // Special case: sync widgets importing sync providers is valid
          if (normalizedPath.contains('features/sync/widgets/') &&
              content.contains("import '../providers/sync_providers.dart'")) {
            isValidProvider = true;
          }

          if (!isValidProvider) {
            results.filesWithOldImports.add(entity.path);
            break;
          }
        }
      }
    }
  }
}

Future<void> _checkOrphanedFiles(CleanupResults results) async {
  print('🗂️ Checking for orphaned files...');

  final potentialOrphans = [
    'lib/widgets/common/isolated_file_selection_provider.dart',
    'lib/test_riverpod_migration.dart',
    'lib/core/providers/safe_provider_wrapper.dart',
  ];

  for (final filePath in potentialOrphans) {
    final file = File(filePath);
    if (await file.exists()) {
      // Check if file is still referenced
      final isReferenced = await _isFileReferenced(filePath);
      if (!isReferenced) {
        results.orphanedFiles.add(filePath);
        print('🗑️ Orphaned file found: $filePath');
      }
    }
  }
}

Future<bool> _isFileReferenced(String filePath) async {
  // Simple check - look for imports of this file in other files
  final fileName = filePath.split('/').last.replaceAll('.dart', '');
  final libDir = Directory('lib');

  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File &&
        entity.path.endsWith('.dart') &&
        entity.path != filePath) {
      final content = await entity.readAsString();
      if (content.contains(fileName)) {
        return true;
      }
    }
  }
  return false;
}

Future<void> _checkDependencies(CleanupResults results) async {
  print('📋 Checking dependencies...');

  final pubspecFile = File('pubspec.yaml');
  if (await pubspecFile.exists()) {
    final content = await pubspecFile.readAsString();

    // Check if old provider dependency can be removed
    if (content.contains('provider:') && !await _isProviderStillUsed()) {
      results.unusedDependencies.add('provider');
      print('📦 Provider dependency can be removed');
    }
  }
}

Future<bool> _isProviderStillUsed() async {
  final libDir = Directory('lib');
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      final content = await entity.readAsString();
      if (content.contains('ChangeNotifierProvider') ||
          content.contains('Consumer<') ||
          content.contains('Provider.of<')) {
        return true;
      }
    }
  }
  return false;
}

void _generateReport(CleanupResults results) {
  print('\n📊 CLEANUP VERIFICATION REPORT');
  print('=' * 50);

  print('\n✅ REMOVED FILES (${results.removedFiles.length}):');
  for (final file in results.removedFiles) {
    print('  - $file');
  }

  if (results.remainingOldFiles.isNotEmpty) {
    print('\n❌ REMAINING OLD FILES (${results.remainingOldFiles.length}):');
    for (final file in results.remainingOldFiles) {
      print('  - $file');
    }
  }

  if (results.filesWithOldImports.isNotEmpty) {
    print(
      '\n⚠️ FILES WITH OLD IMPORTS (${results.filesWithOldImports.length}):',
    );
    for (final file in results.filesWithOldImports) {
      print('  - $file');
    }
  }

  if (results.orphanedFiles.isNotEmpty) {
    print('\n🗑️ ORPHANED FILES (${results.orphanedFiles.length}):');
    for (final file in results.orphanedFiles) {
      print('  - $file');
    }
  }

  if (results.unusedDependencies.isNotEmpty) {
    print('\n📦 UNUSED DEPENDENCIES (${results.unusedDependencies.length}):');
    for (final dep in results.unusedDependencies) {
      print('  - $dep');
    }
  }

  print('\n' + '=' * 50);

  if (results.isClean) {
    print('🎉 CLEANUP COMPLETE! No issues found.');
  } else {
    print('⚠️ CLEANUP INCOMPLETE. Please address the issues above.');
  }
}

class CleanupResults {
  final List<String> removedFiles = [];
  final List<String> remainingOldFiles = [];
  final List<String> filesWithOldImports = [];
  final List<String> orphanedFiles = [];
  final List<String> unusedDependencies = [];

  bool get isClean =>
      remainingOldFiles.isEmpty &&
      filesWithOldImports.isEmpty &&
      orphanedFiles.isEmpty;
}
