import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_selector/file_selector.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/cloud_functions_service.dart';
import 'api_storage_quota_widget.dart';
import 'api_upload_security_widget.dart';
import 'api_enhanced_upload_widget.dart';

/// Demo widget showcasing all Firebase Cloud Functions API integrations
class ApiUploadDemoWidget extends StatefulWidget {
  final String? categoryId;

  const ApiUploadDemoWidget({super.key, this.categoryId});

  @override
  State<ApiUploadDemoWidget> createState() => _ApiUploadDemoWidgetState();
}

class _ApiUploadDemoWidgetState extends State<ApiUploadDemoWidget> {
  final CloudFunctionsService _cloudFunctions = CloudFunctionsService.instance;

  List<XFile> _selectedFiles = [];
  bool _isTestingApis = false;
  final List<String> _apiTestResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          'API Upload Demo',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
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

            // Storage Quota Widget
            _buildSectionHeader('Storage Quota API Integration'),
            const ApiStorageQuotaWidget(
              showCleanupButton: true,
              autoRefresh: false,
            ),
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
              _buildApiTestResults(),
              const SizedBox(height: 24),
            ],

            // Bottom padding
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              Icon(Icons.api, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'Firebase Cloud Functions API Demo',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'This demo showcases the integration of deployed Firebase Cloud Functions APIs with Flutter widgets for upload functionality.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFeatureChip('File Validation API'),
              _buildFeatureChip('Storage Quota API'),
              _buildFeatureChip('Duplicate Check API'),
              _buildFeatureChip('Upload Processing API'),
              _buildFeatureChip('Thumbnail Generation API'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.lightBlue.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.lightBlue),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
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
                'Test Storage Quota',
                Icons.storage,
                _testStorageQuotaApi,
              ),
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
      icon: Icon(icon, size: 16),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Selected Files',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _selectFiles,
                icon: const Icon(Icons.file_upload, size: 16),
                label: Text(
                  'Select Files',
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_selectedFiles.isEmpty)
            Center(
              child: Text(
                'No files selected',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            )
          else
            Column(
              children: _selectedFiles
                  .map(
                    (file) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.lightBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.insert_drive_file,
                            color: AppColors.primary,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              file.name,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, size: 16),
                            onPressed: () => _removeFile(file),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildApiTestResults() {
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
            'API Test Results',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ..._apiTestResults.map(
            (result) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                result,
                style: GoogleFonts.robotoMono(
                  fontSize: 12,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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

  Future<void> _testStorageQuotaApi() async {
    setState(() {
      _isTestingApis = true;
    });

    try {
      final result = await _cloudFunctions.getStorageQuota();
      _addTestResult('Storage Quota API: ${result.toString()}');
    } catch (e) {
      _addTestResult('Storage Quota API Error: $e');
    }

    setState(() {
      _isTestingApis = false;
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
      _apiTestResults.add('${DateTime.now().toIso8601String()}: $result');
    });
  }

  void _onValidationComplete(List<Map<String, dynamic>> results) {
    _addTestResult('Validation completed for ${results.length} files');
  }

  void _onUploadComplete(List<UploadResult> results) {
    final successCount = results.where((r) => r.success).length;
    _addTestResult('Upload completed: $successCount successful uploads');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }
}
