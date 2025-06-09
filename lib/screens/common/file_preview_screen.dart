import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/document_model.dart';
import '../../services/file_preview_service.dart';
import '../../services/file_download_service.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/share/share_options_widget.dart';

class FilePreviewScreen extends StatefulWidget {
  final DocumentModel document;

  const FilePreviewScreen({super.key, required this.document});

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  final FilePreviewService _previewService = FilePreviewService();
  late FilePreviewType _previewType;
  String? _previewUrl;
  bool _isLoading = true;
  String? _errorMessage;
  String? _localFilePath;

  // Controllers for different media types
  VideoPlayerController? _videoController;
  AudioPlayer? _audioPlayer;
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    _previewType = _previewService.getPreviewType(widget.document);
    _initializePreview();
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  Future<void> _initializePreview() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      _previewUrl = await _previewService.getPreviewUrl(widget.document);

      // For PDF files, we need to download the file locally
      if (_previewType == FilePreviewType.pdf) {
        await _downloadFileForPreview();
      }

      // Initialize specific controllers based on file type
      await _initializeControllers();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load file: ${e.toString()}';
      });
    }
  }

  Future<void> _downloadFileForPreview() async {
    try {
      final dio = Dio();
      final tempDir = await getTemporaryDirectory();
      final fileName = widget.document.fileName;
      final filePath = '${tempDir.path}/$fileName';

      await dio.download(_previewUrl!, filePath);
      _localFilePath = filePath;
    } catch (e) {
      throw Exception('Failed to download file for preview: $e');
    }
  }

  Future<void> _initializeControllers() async {
    switch (_previewType) {
      case FilePreviewType.video:
        if (_previewUrl != null) {
          _videoController = VideoPlayerController.networkUrl(
            Uri.parse(_previewUrl!),
          );
          await _videoController!.initialize();
        }
        break;
      case FilePreviewType.audio:
        _audioPlayer = AudioPlayer();
        break;
      case FilePreviewType.document:
        _webViewController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..loadRequest(
            Uri.parse(
              _previewService.getDocumentViewerUrl(_previewUrl!, _previewType),
            ),
          );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 28,
            color: AppColors.textWhite,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.document.fileName,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textWhite,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _previewService.getFileTypeDisplayName(_previewType),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textWhite.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outline,
              color: AppColors.textWhite,
            ),
            onPressed: _showFileInfo,
            tooltip: 'File Info',
          ),
          IconButton(
            icon: const Icon(
              Icons.download,
              color: AppColors.textWhite,
            ),
            onPressed: _downloadFile,
            tooltip: 'Download',
          ),
          IconButton(
            icon: const Icon(
              Icons.share,
              color: AppColors.textWhite,
            ),
            onPressed: _showShareOptions,
            tooltip: 'Share',
          ),
        ],
      ),
      body: _buildPreviewContent(),
    );
  }

  Widget _buildPreviewContent() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
            const SizedBox(height: 16),
            Text(
              'Loading preview...',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildErrorState();
    }

    switch (_previewType) {
      case FilePreviewType.image:
        return _buildImagePreview();
      case FilePreviewType.pdf:
        return _buildPdfPreview();
      case FilePreviewType.video:
        return _buildVideoPreview();
      case FilePreviewType.audio:
        return _buildAudioPreview();
      case FilePreviewType.document:
        return _buildDocumentPreview();
      case FilePreviewType.text:
        return _buildTextPreview();
      case FilePreviewType.unsupported:
        return _buildUnsupportedPreview();
    }
  }

  Widget _buildImagePreview() {
    return PhotoView(
      imageProvider: CachedNetworkImageProvider(_previewUrl!),
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 3,
      heroAttributes: PhotoViewHeroAttributes(tag: widget.document.id),
      loadingBuilder: (context, event) => Center(
        child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
      ),
      errorBuilder: (context, error, stackTrace) => _buildErrorState(),
    );
  }

  Widget _buildPdfPreview() {
    if (_localFilePath == null) {
      return _buildErrorState();
    }

    return PDFView(
      filePath: _localFilePath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      onError: (error) {
        setState(() {
          _errorMessage = 'Error loading PDF: $error';
        });
      },
    );
  }

  Widget _buildVideoPreview() {
    if (_videoController == null || !_videoController!.value.isInitialized) {
      return _buildErrorState();
    }

    return Center(
      child: AspectRatio(
        aspectRatio: _videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(_videoController!),
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    if (_videoController!.value.isPlaying) {
                      _videoController!.pause();
                    } else {
                      _videoController!.play();
                    }
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Icon(
                      _videoController!.value.isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      size: 64,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.music_note, size: 100, color: AppColors.primary),
          const SizedBox(height: 24),
          Text(
            widget.document.fileName,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () async {
              if (_audioPlayer != null && _previewUrl != null) {
                await _audioPlayer!.play(UrlSource(_previewUrl!));
              }
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Play Audio'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentPreview() {
    return WebViewWidget(controller: _webViewController!);
  }

  Widget _buildTextPreview() {
    return FutureBuilder<String>(
      future: _loadTextContent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(color: AppColors.primary, size: 50.0),
          );
        }

        if (snapshot.hasError) {
          return _buildErrorState();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Text(
            snapshot.data ?? 'No content available',
            style: GoogleFonts.robotoMono(
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  Future<String> _loadTextContent() async {
    try {
      final dio = Dio();
      final response = await dio.get(_previewUrl!);
      return response.data.toString();
    } catch (e) {
      throw Exception('Failed to load text content: $e');
    }
  }

  Widget _buildUnsupportedPreview() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.insert_drive_file,
            size: 100,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 24),
          Text(
            'Preview not available',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This file type is not supported for preview',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _downloadFile,
            icon: const Icon(Icons.download),
            label: const Text('Download File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 100, color: AppColors.error),
          const SizedBox(height: 24),
          Text(
            'Failed to load preview',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'An error occurred while loading the file',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _initializePreview,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: _downloadFile,
                icon: const Icon(Icons.download),
                label: const Text('Download'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFileInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'File Information',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Name', widget.document.fileName),
            _buildInfoRow('Size', widget.document.fileSizeFormatted),
            _buildInfoRow('Type', widget.document.fileType),
            _buildInfoRow('Status', widget.document.status.toUpperCase()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadFile() async {
    final downloadService = FileDownloadService();

    try {
      // Show initial download message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text('Downloading ${widget.document.fileName}...'),
                ),
              ],
            ),
            duration: const Duration(seconds: 30),
            backgroundColor: AppColors.primary,
          ),
        );
      }

      // Download the file
      await downloadService.downloadFile(
        widget.document,
        onProgress: (progress) {
          debugPrint(
            'Download progress: ${(progress * 100).toStringAsFixed(1)}%',
          );
        },
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(child: Text('File downloaded successfully!')),
              ],
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text('Download failed: ${e.toString()}')),
              ],
            ),
            backgroundColor: AppColors.error,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                _downloadFile();
              },
            ),
          ),
        );
      }
    }
  }

  void _showShareOptions() {
    ShareOptionsWidget.show(
      context,
      widget.document,
    );
  }
}
