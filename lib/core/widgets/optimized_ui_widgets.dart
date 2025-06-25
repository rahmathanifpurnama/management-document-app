import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/anr_config.dart';

/// HIGH PRIORITY: Optimized ListView to prevent ANR
class OptimizedListView extends StatefulWidget {
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final ScrollController? controller;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double? itemExtent;
  final Widget? loadingWidget;
  final VoidCallback? onLoadMore;
  final bool hasMore;

  const OptimizedListView({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
    this.itemExtent,
    this.loadingWidget,
    this.onLoadMore,
    this.hasMore = false,
  });

  @override
  State<OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<OptimizedListView> {
  late ScrollController _scrollController;
  Timer? _scrollTimer;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.controller ?? ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollTimer?.cancel();
    if (widget.controller == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onScroll() {
    // Debounce scroll events to prevent excessive calls
    _scrollTimer?.cancel();
    _scrollTimer = Timer(ANRConfig.debounceDelay, () {
      if (!mounted) return;

      // Check if near bottom for load more
      if (widget.onLoadMore != null &&
          widget.hasMore &&
          !_isLoadingMore &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200) {
        _loadMore();
      }
    });
  }

  void _loadMore() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      widget.onLoadMore?.call();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemExtent: widget.itemExtent,
      cacheExtent: ANRConfig.maxListViewCacheExtent.toDouble(),
      itemCount: widget.itemCount + (_isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= widget.itemCount) {
          return widget.loadingWidget ??
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
        }

        // Wrap item builder with error boundary
        return _ItemWrapper(index: index, builder: widget.itemBuilder);
      },
    );
  }
}

/// Item wrapper with error handling
class _ItemWrapper extends StatelessWidget {
  final int index;
  final Widget Function(BuildContext context, int index) builder;

  const _ItemWrapper({required this.index, required this.builder});

  @override
  Widget build(BuildContext context) {
    try {
      return builder(context, index);
    } catch (e) {
      debugPrint('❌ Error building item at index $index: $e');
      return Container(
        height: 60,
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: Text(
            'Error loading item',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}

/// HIGH PRIORITY: Optimized image widget to prevent ANR
class OptimizedImageWidget extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Duration fadeInDuration;
  final bool useMemoryCache;

  const OptimizedImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.useMemoryCache = true,
  });

  @override
  State<OptimizedImageWidget> createState() => _OptimizedImageWidgetState();
}

class _OptimizedImageWidgetState extends State<OptimizedImageWidget> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      fadeInDuration: widget.fadeInDuration,
      memCacheWidth: widget.width?.toInt(),
      memCacheHeight: widget.height?.toInt(),
      maxWidthDiskCache: 800,
      maxHeightDiskCache: 600,
      placeholder: (context, url) =>
          widget.placeholder ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      errorWidget: (context, url, error) =>
          widget.errorWidget ??
          Container(
            width: widget.width,
            height: widget.height,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline, color: Colors.red),
          ),
    );
  }
}

/// MEDIUM PRIORITY: Debounced text field to prevent excessive rebuilds
class DebouncedTextField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final Function(String value)? onChanged;
  final Duration debounceDelay;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final int? maxLines;

  const DebouncedTextField({
    super.key,
    this.initialValue,
    this.hintText,
    this.onChanged,
    this.debounceDelay = const Duration(milliseconds: 300),
    this.keyboardType,
    this.controller,
    this.decoration,
    this.maxLines = 1,
  });

  @override
  State<DebouncedTextField> createState() => _DebouncedTextFieldState();
}

class _DebouncedTextFieldState extends State<DebouncedTextField> {
  late TextEditingController _controller;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ?? TextEditingController(text: widget.initialValue);
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(widget.debounceDelay, () {
      if (mounted) {
        widget.onChanged?.call(_controller.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      keyboardType: widget.keyboardType,
      maxLines: widget.maxLines,
      decoration:
          widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            border: const OutlineInputBorder(),
          ),
    );
  }
}

/// MEDIUM PRIORITY: Throttled button to prevent rapid taps
class ThrottledButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final Duration throttleDuration;
  final ButtonStyle? style;

  const ThrottledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.throttleDuration = const Duration(milliseconds: 500),
    this.style,
  });

  @override
  State<ThrottledButton> createState() => _ThrottledButtonState();
}

class _ThrottledButtonState extends State<ThrottledButton> {
  bool _isThrottled = false;
  Timer? _throttleTimer;

  @override
  void dispose() {
    _throttleTimer?.cancel();
    super.dispose();
  }

  void _handlePress() {
    if (_isThrottled || widget.onPressed == null) return;

    setState(() {
      _isThrottled = true;
    });

    widget.onPressed!();

    _throttleTimer = Timer(widget.throttleDuration, () {
      if (mounted) {
        setState(() {
          _isThrottled = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isThrottled ? null : _handlePress,
      style: widget.style,
      child: widget.child,
    );
  }
}

/// LOW PRIORITY: Performance monitor widget
class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> {
  Timer? _performanceTimer;
  int _frameCount = 0;
  double _fps = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enabled) {
      _startMonitoring();
    }
  }

  @override
  void dispose() {
    _performanceTimer?.cancel();
    super.dispose();
  }

  void _startMonitoring() {
    _performanceTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _fps = _frameCount.toDouble();
          _frameCount = 0;
        });

        if (_fps < 30) {
          debugPrint('⚠️ Low FPS detected: ${_fps.toStringAsFixed(1)}');
        }
      }
    });

    // Count frames
    WidgetsBinding.instance.addPostFrameCallback(_countFrame);
  }

  void _countFrame(Duration timestamp) {
    if (mounted && widget.enabled) {
      _frameCount++;
      WidgetsBinding.instance.addPostFrameCallback(_countFrame);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    return Stack(
      children: [
        widget.child,
        Positioned(
          top: 50,
          right: 10,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'FPS: ${_fps.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
