import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../features/file_selection/providers/file_selection_providers.dart';

/// Reusable add-only selection bar widget with responsive design
class AddOnlySelectionBarWidget extends ConsumerWidget {
  final String screenId; // Required for isolated file selection
  final VoidCallback? onAdd;
  final VoidCallback? onClose;
  final String? addButtonText;
  final String? selectionText;

  const AddOnlySelectionBarWidget({
    super.key,
    required this.screenId,
    this.onAdd,
    this.onClose,
    this.addButtonText,
    this.selectionText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectionState = ref.watch(isolatedFileSelectionProvider(screenId));
    final actions = ref.read(isolatedFileSelectionActionsProvider(screenId));

    if (!selectionState.isSelectionMode) {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 12 : 16,
        vertical: isSmallScreen ? 8 : 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: isSmallScreen
          ? _buildCompactLayout(selectionState, actions)
          : _buildStandardLayout(isTablet, selectionState, actions),
    );
  }

  Widget _buildCompactLayout(selectionState, actions) {
    return Column(
      children: [
        Row(
          children: [
            _buildCloseButton(true, actions),
            const SizedBox(width: 8),
            Expanded(child: _buildSelectionText(true, false, selectionState)),
          ],
        ),
        if (selectionState.selectedFileIds.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildSelectAllButton(
                  true,
                  false,
                  selectionState,
                  actions,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(child: _buildAddButton(true, false)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildStandardLayout(bool isTablet, selectionState, actions) {
    return Row(
      children: [
        _buildCloseButton(false, actions),
        const SizedBox(width: 12),
        Expanded(child: _buildSelectionText(false, isTablet, selectionState)),
        if (selectionState.selectedFileIds.isNotEmpty) ...[
          _buildSelectAllButton(false, isTablet, selectionState, actions),
          const SizedBox(width: 8),
          _buildAddButton(false, isTablet),
        ],
      ],
    );
  }

  Widget _buildCloseButton(bool isSmallScreen, actions) {
    return IconButton(
      onPressed: onClose ?? () => actions.exitSelectionMode(),
      icon: const Icon(Icons.close),
      color: AppColors.primary,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(
        minWidth: isSmallScreen ? 28 : 32,
        minHeight: isSmallScreen ? 28 : 32,
      ),
    );
  }

  Widget _buildSelectionText(
    bool isSmallScreen,
    bool isTablet,
    selectionState,
  ) {
    return Text(
      selectionText ??
          '${selectionState.selectedFileIds.length} file(s) selected',
      style: GoogleFonts.poppins(
        fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSelectAllButton(
    bool isSmallScreen,
    bool isTablet,
    selectionState,
    actions,
  ) {
    final isAllSelected =
        selectionState.availableFiles.isNotEmpty &&
        selectionState.selectedFileIds.length ==
            selectionState.availableFiles.length;

    return TextButton(
      onPressed: isAllSelected ? actions.clearSelection : actions.selectAll,
      child: Text(
        isAllSelected ? 'Clear All' : 'Select All',
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAddButton(bool isSmallScreen, bool isTablet) {
    return ElevatedButton.icon(
      onPressed: onAdd,
      icon: Icon(Icons.add, size: isSmallScreen ? 16 : 18),
      label: Text(
        addButtonText ?? 'Add',
        style: GoogleFonts.poppins(
          fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
          fontWeight: FontWeight.w600,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.success,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
