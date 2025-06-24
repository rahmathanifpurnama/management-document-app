import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool automaticallyImplyLeading;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.automaticallyImplyLeading = true,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? AppColors.textWhite,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textWhite,
      elevation: elevation,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      actions: actions,
      bottom: bottom,
      iconTheme: IconThemeData(color: foregroundColor ?? AppColors.textWhite),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? AppColors.textWhite,
      ),
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

// Specialized app bar variants
class PrimaryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;

  const PrimaryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final Color? foregroundColor;

  const TransparentAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      title: title,
      actions: actions,
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.textPrimary,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final List<Widget>? actions;

  const SearchAppBar({
    super.key,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.controller,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      title: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.textWhite, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: AppColors.textWhite.withValues(alpha: 0.7),
            fontSize: 16,
          ),
          border: InputBorder.none,
          suffixIcon: controller?.text.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textWhite),
                  onPressed: onClear,
                )
              : null,
        ),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Custom App Bar with Asset Icons
class AssetIconAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? leadingIconAsset;
  final List<AssetIconAction>? actions;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final VoidCallback? onLeadingPressed;

  const AssetIconAppBar({
    super.key,
    required this.title,
    this.leadingIconAsset,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: foregroundColor ?? AppColors.textWhite,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.textWhite,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: leadingIconAsset != null
          ? IconButton(
              onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
              icon: SvgPicture.asset(
                leadingIconAsset!,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  foregroundColor ?? AppColors.textWhite,
                  BlendMode.srcIn,
                ),
              ),
            )
          : null,
      actions: actions?.map((action) => _buildAssetIconAction(action)).toList(),
    );
  }

  Widget _buildAssetIconAction(AssetIconAction action) {
    return IconButton(
      onPressed: action.onPressed,
      icon: SvgPicture.asset(
        action.assetPath,
        width: action.size ?? 24,
        height: action.size ?? 24,
        colorFilter: ColorFilter.mode(
          action.color ?? foregroundColor ?? AppColors.textWhite,
          BlendMode.srcIn,
        ),
      ),
      tooltip: action.tooltip,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Asset Icon Action Model
class AssetIconAction {
  final String assetPath;
  final VoidCallback onPressed;
  final Color? color;
  final double? size;
  final String? tooltip;

  const AssetIconAction({
    required this.assetPath,
    required this.onPressed,
    this.color,
    this.size,
    this.tooltip,
  });
}

// Predefined App Bars with Asset Icons
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? actions;

  const HomeAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AssetIconAppBar(
      title: title,
      actions: actions,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CategoryAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? actions;
  final VoidCallback? onBackPressed;

  const CategoryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AssetIconAppBar(
      title: title,
      leadingIconAsset: 'assets/icon/Category.svg',
      actions: actions,
      onLeadingPressed: onBackPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ActivityAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? actions;
  final VoidCallback? onBackPressed;

  const ActivityAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AssetIconAppBar(
      title: title,
      leadingIconAsset: 'assets/icon/Activity.svg',
      actions: actions,
      onLeadingPressed: onBackPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ProfileAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? actions;
  final VoidCallback? onBackPressed;

  const ProfileAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AssetIconAppBar(
      title: title,
      leadingIconAsset: 'assets/icon/Profile.svg',
      actions: actions,
      onLeadingPressed: onBackPressed,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Upload App Bar with Adding icon in center
class UploadAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? leftActions;
  final List<AssetIconAction>? rightActions;
  final VoidCallback? onUploadPressed;
  final VoidCallback? onBackPressed;
  final bool showUploadButton;

  const UploadAppBar({
    super.key,
    required this.title,
    this.leftActions,
    this.rightActions,
    this.onUploadPressed,
    this.onBackPressed,
    this.showUploadButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: onBackPressed != null
          ? IconButton(
              onPressed: onBackPressed,
              icon: const Icon(Icons.arrow_back),
            )
          : null,
      actions: [
        // Left actions
        if (leftActions != null)
          ...leftActions!.map((action) => _buildAssetIconAction(action)),

        // Spacer to push upload button to center
        const Spacer(),

        // Upload button in center
        if (showUploadButton)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.textWhite.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              onPressed:
                  onUploadPressed ??
                  () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Upload pressed!')),
                    );
                  },
              icon: SvgPicture.asset(
                'assets/icon/Adding.svg',
                width: 28,
                height: 28,
                colorFilter: const ColorFilter.mode(
                  AppColors.textWhite,
                  BlendMode.srcIn,
                ),
              ),
              tooltip: 'Upload Document',
            ),
          ),

        // Spacer to balance the layout
        const Spacer(),

        // Right actions
        if (rightActions != null)
          ...rightActions!.map((action) => _buildAssetIconAction(action)),
      ],
    );
  }

  Widget _buildAssetIconAction(AssetIconAction action) {
    return IconButton(
      onPressed: action.onPressed,
      icon: SvgPicture.asset(
        action.assetPath,
        width: action.size ?? 24,
        height: action.size ?? 24,
        colorFilter: ColorFilter.mode(
          action.color ?? AppColors.textWhite,
          BlendMode.srcIn,
        ),
      ),
      tooltip: action.tooltip,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Simplified Upload App Bar (most common use case)
class SimpleUploadAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onUploadPressed;
  final VoidCallback? onBackPressed;

  const SimpleUploadAppBar({
    super.key,
    required this.title,
    this.onUploadPressed,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return UploadAppBar(
      title: title,
      onUploadPressed: onUploadPressed,
      onBackPressed: onBackPressed,
      rightActions: [
        AssetIconAction(
          assetPath: 'assets/icon/home.svg',
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (route) => false);
          },
          tooltip: 'Go to Home',
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Manage Category App Bar with back button
class ManageCategoryAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final List<AssetIconAction>? actions;
  final VoidCallback? onBackPressed;

  const ManageCategoryAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textWhite,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.textWhite,
      elevation: 0,
      leading: IconButton(
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        icon: const Icon(
          Icons.chevron_left,
          size: 28,
          color: AppColors.textWhite,
        ),
        tooltip: 'Back',
      ),
      actions: actions?.map((action) => _buildAssetIconAction(action)).toList(),
    );
  }

  Widget _buildAssetIconAction(AssetIconAction action) {
    return IconButton(
      onPressed: action.onPressed,
      icon: SvgPicture.asset(
        action.assetPath,
        width: action.size ?? 24,
        height: action.size ?? 24,
        colorFilter: ColorFilter.mode(
          action.color ?? AppColors.textWhite,
          BlendMode.srcIn,
        ),
      ),
      tooltip: action.tooltip,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
