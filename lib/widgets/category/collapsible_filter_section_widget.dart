import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/document_provider.dart';
import '../../widgets/common/embedded_file_filter_widget.dart';

/// Reusable collapsible filter section widget with responsive design
class CollapsibleFilterSectionWidget extends StatefulWidget {
  final String title;
  final bool initiallyExpanded;
  final VoidCallback? onFilterApplied;
  final EdgeInsets? margin;
  final bool showActiveIndicator;

  const CollapsibleFilterSectionWidget({
    super.key,
    this.title = 'Available Files',
    this.initiallyExpanded = false,
    this.onFilterApplied,
    this.margin,
    this.showActiveIndicator = true,
  });

  @override
  State<CollapsibleFilterSectionWidget> createState() => 
    _CollapsibleFilterSectionWidgetState();
}

class _CollapsibleFilterSectionWidgetState 
    extends State<CollapsibleFilterSectionWidget> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Consumer<DocumentProvider>(
      builder: (context, documentProvider, child) {
        final hasActiveFilters = _hasActiveFilters(documentProvider);

        return Container(
          margin: widget.margin ?? EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: 8,
          ),
          child: Column(
            children: [
              _buildHeader(hasActiveFilters, isSmallScreen, isTablet),
              _buildCollapsibleContent(isSmallScreen),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool hasActiveFilters, bool isSmallScreen, bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 6 : 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Title
          Text(
            widget.title,
            style: GoogleFonts.poppins(
              fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          // Filter controls
          Row(
            children: [
              // Active filter indicator
              if (widget.showActiveIndicator && hasActiveFilters) ...[
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Active',
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 8 : 10,
                      fontWeight: FontWeight.w500,
                      color: AppColors.surface,
                    ),
                  ),
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
              ],
              // Filter button
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: Icon(
                  _isExpanded ? Icons.expand_less : Icons.filter_list,
                  color: hasActiveFilters
                    ? AppColors.primary
                    : AppColors.textSecondary,
                  size: isSmallScreen ? 18 : 20,
                ),
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(
                  minWidth: isSmallScreen ? 20 : 24,
                  minHeight: isSmallScreen ? 20 : 24,
                ),
                tooltip: _isExpanded ? 'Collapse Filter' : 'Filter Files',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCollapsibleContent(bool isSmallScreen) {
    return AnimatedCrossFade(
      duration: const Duration(milliseconds: 300),
      crossFadeState: _isExpanded
        ? CrossFadeState.showSecond
        : CrossFadeState.showFirst,
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        margin: EdgeInsets.only(top: isSmallScreen ? 6 : 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border.withValues(alpha: 0.3),
          ),
        ),
        child: EmbeddedFileFilterWidget(
          onFilterApplied: () {
            widget.onFilterApplied?.call();
            // Optionally auto-collapse after filter selection
            setState(() {
              _isExpanded = false;
            });
          },
          onClose: () {
            setState(() {
              _isExpanded = false;
            });
          },
        ),
      ),
    );
  }

  bool _hasActiveFilters(DocumentProvider documentProvider) {
    return documentProvider.selectedFileType != 'all' ||
<<<<<<< HEAD
        documentProvider.sortBy != 'uploadedAt' ||
        documentProvider.sortAscending != false;
=======
           documentProvider.sortBy != 'uploadedAt' ||
           documentProvider.sortAscending != false;
>>>>>>> 8ff65934565a2537ce29afec4698495f8a5c35ae
  }
}
