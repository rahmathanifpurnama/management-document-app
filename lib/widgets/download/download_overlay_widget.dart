import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/enhanced_download_service.dart';
import '../../models/document_model.dart';
import 'animated_download_progress_widget.dart';

/// Overlay widget that shows active downloads at the bottom of the screen
class DownloadOverlayWidget extends StatelessWidget {
  const DownloadOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnhancedDownloadService>(
      builder: (context, downloadService, child) {
        final activeDownloads = downloadService.activeDownloads;

        if (activeDownloads.isEmpty) {
          return const SizedBox.shrink();
        }

        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 300, // Limit height for multiple downloads
            ),
            child: Material(
              elevation: 8,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header for multiple downloads
                    if (activeDownloads.length > 1)
                      _buildHeader(activeDownloads.length),

                    // Downloads list
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: activeDownloads.length,
                        itemBuilder: (context, index) {
                          final entry = activeDownloads.entries.elementAt(
                            index,
                          );
                          final documentId = entry.key;
                          final downloadProgress = entry.value;

                          return StreamBuilder<DownloadProgress>(
                            stream: downloadService.getDownloadProgress(
                              documentId,
                            ),
                            initialData: downloadProgress,
                            builder: (context, snapshot) {
                              final progress =
                                  snapshot.data ?? downloadProgress;

                              return AnimatedDownloadProgressWidget(
                                document: progress.document,
                                progress: progress.progress,
                                state: progress.state,
                                errorMessage: progress.errorMessage,
                                networkSpeed: progress.networkSpeed,
                                onCancel: () =>
                                    downloadService.cancelDownload(documentId),
                                onRetry: () =>
                                    downloadService.retryDownload(documentId),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int downloadCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.download, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$downloadCount active downloads',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const Spacer(),
          // Optional: Add collapse/expand button
          IconButton(
            onPressed: () {
              // TODO: Implement collapse/expand functionality
            },
            icon: Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: Colors.grey[600],
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
          ),
        ],
      ),
    );
  }
}

/// Wrapper widget that provides download overlay to any screen
class DownloadOverlayProvider extends StatelessWidget {
  final Widget child;

  const DownloadOverlayProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EnhancedDownloadService(),
      child: Stack(children: [child, const DownloadOverlayWidget()]),
    );
  }
}

/// Mixin for easy download integration in any widget
mixin DownloadMixin<T extends StatefulWidget> on State<T> {
  EnhancedDownloadService get downloadService => EnhancedDownloadService();

  /// Start download with automatic progress display
  Future<void> startDownload(
    DocumentModel document, {
    String? customPath,
  }) async {
    try {
      final result = await downloadService.downloadWithProgress(
        document,
        customPath: customPath,
      );

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download completed: ${document.fileName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Check if document is currently downloading
  bool isDocumentDownloading(String documentId) {
    return downloadService.isDownloading(documentId);
  }
}
