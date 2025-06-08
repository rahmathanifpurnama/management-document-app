part of '../home_screen.dart';

class HomeGreetingSection extends StatelessWidget {
  final AuthProvider authProvider;
  final GreetingSet currentGreeting;
  final VoidCallback? onProfileTap;

  const HomeGreetingSection({
    super.key,
    required this.authProvider,
    required this.currentGreeting,
    this.onProfileTap,
  });

  factory HomeGreetingSection.withCurrentUser({
    required BuildContext context,
    required GreetingSet greeting,
    VoidCallback? onProfileTap,
  }) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return HomeGreetingSection(
      authProvider: authProvider,
      currentGreeting: greeting,
      onProfileTap: onProfileTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get responsive values - OPTIMIZED FOR MOBILE
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    final responsiveMargin = EdgeInsets.symmetric(
      horizontal: isSmallScreen ? 12.0 : 16.0,
      vertical: 0, // No vertical margin
    );
    final responsivePadding = EdgeInsets.all(isSmallScreen ? 12.0 : 16.0);
    final responsiveBorderRadius = isSmallScreen ? 12.0 : 16.0;
    final responsiveSpacing = isSmallScreen ? 12.0 : 16.0;
    final responsiveElevation = 2.0;

    return Container(
      margin: responsiveMargin,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: responsiveElevation * 2,
            offset: Offset(0, responsiveElevation / 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(responsiveBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(responsiveBorderRadius),
          onLongPress: onProfileTap,
          child: Padding(
            padding: responsivePadding,
            child: Row(
              children: [
                // User Avatar
                _buildUserAvatar(context),
                SizedBox(width: responsiveSpacing),
                // Greeting Content
                Expanded(child: _buildGreetingContent(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar(BuildContext context) {
    // Get responsive avatar size - OPTIMIZED
    final screenWidth = MediaQuery.of(context).size.width;
    final avatarSize = screenWidth < 400 ? 50.0 : 60.0; // Reduced from 60-70
    final borderRadius = avatarSize / 2;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 2),
        child:
            authProvider.currentUser?.profileImage != null &&
                authProvider.currentUser!.profileImage!.isNotEmpty
            ? Image.network(
                authProvider.currentUser!.profileImage!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _buildDefaultAvatar(context),
              )
            : _buildDefaultAvatar(context),
      ),
    );
  }

  Widget _buildDefaultAvatar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final iconSize = screenWidth < 400 ? 24.0 : 30.0;
    return Icon(Icons.person, color: AppColors.primary, size: iconSize);
  }

  Widget _buildGreetingContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final textSpacing = isSmallScreen ? 1.0 : 2.0;

    // Fixed font sizes untuk konsistensi
    final welcomeFontSize = isSmallScreen ? 14.0 : 18.0; // Selalu besar
    final greetingFontSize = isSmallScreen ? 13.0 : 14.0; // Selalu sedang

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Personal greeting (Good morning, etc.) - SEDANG
        Text(
          currentGreeting.personalGreeting,
          style: GoogleFonts.poppins(
            fontSize: welcomeFontSize, // Fixed size sedang
            fontWeight: FontWeight.w700, // Lebih bold
            color: AppColors.textPrimary, // Warna lebih soft
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: textSpacing),
        // Main greeting (Welcome User) - BESAR
        Text(
          currentGreeting.mainGreeting,
          style: GoogleFonts.poppins(
            fontSize: greetingFontSize, // Fixed size besar
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  double _calculateResponsiveFontSize(
    BuildContext context,
    String text, {
    bool isPersonal = false,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    // Base sizes optimized for mobile
    final baseMaxFontSize = isSmallScreen
        ? (isPersonal ? 13.0 : 16.0)
        : (isPersonal ? 14.0 : 18.0);
    final baseMinFontSize = isSmallScreen
        ? (isPersonal ? 11.0 : 13.0)
        : (isPersonal ? 12.0 : 14.0);

    const int shortTextThreshold = 15;
    const int longTextThreshold = 30;

    final textLength = text.length;

    if (textLength <= shortTextThreshold) {
      return baseMaxFontSize;
    } else if (textLength <= longTextThreshold) {
      final ratio =
          (textLength - shortTextThreshold) /
          (longTextThreshold - shortTextThreshold);
      return baseMaxFontSize - (ratio * (baseMaxFontSize - baseMinFontSize));
    } else {
      return baseMinFontSize;
    }
  }
}
