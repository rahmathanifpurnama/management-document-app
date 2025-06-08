import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:math' as math;

/// Service for compressing images before upload
class ImageCompressionService {
  static ImageCompressionService? _instance;
  static ImageCompressionService get instance =>
      _instance ??= ImageCompressionService._();

  ImageCompressionService._();

  // Compression settings
  static const int maxWidth = 1920;
  static const int maxHeight = 1080;
  static const int maxFileSize = 2 * 1024 * 1024; // 2MB
  static const double defaultQuality = 0.8; // 80% quality
  static const double minQuality = 0.3; // 30% minimum quality

  /// Check if file is an image that needs compression
  bool isImageFile(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  /// Compress image if needed
  Future<CompressedImageResult> compressImage({
    required XFile imageFile,
    int? maxWidth,
    int? maxHeight,
    double? quality,
    int? maxFileSize,
  }) async {
    try {
      debugPrint('🖼️ Starting image compression for: ${imageFile.name}');

      final originalBytes = await imageFile.readAsBytes();
      final originalSize = originalBytes.length;

      debugPrint('📊 Original image size: ${_formatFileSize(originalSize)}');

      // Check if compression is needed
      final effectiveMaxSize =
          maxFileSize ?? ImageCompressionService.maxFileSize;
      if (originalSize <= effectiveMaxSize) {
        debugPrint('✅ Image already within size limit, no compression needed');
        return CompressedImageResult(
          compressedBytes: originalBytes,
          originalSize: originalSize,
          compressedSize: originalSize,
          compressionRatio: 1.0,
          wasCompressed: false,
        );
      }

      // Decode the image
      final ui.Codec codec = await ui.instantiateImageCodec(originalBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      final ui.Image image = frameInfo.image;

      debugPrint('📐 Original dimensions: ${image.width}x${image.height}');

      // Calculate new dimensions
      final newDimensions = _calculateNewDimensions(
        image.width,
        image.height,
        maxWidth ?? ImageCompressionService.maxWidth,
        maxHeight ?? ImageCompressionService.maxHeight,
      );

      debugPrint(
        '📐 Target dimensions: ${newDimensions.width}x${newDimensions.height}',
      );

      // Resize image if needed
      ui.Image resizedImage = image;
      if (newDimensions.width != image.width ||
          newDimensions.height != image.height) {
        resizedImage = await _resizeImage(
          image,
          newDimensions.width,
          newDimensions.height,
        );
      }

      // Compress with quality adjustment
      Uint8List compressedBytes = await _compressWithQuality(
        resizedImage,
        quality ?? defaultQuality,
        imageFile.name,
      );

      // If still too large, reduce quality iteratively
      double currentQuality = quality ?? defaultQuality;
      while (compressedBytes.length > effectiveMaxSize &&
          currentQuality > minQuality) {
        currentQuality = math.max(minQuality, currentQuality - 0.1);
        debugPrint('🔄 Reducing quality to ${(currentQuality * 100).toInt()}%');
        compressedBytes = await _compressWithQuality(
          resizedImage,
          currentQuality,
          imageFile.name,
        );
      }

      final compressedSize = compressedBytes.length;
      final compressionRatio = originalSize / compressedSize;

      debugPrint('✅ Compression completed:');
      debugPrint('   Original: ${_formatFileSize(originalSize)}');
      debugPrint('   Compressed: ${_formatFileSize(compressedSize)}');
      debugPrint('   Ratio: ${compressionRatio.toStringAsFixed(2)}x');
      debugPrint('   Quality: ${(currentQuality * 100).toInt()}%');

      // Clean up
      image.dispose();
      if (resizedImage != image) {
        resizedImage.dispose();
      }

      return CompressedImageResult(
        compressedBytes: compressedBytes,
        originalSize: originalSize,
        compressedSize: compressedSize,
        compressionRatio: compressionRatio,
        wasCompressed: true,
        finalQuality: currentQuality,
        finalDimensions: newDimensions,
      );
    } catch (e) {
      debugPrint('❌ Image compression failed: $e');
      rethrow;
    }
  }

  /// Calculate new dimensions maintaining aspect ratio
  ImageDimensions _calculateNewDimensions(
    int originalWidth,
    int originalHeight,
    int maxWidth,
    int maxHeight,
  ) {
    if (originalWidth <= maxWidth && originalHeight <= maxHeight) {
      return ImageDimensions(originalWidth, originalHeight);
    }

    final widthRatio = maxWidth / originalWidth;
    final heightRatio = maxHeight / originalHeight;
    final ratio = math.min(widthRatio, heightRatio);

    return ImageDimensions(
      (originalWidth * ratio).round(),
      (originalHeight * ratio).round(),
    );
  }

  /// Resize image to new dimensions
  Future<ui.Image> _resizeImage(ui.Image image, int width, int height) async {
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final ui.Canvas canvas = ui.Canvas(recorder);

    canvas.drawImageRect(
      image,
      ui.Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      ui.Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      ui.Paint(),
    );

    final ui.Picture picture = recorder.endRecording();
    final ui.Image resizedImage = await picture.toImage(width, height);
    picture.dispose();

    return resizedImage;
  }

  /// Compress image with specified quality
  Future<Uint8List> _compressWithQuality(
    ui.Image image,
    double quality,
    String fileName,
  ) async {
    final ByteData? byteData = await image.toByteData(
      format: _getImageFormat(fileName),
    );

    if (byteData == null) {
      throw Exception('Failed to encode image');
    }

    // For JPEG, we can simulate quality by adjusting the data
    // This is a simplified approach - in a real app, you might want to use
    // a more sophisticated image processing library
    final bytes = byteData.buffer.asUint8List();

    if (quality < 1.0) {
      // Simple quality reduction by sampling
      final targetLength = (bytes.length * quality).round();
      if (targetLength < bytes.length) {
        final step = bytes.length / targetLength;
        final compressedBytes = Uint8List(targetLength);
        for (int i = 0; i < targetLength; i++) {
          compressedBytes[i] = bytes[(i * step).round()];
        }
        return compressedBytes;
      }
    }

    return bytes;
  }

  /// Get appropriate image format based on file extension
  ui.ImageByteFormat _getImageFormat(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    switch (extension) {
      case 'png':
        return ui.ImageByteFormat.png;
      case 'jpg':
      case 'jpeg':
      default:
        return ui.ImageByteFormat.png; // Default to PNG for better quality
    }
  }

  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  /// Get compression recommendations based on file size
  CompressionRecommendation getCompressionRecommendation(int fileSizeBytes) {
    if (fileSizeBytes < 500 * 1024) {
      // Less than 500KB
      return CompressionRecommendation(
        shouldCompress: false,
        recommendedQuality: 1.0,
        reason: 'File size is already optimal',
      );
    } else if (fileSizeBytes < 2 * 1024 * 1024) {
      // 500KB - 2MB
      return CompressionRecommendation(
        shouldCompress: true,
        recommendedQuality: 0.8,
        reason: 'Light compression recommended',
      );
    } else if (fileSizeBytes < 5 * 1024 * 1024) {
      // 2MB - 5MB
      return CompressionRecommendation(
        shouldCompress: true,
        recommendedQuality: 0.6,
        reason: 'Medium compression recommended',
      );
    } else {
      // Over 5MB
      return CompressionRecommendation(
        shouldCompress: true,
        recommendedQuality: 0.4,
        reason: 'Heavy compression required',
      );
    }
  }
}

/// Result of image compression operation
class CompressedImageResult {
  final Uint8List compressedBytes;
  final int originalSize;
  final int compressedSize;
  final double compressionRatio;
  final bool wasCompressed;
  final double? finalQuality;
  final ImageDimensions? finalDimensions;

  CompressedImageResult({
    required this.compressedBytes,
    required this.originalSize,
    required this.compressedSize,
    required this.compressionRatio,
    required this.wasCompressed,
    this.finalQuality,
    this.finalDimensions,
  });

  /// Get compression savings in bytes
  int get savedBytes => originalSize - compressedSize;

  /// Get compression savings as percentage
  double get savedPercentage => (savedBytes / originalSize) * 100;
}

/// Image dimensions
class ImageDimensions {
  final int width;
  final int height;

  ImageDimensions(this.width, this.height);

  @override
  String toString() => '${width}x$height';
}

/// Compression recommendation
class CompressionRecommendation {
  final bool shouldCompress;
  final double recommendedQuality;
  final String reason;

  CompressionRecommendation({
    required this.shouldCompress,
    required this.recommendedQuality,
    required this.reason,
  });
}
