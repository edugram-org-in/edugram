import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DashboardHeaderWidget extends StatefulWidget {
  final String studentName;
  final int currentStreak;
  final int heartsCount;
  final int maxHearts;
  final Duration? heartRegenTime;

  const DashboardHeaderWidget({
    super.key,
    required this.studentName,
    required this.currentStreak,
    required this.heartsCount,
    required this.maxHearts,
    this.heartRegenTime,
  });

  @override
  State<DashboardHeaderWidget> createState() => _DashboardHeaderWidgetState();
}

class _DashboardHeaderWidgetState extends State<DashboardHeaderWidget>
    with TickerProviderStateMixin {
  late AnimationController _streakAnimationController;
  late AnimationController _heartAnimationController;
  late Animation<double> _streakScaleAnimation;
  late Animation<double> _heartPulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _streakAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _heartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _streakScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _streakAnimationController,
      curve: Curves.elasticOut,
    ));

    _heartPulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _heartAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _streakAnimationController.repeat(reverse: true);
    _heartAnimationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _streakAnimationController.dispose();
    _heartAnimationController.dispose();
    super.dispose();
  }

  String _formatRegenTime() {
    if (widget.heartRegenTime == null) return '';
    final minutes = widget.heartRegenTime!.inMinutes;
    final seconds = widget.heartRegenTime!.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary,
            colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // 3D Avatar placeholder
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.7),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: colorScheme.primary,
                  size: 6.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, ${widget.studentName}!',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Ready to learn something new?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              // Streak Counter
              Expanded(
                child: AnimatedBuilder(
                  animation: _streakScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _streakScaleAnimation.value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'local_fire_department',
                              color: Colors.orange[300]!,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Column(
                              children: [
                                Text(
                                  '${widget.currentStreak}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Day Streak',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              // Hearts Counter
              Expanded(
                child: AnimatedBuilder(
                  animation: _heartPulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _heartPulseAnimation.value,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(4.w),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ...List.generate(widget.maxHearts, (index) {
                                  return Padding(
                                    padding: EdgeInsets.only(right: 1.w),
                                    child: CustomIconWidget(
                                      iconName: index < widget.heartsCount
                                          ? 'favorite'
                                          : 'favorite_border',
                                      color: index < widget.heartsCount
                                          ? Colors.red[300]!
                                          : Colors.white.withValues(alpha: 0.5),
                                      size: 4.w,
                                    ),
                                  );
                                }),
                              ],
                            ),
                            if (widget.heartRegenTime != null &&
                                widget.heartsCount < widget.maxHearts) ...[
                              SizedBox(height: 0.5.h),
                              Text(
                                'Next: ${_formatRegenTime()}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 9.sp,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
