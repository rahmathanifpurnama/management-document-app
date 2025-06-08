import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// iOS-style back button widget that can be used as leading in AppBar
class IOSBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final EdgeInsets? margin;

  const IOSBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(left: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed ?? () => Navigator.of(context).pop(),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          child: Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            child: Icon(
              Icons.arrow_back_ios,
              color: color ?? AppColors.textWhite,
              size: size ?? 24,
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple iOS-style back button for AppBar leading
class SimpleIOSBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const SimpleIOSBackButton({
    super.key,
    this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () => Navigator.of(context).pop(),
      icon: Icon(
        Icons.arrow_back_ios,
        color: color ?? AppColors.textWhite,
        size: 24,
      ),
      padding: const EdgeInsets.only(left: 12),
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    );
  }
}
