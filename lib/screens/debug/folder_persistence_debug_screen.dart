import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';
import '../../providers/category_provider.dart';
import '../../utils/folder_persistence_test.dart';
import '../../widgets/common/custom_app_bar.dart';

class FolderPersistenceDebugScreen extends StatefulWidget {
  const FolderPersistenceDebugScreen({super.key});

  @override
  State<FolderPersistenceDebugScreen> createState() => _FolderPersistenceDebugScreenState();
}

class _FolderPersistenceDebugScreenState extends State<FolderPersistenceDebugScreen> {
  String _diagnosticResults = '';
  Map<String, dynamic>? _testResults;
  bool _isRunningTest = false;
  bool _isRunningDiagnostic = false;

  @override
  void initState() {
    super.initState();
    _runQuickDiagnostic();
  }

  Future<void> _runQuickDiagnostic() async {
    setState(() {
      _isRunningDiagnostic = true;
    });

    try {
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      final results = await FolderPersistenceTest.quickDiagnostic(
        documentProvider: documentProvider,
        categoryProvider: categoryProvider,
      );

      setState(() {
        _diagnosticResults = results;
      });
    } catch (e) {
      setState(() {
        _diagnosticResults = 'Diagnostic failed: $e';
      });
    } finally {
      setState(() {
        _isRunningDiagnostic = false;
      });
    }
  }

  Future<void> _runFullTest() async {
    setState(() {
      _isRunningTest = true;
      _testResults = null;
    });

    try {
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

      final results = await FolderPersistenceTest.runPersistenceTest(
        documentProvider: documentProvider,
        categoryProvider: categoryProvider,
      );

      setState(() {
        _testResults = results;
      });
    } catch (e) {
      setState(() {
        _testResults = {
          'success': false,
          'error': e.toString(),
        };
      });
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _forceRefresh() async {
    try {
      final documentProvider = Provider.of<DocumentProvider>(context, listen: false);
      await documentProvider.refreshFolderContents();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Folder contents refreshed from Firebase'),
            backgroundColor: AppColors.success,
          ),
        );
        _runQuickDiagnostic();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Refresh failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Folder Persistence Debug',
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textWhite,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 24),
            
            // Quick Diagnostic Results
            _buildDiagnosticSection(),
            const SizedBox(height: 24),
            
            // Full Test Results
            if (_testResults != null) _buildTestResultsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Debug Actions',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRunningDiagnostic ? null : _runQuickDiagnostic,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textWhite,
                    ),
                    icon: _isRunningDiagnostic
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.search),
                    label: Text(
                      'Quick Diagnostic',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRunningTest ? null : _runFullTest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.textWhite,
                    ),
                    icon: _isRunningTest
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.bug_report),
                    label: Text(
                      'Full Test',
                      style: GoogleFonts.poppins(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _forceRefresh,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                  foregroundColor: AppColors.textWhite,
                ),
                icon: const Icon(Icons.refresh),
                label: Text(
                  'Force Refresh from Firebase',
                  style: GoogleFonts.poppins(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosticSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Diagnostic',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                _diagnosticResults.isEmpty ? 'Running diagnostic...' : _diagnosticResults,
                style: GoogleFonts.robotoMono(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResultsSection() {
    final results = _testResults!;
    final success = results['success'] as bool;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  success ? Icons.check_circle : Icons.error,
                  color: success ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 8),
                Text(
                  'Full Test Results',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Test Results
            if (results['tests'] != null) ...[
              Text(
                'Individual Tests:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              ...((results['tests'] as Map<String, bool>).entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        entry.value ? Icons.check : Icons.close,
                        size: 16,
                        color: entry.value ? AppColors.success : AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key.replaceAll('_', ' ').toUpperCase(),
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              })),
            ],
            
            // Errors
            if (results['errors'] != null && (results['errors'] as List).isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Errors:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 8),
              ...((results['errors'] as List<String>).map((error) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    '• $error',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.error,
                    ),
                  ),
                );
              })),
            ],
          ],
        ),
      ),
    );
  }
}
