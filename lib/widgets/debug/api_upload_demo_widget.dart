import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_functions_service.dart';
import '../upload/api_upload_security_widget.dart';
import '../upload/api_enhanced_upload_widget.dart';

/// Demo widget showcasing all Firebase Cloud Functions API integrations
///
/// ⚠️ FOR DEVELOPMENT/DEBUG PURPOSES ONLY ⚠️
/// This widget is used for testing and debugging upload functionality.
/// It should NOT be used in production screens.
class ApiUploadDemoWidget extends StatefulWidget {
  final String? categoryId;

  const ApiUploadDemoWidget({super.key, this.categoryId});

  @override
  State<ApiUploadDemoWidget> createState() => _ApiUploadDemoWidgetState();
}

class _ApiUploadDemoWidgetState extends State<ApiUploadDemoWidget> {
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  List<XFile> _selectedFiles = [];
  List<String> _apiTestResults = [];
  bool _isTestingApis = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload API Demo (DEBUG)',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'DEBUG',
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),
            const SizedBox(height: 24),

            // API Test Controls
            _buildApiTestControls(),
            const SizedBox(height: 24),

            // File Selection
            _buildSectionHeader('File Selection'),
            _buildFileSelector(),
            const SizedBox(height: 24),

            // Upload Security Widget
            if (_selectedFiles.isNotEmpty) ...[
              _buildSectionHeader('Upload Security API Integration'),
              ApiUploadSecurityWidget(
                selectedFiles: _selectedFiles,
                onValidationComplete: _onValidationComplete,
                showSecurityStatus: true,
              ),
              const SizedBox(height: 24),
            ],

            // Enhanced Upload Widget
            if (_selectedFiles.isNotEmpty) ...[
              _buildSectionHeader('Enhanced Upload API Integration'),
              ApiEnhancedUploadWidget(
                selectedFiles: _selectedFiles,
                categoryId: widget.categoryId,
                onUploadComplete: _onUploadComplete,
                allowRetry: true,
                maxConcurrentUploads: 2,
              ),
              const SizedBox(height: 24),
            ],

            // API Test Results
            if (_apiTestResults.isNotEmpty) ...[
              _buildSectionHeader('API Test Results'),
              _buildTestResults(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning, color: Colors.orange, size: 24),
              const SizedBox(width: 8),
              Text(
                'DEBUG MODE',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'This is a development/debug widget for testing Firebase Cloud Functions API integrations. '
            'It should NOT be used in production screens.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildApiTestControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'API Testing Controls',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildTestButton(
                'Test File Validation',
                Icons.security,
                _testFileValidationApi,
              ),
              _buildTestButton(
                'Test Duplicate Check',
                Icons.find_in_page,
                _testDuplicateCheckApi,
              ),
              _buildTestButton('Clear Results', Icons.clear, _clearTestResults),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTestButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: _isTestingApis ? null : onPressed,
      icon: _isTestingApis
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon, size: 16),
      label: Text(label, style: GoogleFonts.poppins(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }

  Widget _buildFileSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Selected Files (${_selectedFiles.length})',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: _selectFiles,
                icon: const Icon(Icons.file_upload, size: 16),
                label: Text('Select Files', style: GoogleFonts.poppins()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedFiles.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.lightGray),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    size: 48,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'No files selected',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          else
            ...(_selectedFiles.map((file) => _buildFileItem(file))),
        ],
      ),
    );
  }

  Widget _buildFileItem(XFile file) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.lightBlue.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.description, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  file.mimeType ?? 'Unknown type',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _removeFile(file),
            icon: const Icon(Icons.close, size: 18),
            color: AppColors.error,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildTestResults() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Test Results',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _apiTestResults
                    .map(
                      (result) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          result,
                          style: GoogleFonts.robotoMono(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Event Handlers
  void _onValidationComplete(List<Map<String, dynamic>> results) {
    _addTestResult('Validation completed: ${results.length} files processed');
    for (final result in results) {
      _addTestResult(
        '- ${result['fileName']}: ${result['isValid'] ? 'VALID' : 'INVALID'}',
      );
    }
  }

  void _onUploadComplete(List<UploadResult> results) {
    final successCount = results.where((r) => r.success).length;
    final failedCount = results.where((r) => !r.success).length;

    _addTestResult(
      'Upload completed: $successCount success, $failedCount failed',
    );

    for (final result in results) {
      if (result.success) {
        _addTestResult('✅ ${result.fileName}: SUCCESS');
      } else {
        _addTestResult('❌ ${result.fileName}: ${result.error}');
      }
    }
  }

  Future<void> _selectFiles() async {
    try {
      const typeGroup = XTypeGroup(
        label: 'Documents',
        extensions: ['pdf', 'doc', 'docx', 'jpg', 'png', 'txt'],
      );

      final files = await openFiles(acceptedTypeGroups: [typeGroup]);
      if (files.isNotEmpty) {
        setState(() {
          _selectedFiles = files;
        });
      }
    } catch (e) {
      _showError('Error selecting files: $e');
    }
  }

  void _removeFile(XFile file) {
    setState(() {
      _selectedFiles.remove(file);
    });
  }

  Future<void> _testFileValidationApi() async {
    if (_selectedFiles.isEmpty) {
      _showError('Please select files first');
      return;
    }

    setState(() {
      _isTestingApis = true;
    });

    try {
      final file = _selectedFiles.first;
      final fileSize = await file.length();

      final result = await _cloudFunctions.validateFile(
        fileName: file.name,
        fileSize: fileSize,
        contentType: file.mimeType ?? 'application/octet-stream',
      );

      _addTestResult('File Validation API: ${result.toString()}');
    } catch (e) {
      _addTestResult('File Validation API Error: $e');
    }

    setState(() {
      _isTestingApis = false;
    });
  }

  Future<void> _testDuplicateCheckApi() async {
    if (_selectedFiles.isEmpty) {
      _showError('Please select files first');
      return;
    }

    setState(() {
      _isTestingApis = true;
    });

    try {
      final file = _selectedFiles.first;
      final fileSize = await file.length();

      final result = await _cloudFunctions.checkDuplicateFile(
        fileName: file.name,
        fileSize: fileSize,
        contentType: file.mimeType ?? 'application/octet-stream',
      );

      _addTestResult('Duplicate Check API: ${result.toString()}');
    } catch (e) {
      _addTestResult('Duplicate Check API Error: $e');
    }

    setState(() {
      _isTestingApis = false;
    });
  }

  void _clearTestResults() {
    setState(() {
      _apiTestResults.clear();
    });
  }

  void _addTestResult(String result) {
    setState(() {
      final timestamp = DateTime.now().toString().substring(11, 19);
      _apiTestResults.add('[$timestamp] $result');
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}
