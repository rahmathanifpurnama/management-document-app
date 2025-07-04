import 'package:flutter/material.dart';
import '../services/hybrid_upload_service.dart';
import '../models/upload_file_model.dart';

/// EXAMPLE: How to use Hybrid Upload Service
/// =========================================
/// 
/// This example shows how to integrate the new hybrid upload system
/// that separates light client operations from heavy server processing.
/// 
/// Benefits of Hybrid Upload:
/// - ⚡ Fast upload (direct to Firebase Storage)
/// - 🔋 Battery friendly (minimal client processing)
/// - 📱 Light on device resources
/// - 🚀 Consistent performance across devices
/// - 🛡️ Advanced server-side security & processing

class HybridUploadExample extends StatefulWidget {
  const HybridUploadExample({Key? key}) : super(key: key);

  @override
  State<HybridUploadExample> createState() => _HybridUploadExampleState();
}

class _HybridUploadExampleState extends State<HybridUploadExample> {
  final HybridUploadService _hybridUploadService = HybridUploadService();
  
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String _statusMessage = '';
  Map<String, dynamic>? _uploadResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hybrid Upload Example'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Upload Progress Section
            _buildProgressSection(),
            
            const SizedBox(height: 20),
            
            // Upload Button
            _buildUploadButton(),
            
            const SizedBox(height: 20),
            
            // Status Messages
            _buildStatusSection(),
            
            const SizedBox(height: 20),
            
            // Upload Result
            if (_uploadResult != null) _buildResultSection(),
            
            const SizedBox(height: 20),
            
            // Performance Comparison
            _buildPerformanceComparison(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Progress',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: _uploadProgress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _isUploading ? Colors.blue : Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_uploadProgress * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadButton() {
    return ElevatedButton.icon(
      onPressed: _isUploading ? null : _simulateHybridUpload,
      icon: _isUploading 
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.cloud_upload),
      label: Text(_isUploading ? 'Uploading...' : 'Start Hybrid Upload'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Text(
              _statusMessage.isEmpty ? 'Ready to upload' : _statusMessage,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload Result',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            ...(_uploadResult?.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            )) ?? []),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceComparison() {
    return Card(
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚀 Hybrid Upload Benefits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.green[800],
              ),
            ),
            const SizedBox(height: 10),
            _buildBenefitItem('⚡', 'Fast Upload', 'Direct to Firebase Storage'),
            _buildBenefitItem('🔋', 'Battery Friendly', 'Minimal client processing'),
            _buildBenefitItem('📱', 'Light Resources', 'No heavy operations on device'),
            _buildBenefitItem('🛡️', 'Advanced Security', 'Server-side validation & scanning'),
            _buildBenefitItem('🔍', 'Smart Processing', 'Hash calculation, thumbnails, indexing'),
            _buildBenefitItem('📊', 'Rich Metadata', 'Automatic extraction & analysis'),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitItem(String icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Simulate hybrid upload process
  Future<void> _simulateHybridUpload() async {
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
      _statusMessage = 'Initializing hybrid upload...';
      _uploadResult = null;
    });

    try {
      // Simulate the hybrid upload phases
      await _simulatePhase1();
      await _simulatePhase2();
      await _simulatePhase3();
      
      // Simulate successful result
      setState(() {
        _uploadResult = {
          'success': true,
          'documentId': 'doc_${DateTime.now().millisecondsSinceEpoch}',
          'downloadUrl': 'https://storage.googleapis.com/example/file.pdf',
          'processingMode': 'hybrid',
          'message': 'File uploaded successfully. Advanced processing in background.',
        };
        _statusMessage = '🎉 Hybrid upload completed successfully!';
        _isUploading = false;
      });
      
    } catch (e) {
      setState(() {
        _statusMessage = '❌ Upload failed: $e';
        _isUploading = false;
      });
    }
  }

  /// Phase 1: Light client operations (10%)
  Future<void> _simulatePhase1() async {
    setState(() {
      _statusMessage = '🔍 Phase 1: Basic validation & authentication...';
    });
    
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
  }

  /// Phase 2: Direct upload to storage (80%)
  Future<void> _simulatePhase2() async {
    setState(() {
      _statusMessage = '📤 Phase 2: Direct upload to Firebase Storage...';
    });
    
    for (int i = 10; i <= 90; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
  }

  /// Phase 3: Background server processing (10%)
  Future<void> _simulatePhase3() async {
    setState(() {
      _statusMessage = '⚙️ Phase 3: Background server processing...';
    });
    
    for (int i = 90; i <= 100; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _uploadProgress = i / 100;
      });
    }
  }
}

/// INTEGRATION GUIDE:
/// ==================
/// 
/// To integrate hybrid upload in your app:
/// 
/// 1. Replace ConsolidatedUploadService with HybridUploadService:
///    ```dart
///    final hybridUploadService = HybridUploadService();
///    
///    final result = await hybridUploadService.uploadFile(
///      file,
///      onProgress: (progress) => setState(() => _progress = progress),
///      categoryId: selectedCategoryId,
///      customMetadata: {'source': 'mobile_app'},
///    );
///    ```
/// 
/// 2. Deploy hybrid Cloud Functions:
///    ```bash
///    cd functions
///    npm run deploy
///    ```
/// 
/// 3. Update your UI to show the 3-phase progress:
///    - Phase 1 (0-10%): Light client operations
///    - Phase 2 (10-90%): Direct upload
///    - Phase 3 (90-100%): Server processing
/// 
/// 4. Handle the enhanced result:
///    ```dart
///    if (result['success']) {
///      final documentId = result['documentId'];
///      final downloadUrl = result['downloadUrl'];
///      final processingMode = result['processingMode']; // 'hybrid'
///      
///      // Show success message
///      ScaffoldMessenger.of(context).showSnackBar(
///        SnackBar(content: Text(result['message'])),
///      );
///    }
///    ```
