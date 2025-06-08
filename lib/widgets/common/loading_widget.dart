import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final bool showMessage;

  const LoadingWidget({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.showMessage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitFadingCircle(
                color: indicatorColor ?? AppColors.primary,
                size: 50,
              ),
              if (showMessage) ...[
                const SizedBox(height: 16),
                Text(
                  message ?? AppStrings.loading,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Simple loading indicator without overlay
class SimpleLoadingWidget extends StatelessWidget {
  final Color? color;
  final double size;

  const SimpleLoadingWidget({super.key, this.color, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SpinKitFadingCircle(color: color ?? AppColors.primary, size: size);
  }
}

// Loading button content
class LoadingButtonContent extends StatelessWidget {
  final String text;
  final Color? color;

  const LoadingButtonContent({super.key, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitThreeBounce(color: color ?? AppColors.textWhite, size: 16),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: color ?? AppColors.textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

// Page loading widget
class PageLoadingWidget extends StatelessWidget {
  final String? message;

  const PageLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitFadingCircle(color: AppColors.primary, size: 60),
            const SizedBox(height: 24),
            Text(
              message ?? AppStrings.loading,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// List loading widget
class ListLoadingWidget extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListLoadingWidget({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Container(
          height: itemHeight,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Center(
            child: SpinKitPulse(color: AppColors.border, size: 40),
          ),
        );
      },
    );
  }
}

// Card loading widget
class CardLoadingWidget extends StatelessWidget {
  final double? width;
  final double height;

  const CardLoadingWidget({super.key, this.width, this.height = 120});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Center(
        child: SpinKitPulse(color: AppColors.border, size: 30),
      ),
    );
  }
}
