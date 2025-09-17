import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onStartQuiz;

  const EmptyStateWidget({
    super.key,
    this.onStartQuiz,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.all(6.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'leaderboard',
                color: colorScheme.primary,
                size: 60,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'No Rankings Yet!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 2.h),
          Text(
            'Be the first to climb the leaderboard!\nComplete your first quiz to start earning XP and compete with other students.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onStartQuiz,
              icon: CustomIconWidget(
                iconName: 'quiz',
                color: colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Start Your First Quiz'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.tertiary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'lightbulb',
                  color: colorScheme.tertiary,
                  size: 24,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pro Tip',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              color: colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'Maintain daily streaks to earn bonus XP and climb faster!',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.tertiary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
