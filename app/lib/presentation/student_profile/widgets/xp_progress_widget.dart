import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class XpProgressWidget extends StatefulWidget {
  final int currentXP;
  final int currentLevel;
  final int xpForNextLevel;
  final int totalXPForNextLevel;

  const XpProgressWidget({
    super.key,
    required this.currentXP,
    required this.currentLevel,
    required this.xpForNextLevel,
    required this.totalXPForNextLevel,
  });

  @override
  State<XpProgressWidget> createState() => _XpProgressWidgetState();
}

class _XpProgressWidgetState extends State<XpProgressWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    final progress = widget.totalXPForNextLevel > 0
        ? (widget.currentXP % widget.totalXPForNextLevel) /
            widget.totalXPForNextLevel
        : 0.0;

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: progress,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
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

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryLight.withValues(alpha: 0.1),
            AppTheme.accentLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // Level and XP Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Current Level
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryLight,
                      AppTheme.primaryVariantLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryLight.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'military_tech',
                      color: Colors.white,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Level ${widget.currentLevel}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              // Total XP
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.currentXP.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} XP",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryLight,
                    ),
                  ),
                  Text(
                    "Total Experience",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Progress to Level ${widget.currentLevel + 1}",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    "${widget.xpForNextLevel} XP to go",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Animated Progress Bar
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    height: 3.h,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(1.5.h),
                    ),
                    child: Stack(
                      children: [
                        // Progress Fill
                        FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppTheme.primaryLight,
                                  AppTheme.accentLight,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(1.5.h),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryLight
                                      .withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Progress Text
                        Center(
                          child: Text(
                            "${(_progressAnimation.value * 100).toInt()}%",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Level Milestones
          _buildLevelMilestones(context, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLevelMilestones(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final milestones = [
      {
        "level": widget.currentLevel - 1,
        "xp": (widget.currentLevel - 1) * 1000,
        "isCompleted": true,
      },
      {
        "level": widget.currentLevel,
        "xp": widget.currentLevel * 1000,
        "isCompleted": true,
        "isCurrent": true,
      },
      {
        "level": widget.currentLevel + 1,
        "xp": (widget.currentLevel + 1) * 1000,
        "isCompleted": false,
      },
      {
        "level": widget.currentLevel + 2,
        "xp": (widget.currentLevel + 2) * 1000,
        "isCompleted": false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Level Milestones",
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: milestones.asMap().entries.map((entry) {
            final index = entry.key;
            final milestone = entry.value;
            final isCompleted = milestone["isCompleted"] as bool? ?? false;
            final isCurrent = milestone["isCurrent"] as bool? ?? false;
            final level = milestone["level"] as int? ?? 0;
            final xp = milestone["xp"] as int? ?? 0;

            return Expanded(
              child: Column(
                children: [
                  // Milestone Icon
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: isCompleted
                          ? AppTheme.primaryLight
                          : isCurrent
                              ? AppTheme.accentLight
                              : colorScheme.outline.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                      border: isCurrent
                          ? Border.all(
                              color: AppTheme.accentLight,
                              width: 3,
                            )
                          : null,
                      boxShadow: isCompleted || isCurrent
                          ? [
                              BoxShadow(
                                color: (isCompleted
                                        ? AppTheme.primaryLight
                                        : AppTheme.accentLight)
                                    .withValues(alpha: 0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: CustomIconWidget(
                      iconName: isCompleted
                          ? 'check'
                          : isCurrent
                              ? 'star'
                              : 'lock',
                      color: isCompleted || isCurrent
                          ? Colors.white
                          : colorScheme.outline,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(height: 1.h),

                  // Level Number
                  Text(
                    "Lv. $level",
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isCompleted || isCurrent
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),

                  // XP Requirement
                  Text(
                    "${xp.toString().replaceAllMapped(RegExp(r'(\\d{1,3})(?=(\\d{3})+(?!\\d))'), (Match m) => '${m[1]},')} XP",
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isCompleted || isCurrent
                          ? colorScheme.onSurface.withValues(alpha: 0.7)
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
