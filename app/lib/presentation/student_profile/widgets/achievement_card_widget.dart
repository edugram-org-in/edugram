import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AchievementCardWidget extends StatefulWidget {
  final Map<String, dynamic> achievement;
  final VoidCallback? onTap;

  const AchievementCardWidget({
    super.key,
    required this.achievement,
    this.onTap,
  });

  @override
  State<AchievementCardWidget> createState() => _AchievementCardWidgetState();
}

class _AchievementCardWidgetState extends State<AchievementCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation when widget is first viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if ((widget.achievement["isNew"] as bool? ?? false)) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isEarned = widget.achievement["isEarned"] as bool? ?? false;
    final isNew = widget.achievement["isNew"] as bool? ?? false;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: isNew ? _scaleAnimation.value : 1.0,
            child: Transform.rotate(
              angle: isNew ? _rotationAnimation.value * 0.1 : 0.0,
              child: Container(
                width: 25.w,
                height: 30.h,
                margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isEarned
                      ? colorScheme.surface
                      : colorScheme.surface.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isEarned
                        ? AppTheme.primaryLight
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: isEarned ? 2 : 1,
                  ),
                  boxShadow: isEarned
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryLight.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Badge Icon with 3D effect
                    Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isEarned
                            ? LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryLight,
                                  AppTheme.primaryVariantLight,
                                ],
                              )
                            : null,
                        color: isEarned
                            ? null
                            : colorScheme.outline.withValues(alpha: 0.3),
                        boxShadow: isEarned
                            ? [
                                BoxShadow(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.3),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: CustomIconWidget(
                        iconName: widget.achievement["icon"] as String? ??
                            'emoji_events',
                        color: isEarned ? Colors.white : colorScheme.outline,
                        size: 8.w,
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Achievement Title
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        widget.achievement["title"] as String? ?? "Achievement",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: isEarned
                              ? colorScheme.onSurface
                              : colorScheme.onSurface.withValues(alpha: 0.6),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // Achievement Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.w),
                      child: Text(
                        widget.achievement["description"] as String? ??
                            "Complete to unlock",
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isEarned
                              ? colorScheme.onSurface.withValues(alpha: 0.7)
                              : colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),

                    // XP Reward
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isEarned
                            ? AppTheme.primaryLight.withValues(alpha: 0.1)
                            : colorScheme.outline.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIconWidget(
                            iconName: 'stars',
                            color: isEarned
                                ? AppTheme.primaryLight
                                : colorScheme.outline,
                            size: 3.w,
                          ),
                          SizedBox(width: 1.w),
                          Text(
                            "${widget.achievement["xpReward"] ?? 0} XP",
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: isEarned
                                  ? AppTheme.primaryLight
                                  : colorScheme.outline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // New Badge
                    if (isNew && isEarned) ...[
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.errorLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "NEW!",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 8.sp,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
