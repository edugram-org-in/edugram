import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  centered,
  minimal,
  withActions,
  withSearch,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final String? searchHint;

  const CustomAppBar({
    super.key,
    this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.showBackButton = false,
    this.onBackPressed,
    this.searchController,
    this.onSearchChanged,
    this.searchHint = 'Search...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (variant) {
      case CustomAppBarVariant.standard:
        return _buildStandardAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.centered:
        return _buildCenteredAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.minimal:
        return _buildMinimalAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.withActions:
        return _buildWithActionsAppBar(context, theme, colorScheme);
      case CustomAppBarVariant.withSearch:
        return _buildWithSearchAppBar(context, theme, colorScheme);
    }
  }

  Widget _buildStandardAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? colorScheme.onSurface,
              ),
            )
          : null,
      leading: _buildLeading(context, colorScheme),
      actions: _buildActions(context, colorScheme),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
    );
  }

  Widget _buildCenteredAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? colorScheme.onSurface,
              ),
            )
          : null,
      leading: _buildLeading(context, colorScheme),
      actions: _buildActions(context, colorScheme),
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
    );
  }

  Widget _buildMinimalAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: foregroundColor ?? colorScheme.onSurface,
              ),
            )
          : null,
      leading: _buildLeading(context, colorScheme),
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 0.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
    );
  }

  Widget _buildWithActionsAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? colorScheme.onSurface,
              ),
            )
          : null,
      leading: _buildLeading(context, colorScheme),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
          color: colorScheme.primary,
        ),
        IconButton(
          icon: Icon(Icons.person_outline),
          onPressed: () {
            Navigator.pushNamed(context, '/student-profile');
          },
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
        ..._buildActions(context, colorScheme),
      ],
      backgroundColor: backgroundColor ?? colorScheme.surface,
      foregroundColor: foregroundColor ?? colorScheme.onSurface,
      elevation: elevation ?? 1.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
    );
  }

  Widget _buildWithSearchAppBar(
      BuildContext context, ThemeData theme, ColorScheme colorScheme) {
    return AppBar(
      title: Container(
        height: 40,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colorScheme.outline.withAlpha(77),
          ),
        ),
        child: TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(153),
            ),
            prefixIcon: Icon(
              Icons.search,
              color: colorScheme.onSurface.withAlpha(153),
              size: 20,
            ),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
        ),
      ),
      leading: _buildLeading(context, colorScheme),
      actions: [
        IconButton(
          icon: Icon(Icons.filter_list),
          onPressed: () {
            // Handle filter
          },
          color: colorScheme.primary,
        ),
        const SizedBox(width: 8),
      ],
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: foregroundColor ?? colorScheme.onPrimary,
      elevation: elevation ?? 2.0,
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: false,
    );
  }

  Widget? _buildLeading(BuildContext context, ColorScheme colorScheme) {
    if (leading != null) return leading;

    if (showBackButton ||
        (automaticallyImplyLeading && Navigator.canPop(context))) {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.pop(context),
        color: foregroundColor ?? colorScheme.onSurface,
      );
    }

    return null;
  }

  List<Widget> _buildActions(BuildContext context, ColorScheme colorScheme) {
    if (actions != null) return actions!;
    return [];
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
