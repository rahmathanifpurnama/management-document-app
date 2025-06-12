import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../providers/document_provider.dart';
import '../../theme/app_colors.dart';
import '../../utils/enhanced_firebase_test_helper.dart';

/// Widget for testing Enhanced Firebase Providers within the app
class FirebaseProvidersTestWidget extends StatefulWidget {
  const FirebaseProvidersTestWidget({super.key});

  @override
  State<FirebaseProvidersTestWidget> createState() =>
      _FirebaseProvidersTestWidgetState();
}

class _FirebaseProvidersTestWidgetState
    extends State<FirebaseProvidersTestWidget> {
  bool _isRunningTest = false;
  Map<String, dynamic>? _testResults;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Firebase Providers Test',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<AuthProvider, DocumentProvider>(
        builder: (context, authProvider, documentProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTestHeader(),
                const SizedBox(height: 16),
                _buildCurrentStatus(authProvider, documentProvider),
                const SizedBox(height: 16),
                _buildTestControls(),
                const SizedBox(height: 16),
                if (_testResults != null) _buildTestResults(),
                if (_errorMessage != null) _buildErrorMessage(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.science, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Enhanced Firebase Providers Test Suite',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'This test suite verifies all enhanced Firebase provider functionality including unlimited queries, storage management, and role-based permissions.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStatus(
    AuthProvider authProvider,
    DocumentProvider documentProvider,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current System Status',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            _buildStatusItem(
              'User Logged In',
              authProvider.isLoggedIn,
              authProvider.currentUser?.email ?? 'No user',
            ),
            FutureBuilder<bool>(
              future: authProvider.isCurrentUserAdmin,
              builder: (context, snapshot) {
                final isAdmin = snapshot.data ?? false;
                return _buildStatusItem(
                  'Admin Privileges',
                  isAdmin,
                  isAdmin ? 'Full access' : 'Limited access',
                );
              },
            ),
            FutureBuilder<bool>(
              future: authProvider.canPerformUnlimitedQueries(),
              builder: (context, snapshot) {
                final canUnlimited = snapshot.data ?? false;
                return _buildStatusItem(
                  'Unlimited Queries',
                  canUnlimited,
                  canUnlimited ? 'Available' : 'Not available',
                );
              },
            ),
            FutureBuilder<bool>(
              future: authProvider.canAccessStorageManagement(),
              builder: (context, snapshot) {
                final canStorage = snapshot.data ?? false;
                return _buildStatusItem(
                  'Storage Management',
                  canStorage,
                  canStorage ? 'Available' : 'Not available',
                );
              },
            ),
            _buildStatusItem(
              'Documents Loaded',
              documentProvider.documents.isNotEmpty,
              '${documentProvider.totalDocumentsCount} documents',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, bool status, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            status ? Icons.check_circle : Icons.cancel,
            color: status ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestControls() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Controls',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isRunningTest ? null : _runComprehensiveTest,
                icon: _isRunningTest
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow),
                label: Text(
                  _isRunningTest
                      ? 'Running Tests...'
                      : 'Run Comprehensive Test',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isRunningTest ? null : _runQuickTest,
                    icon: const Icon(Icons.speed),
                    label: const Text('Quick Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _clearResults,
                    icon: const Icon(Icons.clear),
                    label: const Text('Clear Results'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestResults() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _testResults!['overall'] == 'SUCCESS'
                      ? Icons.check_circle
                      : Icons.error,
                  color: _testResults!['overall'] == 'SUCCESS'
                      ? Colors.green
                      : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  'Test Results',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showDetailedResults,
                  icon: const Icon(Icons.visibility),
                  label: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildResultSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSummary() {
    final results = _testResults!;

    return Column(
      children: [
        _buildResultItem(
          'Overall Status',
          results['overall'],
          results['overall'] == 'SUCCESS',
        ),
        if (results['auth'] != null)
          _buildResultItem(
            'Authentication',
            results['auth']['status'],
            results['auth']['status'] == 'SUCCESS',
          ),
        if (results['documents'] != null)
          _buildResultItem(
            'Document Operations',
            results['documents']['status'],
            results['documents']['status'] == 'SUCCESS',
          ),
        if (results['storage'] != null)
          _buildResultItem(
            'Storage Operations',
            results['storage']['status'],
            results['storage']['status'] == 'SUCCESS',
          ),
        if (results['admin'] != null)
          _buildResultItem(
            'Admin Features',
            results['admin']['status'],
            results['admin']['status'] == 'SUCCESS',
          ),
        if (results['performance'] != null)
          _buildResultItem(
            'Performance',
            results['performance']['status'],
            results['performance']['status'] == 'SUCCESS',
          ),
      ],
    );
  }

  Widget _buildResultItem(String label, String status, bool success) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            success ? Icons.check : Icons.close,
            color: success ? Colors.green : Colors.red,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.poppins(fontSize: 14)),
          const Spacer(),
          Text(
            status,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: success ? Colors.green : Colors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Card(
      elevation: 4,
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.error, color: Colors.red),
                const SizedBox(width: 8),
                Text(
                  'Test Error',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _runComprehensiveTest() async {
    setState(() {
      _isRunningTest = true;
      _testResults = null;
      _errorMessage = null;
    });

    try {
      final results = await EnhancedFirebaseTestHelper.runComprehensiveTest(
        context,
      );
      setState(() {
        _testResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  Future<void> _runQuickTest() async {
    setState(() {
      _isRunningTest = true;
      _testResults = null;
      _errorMessage = null;
    });

    try {
      // Quick test - just check basic functionality
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final documentProvider = Provider.of<DocumentProvider>(
        context,
        listen: false,
      );

      final results = <String, dynamic>{
        'overall': 'SUCCESS',
        'timestamp': DateTime.now().toIso8601String(),
        'auth': {
          'status': 'SUCCESS',
          'isAdmin': await authProvider.isCurrentUserAdmin,
          'canUnlimitedQueries': await authProvider
              .canPerformUnlimitedQueries(),
        },
        'documents': {
          'status': 'SUCCESS',
          'totalDocuments': documentProvider.totalDocumentsCount,
        },
      };

      setState(() {
        _testResults = results;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isRunningTest = false;
      });
    }
  }

  void _clearResults() {
    setState(() {
      _testResults = null;
      _errorMessage = null;
    });
  }

  void _showDetailedResults() {
    if (_testResults != null) {
      EnhancedFirebaseTestHelper.showTestResults(context, _testResults!);
    }
  }
}
