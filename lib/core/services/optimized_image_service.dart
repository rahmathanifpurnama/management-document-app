import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/anr_config.dart';
import '../utils/anr_prevention.dart';

/// MEDIUM PRIORITY: Optimized image service to prevent ANR from image operations
class OptimizedImageService {
  static OptimizedImageService? _instance;
  static OptimizedImageService get instance =>
      _instance ??= OptimizedImageService._();

  OptimizedImageService._();

  final Map<String, ImageProvider> _imageCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, Completer<ui.Image?>> _loadingImages = {};
  int _cacheSize = 0;

  /// HIGH PRIORITY: Load image with optimization and caching
  Future<ui.Image?> loadOptimizedImage(
    String imageUrl, {
    int? maxWidth,
    int? maxHeight,
    bool useCache = true,
  }) async {
    // Check cache first
    if (useCache && _imageCache.containsKey(imageUrl)) {
      final cacheTime = _cacheTimestamps[imageUrl];
      if (cacheTime != null &&
          DateTime.now().difference(cacheTime) < ANRConfig.cacheExpiry) {
        debugPrint('📦 Using cached image: $imageUrl');
        return await _loadFromCache(imageUrl);
      }
    }

    // Check if already loading
    if (_loadingImages.containsKey(imageUrl)) {
      debugPrint('⏳ Image already loading: $imageUrl');
      return await _loadingImages[imageUrl]!.future;
    }

    // Start loading
    final completer = Completer<ui.Image?>();
    _loadingImages[imageUrl] = completer;

    try {
      final image = await _loadImageInBackground(
        imageUrl,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );

      if (image != null && useCache) {
        _cacheImage(imageUrl, CachedNetworkImageProvider(imageUrl));
      }

      completer.complete(image);
      return image;
    } catch (e) {
      debugPrint('❌ Failed to load image: $imageUrl - $e');
      completer.complete(null);
      return null;
    } finally {
      _loadingImages.remove(imageUrl);
    }
  }

  /// Load image in background with timeout
  Future<ui.Image?> _loadImageInBackground(
    String imageUrl, {
    int? maxWidth,
    int? maxHeight,
  }) async {
    return await ANRPrevention.executeInBackground(
      () async {
        final imageProvider = CachedNetworkImageProvider(imageUrl);
        final imageStream = imageProvider.resolve(const ImageConfiguration());

        final completer = Completer<ui.Image?>();
        late ImageStreamListener listener;

        listener = ImageStreamListener(
          (ImageInfo info, bool synchronousCall) {
            completer.complete(info.image);
            imageStream.removeListener(listener);
          },
          onError: (exception, stackTrace) {
            debugPrint('❌ Image loading error: $exception');
            completer.complete(null);
            imageStream.removeListener(listener);
          },
        );

        imageStream.addListener(listener);

        // Add timeout
        Timer(ANRConfig.networkTimeout, () {
          if (!completer.isCompleted) {
            debugPrint('⏰ Image loading timeout: $imageUrl');
            imageStream.removeListener(listener);
            completer.complete(null);
          }
        });

        final image = await completer.future;

        if (image == null) {
          throw Exception('Failed to load image');
        }

        // Resize if needed
        if (maxWidth != null || maxHeight != null) {
          final resized = await _resizeImage(image, maxWidth, maxHeight);
          return resized ?? image;
        }

        return image;
      },
      timeout: ANRConfig.networkTimeout,
      operationName: 'Image Loading - $imageUrl',
    );
  }

  /// Resize image to prevent memory issues
  Future<ui.Image?> _resizeImage(
    ui.Image originalImage,
    int? maxWidth,
    int? maxHeight,
  ) async {
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      // Calculate new dimensions
      final originalWidth = originalImage.width;
      final originalHeight = originalImage.height;

      double scaleX = maxWidth != null ? maxWidth / originalWidth : 1.0;
      double scaleY = maxHeight != null ? maxHeight / originalHeight : 1.0;
      double scale = scaleX < scaleY ? scaleX : scaleY;

      if (scale >= 1.0) {
        return originalImage; // No need to resize
      }

      final newWidth = (originalWidth * scale).round();
      final newHeight = (originalHeight * scale).round();

      // Draw resized image
      canvas.scale(scale);
      canvas.drawImage(originalImage, Offset.zero, Paint());

      final picture = recorder.endRecording();
      final resizedImage = await picture.toImage(newWidth, newHeight);

      picture.dispose();
      return resizedImage;
    } catch (e) {
      debugPrint('❌ Failed to resize image: $e');
      return originalImage;
    }
  }

  /// Load image from cache
  Future<ui.Image?> _loadFromCache(String imageUrl) async {
    final imageProvider = _imageCache[imageUrl];
    if (imageProvider == null) return null;

    try {
      final imageStream = imageProvider.resolve(const ImageConfiguration());
      final completer = Completer<ui.Image?>();
      late ImageStreamListener listener;

      listener = ImageStreamListener(
        (ImageInfo info, bool synchronousCall) {
          completer.complete(info.image);
          imageStream.removeListener(listener);
        },
        onError: (exception, stackTrace) {
          completer.complete(null);
          imageStream.removeListener(listener);
        },
      );

      imageStream.addListener(listener);
      return await completer.future;
    } catch (e) {
      debugPrint('❌ Failed to load from cache: $e');
      return null;
    }
  }

  /// Cache image provider
  void _cacheImage(String imageUrl, ImageProvider imageProvider) {
    _imageCache[imageUrl] = imageProvider;
    _cacheTimestamps[imageUrl] = DateTime.now();
    _cacheSize++;

    // Clean cache if too large
    if (_cacheSize > ANRConfig.maxImageCacheSize) {
      _cleanCache();
    }
  }

  /// Clean old cache entries
  void _cleanCache() {
    final now = DateTime.now();
    final keysToRemove = <String>[];

    // Remove expired entries
    for (final entry in _cacheTimestamps.entries) {
      if (now.difference(entry.value) > ANRConfig.cacheExpiry) {
        keysToRemove.add(entry.key);
      }
    }

    // Remove oldest entries if still too large
    if (_cacheSize - keysToRemove.length > ANRConfig.maxImageCacheSize) {
      final sortedEntries = _cacheTimestamps.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));

      final additionalToRemove =
          _cacheSize - keysToRemove.length - ANRConfig.maxImageCacheSize;
      for (int i = 0; i < additionalToRemove && i < sortedEntries.length; i++) {
        if (!keysToRemove.contains(sortedEntries[i].key)) {
          keysToRemove.add(sortedEntries[i].key);
        }
      }
    }

    // Remove entries
    for (final key in keysToRemove) {
      _imageCache.remove(key);
      _cacheTimestamps.remove(key);
      _cacheSize--;
    }

    debugPrint(
      '🧹 Image cache cleaned: removed ${keysToRemove.length} entries',
    );
  }

  /// Preload images for better performance
  Future<void> preloadImages(List<String> imageUrls) async {
    debugPrint('🔄 Preloading ${imageUrls.length} images...');

    // Process in batches to prevent overwhelming the system
    for (int i = 0; i < imageUrls.length; i += ANRConfig.smallBatchSize) {
      final batch = imageUrls.skip(i).take(ANRConfig.smallBatchSize).toList();

      await Future.wait(batch.map((url) => loadOptimizedImage(url)));

      // Yield between batches
      await Future.delayed(ANRConfig.batchDelay);
    }

    debugPrint('✅ Image preloading completed');
  }

  /// Get cache statistics
  Map<String, dynamic> getCacheStats() {
    return {
      'cachedImages': _cacheSize,
      'loadingImages': _loadingImages.length,
      'oldestCacheEntry': _cacheTimestamps.values.isEmpty
          ? null
          : _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b),
      'newestCacheEntry': _cacheTimestamps.values.isEmpty
          ? null
          : _cacheTimestamps.values.reduce((a, b) => a.isAfter(b) ? a : b),
    };
  }

  /// Clear all cache
  void clearCache() {
    _imageCache.clear();
    _cacheTimestamps.clear();
    _cacheSize = 0;
    debugPrint('🧹 Image cache cleared');
  }

  /// Dispose service
  void dispose() {
    clearCache();
    _loadingImages.clear();
    debugPrint('🗑️ OptimizedImageService disposed');
  }
}

/// Optimized image widget that uses the service
class OptimizedNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int? maxWidth;
  final int? maxHeight;

  const OptimizedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  State<OptimizedNetworkImage> createState() => _OptimizedNetworkImageState();
}

class _OptimizedNetworkImageState extends State<OptimizedNetworkImage> {
  ui.Image? _image;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(OptimizedNetworkImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final image = await OptimizedImageService.instance.loadOptimizedImage(
        widget.imageUrl,
        maxWidth: widget.maxWidth,
        maxHeight: widget.maxHeight,
      );

      if (mounted) {
        setState(() {
          _image = image;
          _isLoading = false;
          _hasError = image == null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
    }

    if (_hasError || _image == null) {
      return widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.red),
          );
    }

    return CustomPaint(
      size: Size(
        widget.width ?? double.infinity,
        widget.height ?? double.infinity,
      ),
      painter: _ImagePainter(_image!, widget.fit),
    );
  }
}

/// Custom painter for optimized image rendering
class _ImagePainter extends CustomPainter {
  final ui.Image image;
  final BoxFit fit;

  _ImagePainter(this.image, this.fit);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..filterQuality = FilterQuality.medium;

    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final fittedSize = _applyBoxFit(fit, imageSize, size);

    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final dstRect = Rect.fromLTWH(
      (size.width - fittedSize.width) / 2,
      (size.height - fittedSize.height) / 2,
      fittedSize.width,
      fittedSize.height,
    );

    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  Size _applyBoxFit(BoxFit fit, Size inputSize, Size outputSize) {
    switch (fit) {
      case BoxFit.contain:
        final scale = (outputSize.width / inputSize.width).clamp(
          0.0,
          outputSize.height / inputSize.height,
        );
        return Size(inputSize.width * scale, inputSize.height * scale);
      case BoxFit.cover:
        final scale = (outputSize.width / inputSize.width).clamp(
          outputSize.height / inputSize.height,
          double.infinity,
        );
        return Size(inputSize.width * scale, inputSize.height * scale);
      case BoxFit.fill:
        return outputSize;
      default:
        return inputSize;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! _ImagePainter || oldDelegate.image != image;
  }
}
