import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

/// Reusable search widget that matches the design pattern used in home and category screens
class ReusableSearchWidget extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;
  final bool showClearButton;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const ReusableSearchWidget({
    super.key,
    required this.controller,
    this.hintText = 'Search files...',
    this.onChanged,
    this.onClear,
    this.showClearButton = true,
    this.margin,
    this.padding,
  });

  @override
  State<ReusableSearchWidget> createState() => _ReusableSearchWidgetState();
}

class _ReusableSearchWidgetState extends State<ReusableSearchWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      // Rebuild to show/hide clear button
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive values - consistent with home and category screens
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final responsiveBorderRadius = isSmallScreen ? 12.0 : 16.0;
    final responsiveElevation = 2.0;
    final fontSize = isSmallScreen ? 14.0 : 15.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final verticalPadding = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    // Default responsive margin if not provided
    final defaultMargin = EdgeInsets.symmetric(
      horizontal: screenWidth < 400 ? 12.0 : 16.0,
      vertical: 8,
    );

    return Container(
      margin: widget.margin ?? defaultMargin,
      padding: widget.padding,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: responsiveElevation * 2,
              offset: Offset(0, responsiveElevation / 2),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          onChanged: widget.onChanged,
          style: GoogleFonts.poppins(
            fontSize: fontSize,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(
              fontSize: fontSize,
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textSecondary,
              size: iconSize,
            ),
            suffixIcon: _buildSuffixIcon(context),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (!widget.showClearButton || widget.controller.text.isEmpty) return null;

    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 400 ? 18.0 : 20.0;

    return IconButton(
      icon: Icon(Icons.clear, color: AppColors.textSecondary, size: iconSize),
      onPressed:
          widget.onClear ??
          () {
            widget.controller.clear();
            if (widget.onChanged != null) {
              widget.onChanged!('');
            }
          },
      splashRadius: iconSize,
    );
  }
}
