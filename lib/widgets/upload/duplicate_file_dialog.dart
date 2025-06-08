import 'package:flutter/material.dart';

/// Dialog widget for handling duplicate file detection
class DuplicateFileDialog extends StatelessWidget {
  final List<Map<String, dynamic>> duplicateFiles;
  final VoidCallback? onProceedAnyway;
  final VoidCallback? onCancel;

  const DuplicateFileDialog({
    super.key,
    required this.duplicateFiles,
    this.onProceedAnyway,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.orange[600],
            size: 28,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'File Duplikasi Terdeteksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File berikut sudah ada di sistem:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            ...duplicateFiles.map((duplicate) => _buildDuplicateItem(duplicate)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Upload akan dibatalkan untuk mencegah duplikasi file.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          child: Text(
            'Batal',
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (onProceedAnyway != null)
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              onProceedAnyway?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Upload Tetap',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onCancel?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1976D2),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'OK',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildDuplicateItem(Map<String, dynamic> duplicate) {
    final fileName = duplicate['fileName'] as String;
    final existingDoc = duplicate['existingDocument'] as Map<String, dynamic>?;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.file_copy_outlined,
                color: Colors.red[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fileName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.red[700],
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          if (existingDoc != null) ...[
            const SizedBox(height: 8),
            Text(
              'File asli: ${existingDoc['fileName'] ?? 'Unknown'}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            if (existingDoc['uploadedAt'] != null)
              Text(
                'Diupload: ${_formatDate(existingDoc['uploadedAt'])}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ],
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp == null) return 'Unknown';
      
      DateTime date;
      if (timestamp is String) {
        date = DateTime.parse(timestamp);
      } else {
        // Assume Firestore Timestamp
        date = DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);
      }
      
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Show duplicate file dialog
  static Future<bool> show(
    BuildContext context,
    List<Map<String, dynamic>> duplicateFiles, {
    bool allowProceed = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => DuplicateFileDialog(
        duplicateFiles: duplicateFiles,
        onProceedAnyway: allowProceed ? () {} : null,
        onCancel: () {},
      ),
    );
    
    return result ?? false;
  }
}

/// Widget for showing duplicate file warning in upload screen
class DuplicateFileWarning extends StatelessWidget {
  final List<Map<String, dynamic>> duplicateFiles;
  final VoidCallback? onDismiss;

  const DuplicateFileWarning({
    super.key,
    required this.duplicateFiles,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange[600],
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'File Duplikasi Terdeteksi',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange[600],
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${duplicateFiles.length} file sudah ada di sistem dan tidak akan diupload:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 8),
          ...duplicateFiles.take(3).map((duplicate) => Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 4),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 6,
                      color: Colors.orange[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        duplicate['fileName'] as String,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          if (duplicateFiles.length > 3)
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                'dan ${duplicateFiles.length - 3} file lainnya...',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.orange[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Mixin for handling duplicate file detection in upload screens
mixin DuplicateFileHandler {
  /// Handle duplicate files with user interaction
  Future<bool> handleDuplicateFiles(
    BuildContext context,
    List<Map<String, dynamic>> duplicateFiles, {
    bool allowProceed = false,
  }) async {
    if (duplicateFiles.isEmpty) return true;

    // Show dialog to user
    final proceed = await DuplicateFileDialog.show(
      context,
      duplicateFiles,
      allowProceed: allowProceed,
    );

    return proceed;
  }

  /// Show duplicate warning as snackbar
  void showDuplicateWarning(
    BuildContext context,
    List<Map<String, dynamic>> duplicateFiles,
  ) {
    if (duplicateFiles.isEmpty) return;

    final duplicateNames = duplicateFiles
        .take(2)
        .map((d) => d['fileName'] as String)
        .join(', ');
    
    final message = duplicateFiles.length == 1
        ? 'File "$duplicateNames" sudah ada di sistem'
        : duplicateFiles.length == 2
            ? 'File "$duplicateNames" sudah ada di sistem'
            : 'File "$duplicateNames" dan ${duplicateFiles.length - 2} lainnya sudah ada di sistem';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange[100],
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.orange[600],
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
