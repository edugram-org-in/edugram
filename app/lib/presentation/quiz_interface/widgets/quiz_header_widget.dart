import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizHeaderWidget extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final int heartsRemaining;
  final int timeRemaining;
  final VoidCallback onBackPressed;
  final VoidCallback onHintPressed;
  final bool isHintAvailable;

  const QuizHeaderWidget({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.heartsRemaining,
    required this.timeRemaining,
    required this.onBackPressed,
    required this.onHintPressed,
    required this.isHintAvailable,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final progress = currentQuestion / totalQuestions;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: onBackPressed,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'arrow_back_ios',
                      color: colorScheme.onSurface,
                      size: 20,
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question $currentQuestion of $totalQuestions',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryLight.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: progress,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryLight,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                _buildHeartsDisplay(colorScheme),
                SizedBox(width: 3.w),
                _buildTimerDisplay(colorScheme),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: isHintAvailable ? onHintPressed : null,
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: isHintAvailable
                          ? AppTheme.warningLight.withValues(alpha: 0.1)
                          : colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isHintAvailable
                            ? AppTheme.warningLight
                            : colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'lightbulb_outline',
                      color: isHintAvailable
                          ? AppTheme.warningLight
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeartsDisplay(ColorScheme colorScheme) {
    return Row(
      children: [
        CustomIconWidget(
          iconName: 'favorite',
          color: AppTheme.errorLight,
          size: 20,
        ),
        SizedBox(width: 1.w),
        Text(
          '$heartsRemaining',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.errorLight,
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay(ColorScheme colorScheme) {
    final isUrgent = timeRemaining <= 10;
    final timerColor = isUrgent ? AppTheme.errorLight : AppTheme.primaryLight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: timerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: timerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'timer',
            color: timerColor,
            size: 16,
          ),
          SizedBox(width: 1.w),
          Text(
            '${timeRemaining}s',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: timerColor,
            ),
          ),
        ],
      ),
    );
  }
}
