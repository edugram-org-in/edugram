import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activities;

  const RecentActivityWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'history',
                    color: AppTheme.primaryLight,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "Recent Activity",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full activity history
                },
                child: Text(
                  "View All",
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Activity List
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length > 5 ? 5 : activities.length,
            separatorBuilder: (context, index) => SizedBox(height: 2.h),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return _buildActivityItem(context, activity, theme, colorScheme);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    BuildContext context,
    Map<String, dynamic> activity,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final activityType = activity["type"] as String? ?? "quiz";
    final title = activity["title"] as String? ?? "Activity";
    final description = activity["description"] as String? ?? "No description";
    final timestamp = activity["timestamp"] as String? ?? "Just now";
    final xpGained = activity["xpGained"] as int? ?? 0;
    final isPositive = activity["isPositive"] as bool? ?? true;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          // Activity Icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: _getActivityColor(activityType, isPositive)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: _getActivityIcon(activityType),
              color: _getActivityColor(activityType, isPositive),
              size: 6.w,
            ),
          ),
          SizedBox(width: 3.w),

          // Activity Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    Text(
                      timestamp,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                    if (xpGained > 0) ...[
                      SizedBox(width: 2.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'add',
                              color: AppTheme.successLight,
                              size: 3.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              "$xpGained XP",
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTheme.successLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // Activity Status Indicator
          Container(
            width: 2.w,
            height: 8.h,
            decoration: BoxDecoration(
              color: _getActivityColor(activityType, isPositive),
              borderRadius: BorderRadius.circular(1.w),
            ),
          ),
        ],
      ),
    );
  }

  Color _getActivityColor(String activityType, bool isPositive) {
    if (!isPositive) return AppTheme.errorLight;

    switch (activityType.toLowerCase()) {
      case 'quiz':
        return AppTheme.primaryLight;
      case 'achievement':
        return AppTheme.accentLight;
      case 'streak':
        return AppTheme.errorLight;
      case 'level_up':
        return AppTheme.successLight;
      case 'badge':
        return AppTheme.warningLight;
      case 'challenge':
        return AppTheme.secondaryLight;
      default:
        return AppTheme.primaryLight;
    }
  }

  String _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'quiz':
        return 'quiz';
      case 'achievement':
        return 'emoji_events';
      case 'streak':
        return 'local_fire_department';
      case 'level_up':
        return 'trending_up';
      case 'badge':
        return 'military_tech';
      case 'challenge':
        return 'flag';
      case 'login':
        return 'login';
      case 'study':
        return 'menu_book';
      default:
        return 'notifications';
    }
  }
}
