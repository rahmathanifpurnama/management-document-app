import 'package:flutter/material.dart';
import '../services/storage_firestore_diagnostic_service.dart';
import '../core/services/firebase_service.dart';

/// Test script to run diagnostic analysis
class DiagnosticTest {
  static Future<void> runDiagnostic() async {
    debugPrint('🔍 Starting diagnostic test...');

    try {
      // Initialize Firebase service
      await FirebaseService.initialize();

      // Run diagnostic analysis
      final diagnosticService = StorageFirestoreDiagnosticService.instance;
      final report = await diagnosticService.analyzeDataConsistency();

      debugPrint('📊 Diagnostic Report:');
      debugPrint(report.toString());

      if (!report.isConsistent) {
        debugPrint('⚠️ Data inconsistency detected!');
        debugPrint('   Discrepancy count: ${report.discrepancyCount}');

        if (report.orphanedMetadata.isNotEmpty) {
          debugPrint('🗑️ Orphaned metadata records:');
          for (final record in report.orphanedMetadata.take(5)) {
            debugPrint(
              '   - ${record.fileName} (ID: ${record.id}, Active: ${record.isActive})',
            );
          }
          if (report.orphanedMetadata.length > 5) {
            debugPrint('   ... and ${report.orphanedMetadata.length - 5} more');
          }
        }

        if (report.orphanedStorageFiles.isNotEmpty) {
          debugPrint('📁 Orphaned storage files:');
          for (final file in report.orphanedStorageFiles.take(5)) {
            debugPrint('   - ${file.fileName} (Size: ${file.fileSize} bytes)');
          }
          if (report.orphanedStorageFiles.length > 5) {
            debugPrint(
              '   ... and ${report.orphanedStorageFiles.length - 5} more',
            );
          }
        }

        if (report.duplicateMetadata.isNotEmpty) {
          debugPrint('🔄 Duplicate metadata:');
          for (final entry in report.duplicateMetadata.entries.take(5)) {
            debugPrint('   - ${entry.key}: ${entry.value.length} records');
          }
          if (report.duplicateMetadata.length > 5) {
            debugPrint(
              '   ... and ${report.duplicateMetadata.length - 5} more',
            );
          }
        }

        // Suggest cleanup if orphaned metadata exists
        if (report.orphanedMetadata.isNotEmpty) {
          debugPrint(
            '💡 Suggestion: Run cleanup to remove orphaned metadata records',
          );
          debugPrint('   This should fix the statistics discrepancy');
        }
      } else {
        debugPrint('✅ Data is consistent!');
      }
    } catch (e) {
      debugPrint('❌ Diagnostic test failed: $e');
    }
  }

  /// Run cleanup simulation
  static Future<void> runCleanupSimulation() async {
    debugPrint('🧹 Starting cleanup simulation...');

    try {
      final diagnosticService = StorageFirestoreDiagnosticService.instance;
      final report = await diagnosticService.analyzeDataConsistency();

      if (report.orphanedMetadata.isNotEmpty) {
        debugPrint(
          '🔍 Simulating cleanup of ${report.orphanedMetadata.length} orphaned records...',
        );

        final cleanupResult = await diagnosticService.cleanupOrphanedMetadata(
          orphanedRecords: report.orphanedMetadata,
          dryRun: true,
        );

        debugPrint('📊 Cleanup simulation results:');
        debugPrint('   Processed: ${cleanupResult.processedCount}');
        debugPrint('   Would succeed: ${cleanupResult.successCount}');
        debugPrint('   Would fail: ${cleanupResult.errorCount}');

        if (cleanupResult.errors.isNotEmpty) {
          debugPrint('❌ Potential errors:');
          for (final error in cleanupResult.errors.take(3)) {
            debugPrint('   - $error');
          }
        }
      } else {
        debugPrint('✅ No orphaned metadata to clean up');
      }
    } catch (e) {
      debugPrint('❌ Cleanup simulation failed: $e');
    }
  }
}

/// Widget to run diagnostic tests
class DiagnosticTestWidget extends StatefulWidget {
  const DiagnosticTestWidget({super.key});

  @override
  State<DiagnosticTestWidget> createState() => _DiagnosticTestWidgetState();
}

class _DiagnosticTestWidgetState extends State<DiagnosticTestWidget> {
  bool _isRunning = false;
  String _results = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diagnostic Test')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _isRunning ? null : _runDiagnostic,
              child: _isRunning
                  ? const CircularProgressIndicator()
                  : const Text('Run Diagnostic'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isRunning ? null : _runCleanupSimulation,
              child: const Text('Run Cleanup Simulation'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _results.isEmpty ? 'No results yet...' : _results,
                    style: const TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runDiagnostic() async {
    setState(() {
      _isRunning = true;
      _results = 'Running diagnostic...\n';
    });

    try {
      await DiagnosticTest.runDiagnostic();
      setState(() {
        _results += 'Diagnostic completed. Check debug console for details.\n';
      });
    } catch (e) {
      setState(() {
        _results += 'Error: $e\n';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }

  Future<void> _runCleanupSimulation() async {
    setState(() {
      _isRunning = true;
      _results += '\nRunning cleanup simulation...\n';
    });

    try {
      await DiagnosticTest.runCleanupSimulation();
      setState(() {
        _results +=
            'Cleanup simulation completed. Check debug console for details.\n';
      });
    } catch (e) {
      setState(() {
        _results += 'Error: $e\n';
      });
    } finally {
      setState(() {
        _isRunning = false;
      });
    }
  }
}
