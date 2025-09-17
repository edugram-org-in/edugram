import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnimatedMascotWidget extends StatefulWidget {
  final double formProgress;
  final String currentField;

  const AnimatedMascotWidget({
    super.key,
    required this.formProgress,
    required this.currentField,
  });

  @override
  State<AnimatedMascotWidget> createState() => _AnimatedMascotWidgetState();
}

class _AnimatedMascotWidgetState extends State<AnimatedMascotWidget>
    with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _glowController;
  late Animation<double> _bounceAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticInOut,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _bounceController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _bounceController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  String _getMascotMessage() {
    if (widget.formProgress < 0.2) {
      return "Hi there! Let's get you started on your learning journey! 🚀";
    } else if (widget.formProgress < 0.4) {
      return "Great job! You're making excellent progress! 📚";
    } else if (widget.formProgress < 0.6) {
      return "Awesome! We're halfway there! Keep going! 💪";
    } else if (widget.formProgress < 0.8) {
      return "Almost done! You're doing fantastic! ⭐";
    } else if (widget.formProgress < 1.0) {
      return "So close! Just a few more details! 🎯";
    } else {
      return "Perfect! Welcome to the Edugram family! 🎉";
    }
  }

  String _getMascotExpression() {
    if (widget.formProgress < 0.3) {
      return "😊";
    } else if (widget.formProgress < 0.6) {
      return "😄";
    } else if (widget.formProgress < 0.9) {
      return "🤩";
    } else {
      return "🎉";
    }
  }

  Color _getMascotColor() {
    if (widget.formProgress < 0.3) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (widget.formProgress < 0.6) {
      return AppTheme.lightTheme.colorScheme.primary;
    } else if (widget.formProgress < 0.9) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getMascotColor().withValues(alpha: 0.1),
            _getMascotColor().withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getMascotColor().withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_bounceAnimation, _glowAnimation]),
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, -_bounceAnimation.value),
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: _getMascotColor(),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _getMascotColor()
                            .withValues(alpha: _glowAnimation.value * 0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _getMascotExpression(),
                      style: TextStyle(fontSize: 8.w),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.lightTheme.colorScheme.shadow
                            .withValues(alpha: 0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    _getMascotMessage(),
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'XP: ${(widget.formProgress * 100).toInt()}',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Streak: 1',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
