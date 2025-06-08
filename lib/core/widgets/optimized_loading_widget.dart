import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../constants/app_colors.dart';

/// Optimized loading widget that doesn't block the main thread
class OptimizedLoadingWidget extends StatefulWidget {
  final String? message;
  final Color? color;
  final double? size;
  final bool showMessage;
  final Duration animationDuration;

  const OptimizedLoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = 40.0,
    this.showMessage = true,
    this.animationDuration = const Duration(milliseconds: 1200),
  });

  @override
  State<OptimizedLoadingWidget> createState() => _OptimizedLoadingWidgetState();
}

class _OptimizedLoadingWidgetState extends State<OptimizedLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Optimized spinner that doesn't cause frame drops
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animation.value * 2.0 * 3.14159,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: (widget.color ?? AppColors.primary).withValues(
                        alpha: 0.3,
                      ),
                      width: 3.0,
                    ),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.color ?? AppColors.primary,
                          (widget.color ?? AppColors.primary).withValues(
                            alpha: 0.1,
                          ),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          if (widget.showMessage && widget.message != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.message!,
              style: TextStyle(
                color: widget.color ?? AppColors.primary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Simple loading overlay that doesn't block UI
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;
  final Color? backgroundColor;
  final Color? loadingColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
    this.backgroundColor,
    this.loadingColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: backgroundColor ?? Colors.black.withValues(alpha: 0.3),
            child: OptimizedLoadingWidget(
              message: loadingMessage ?? 'Loading...',
              color: loadingColor ?? AppColors.primary,
            ),
          ),
      ],
    );
  }
}

/// Lightweight loading indicator for lists
class ListLoadingIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  const ListLoadingIndicator({super.key, this.color, this.size = 20.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(
              color ?? AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

/// Shimmer loading effect for better UX
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      _controller.repeat();
    } else if (!widget.isLoading && oldWidget.isLoading) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                widget.baseColor ?? Colors.grey[300]!,
                widget.highlightColor ?? Colors.grey[100]!,
                widget.baseColor ?? Colors.grey[300]!,
              ],
              stops: [
                _animation.value - 0.3,
                _animation.value,
                _animation.value + 0.3,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// Adaptive loading widget that chooses the best loading indicator
class AdaptiveLoadingWidget extends StatelessWidget {
  final String? message;
  final LoadingType type;
  final Color? color;
  final double? size;

  const AdaptiveLoadingWidget({
    super.key,
    this.message,
    this.type = LoadingType.spinner,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case LoadingType.spinner:
        return OptimizedLoadingWidget(
          message: message,
          color: color,
          size: size,
        );
      case LoadingType.dots:
        return SpinKitThreeBounce(
          color: color ?? AppColors.primary,
          size: size ?? 20.0,
        );
      case LoadingType.wave:
        return SpinKitWave(
          color: color ?? AppColors.primary,
          size: size ?? 30.0,
        );
      case LoadingType.pulse:
        return SpinKitPulse(
          color: color ?? AppColors.primary,
          size: size ?? 40.0,
        );
    }
  }
}

enum LoadingType { spinner, dots, wave, pulse }
