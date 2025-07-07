part of '../home_screen.dart';

class HomeSearchSection extends StatefulWidget {
  final TextEditingController searchController;
  final VoidCallback? onSearchChanged;

  const HomeSearchSection({
    super.key,
    required this.searchController,
    this.onSearchChanged,
  });

  factory HomeSearchSection.withDebouncing({
    required TextEditingController controller,
    required VoidCallback onSearchChanged,
    Duration debounceDelay = const Duration(milliseconds: 300),
  }) {
    return HomeSearchSection(
      searchController: controller,
      onSearchChanged: onSearchChanged,
    );
  }

  @override
  State<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends State<HomeSearchSection> {
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_onSearchTextChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    widget.searchController.removeListener(_onSearchTextChanged);
    super.dispose();
  }

  void _onSearchTextChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      widget.onSearchChanged?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive margin - OPTIMIZED
    final screenWidth = MediaQuery.of(context).size.width;
    final responsiveMargin = EdgeInsets.only(
      left: screenWidth < 400 ? 12.0 : 16.0,
      right: screenWidth < 400 ? 12.0 : 16.0,
      top: 0, // Add top margin for spacing with greeting
      bottom: 0,
    );
    final responsiveElevation = 2.0;

    return Container(
      margin: responsiveMargin,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: _SearchField(
        controller: widget.searchController,
        onClear: _clearSearch,
      ),
    );
  }

  void _clearSearch() {
    widget.searchController.clear();
    widget.onSearchChanged?.call();
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onClear;

  const _SearchField({required this.controller, this.onClear});

  @override
  Widget build(BuildContext context) {
    // Get responsive values - OPTIMIZED
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final responsiveBorderRadius = isSmallScreen ? 12.0 : 16.0;
    final fontSize = isSmallScreen ? 14.0 : 15.0;
    final iconSize = isSmallScreen ? 18.0 : 20.0;
    final verticalPadding = isSmallScreen ? 12.0 : 14.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(
          fontSize: fontSize,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search files...',
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
    );
  }

  Widget? _buildSuffixIcon(BuildContext context) {
    if (controller.text.isEmpty) return null;

    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 400 ? 18.0 : 20.0;

    return IconButton(
      icon: Icon(Icons.clear, color: AppColors.textSecondary, size: iconSize),
      onPressed: onClear,
      splashRadius: iconSize,
    );
  }
}
