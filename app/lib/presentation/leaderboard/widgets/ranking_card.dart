import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RankingCard extends StatelessWidget {
  final Map<String, dynamic> student;
  final int rank;
  final bool isCurrentUser;
  final bool isTopThree;
  final VoidCallback? onTap;

  const RankingCard({
    super.key,
    required this.student,
    required this.rank,
    this.isCurrentUser = false,
    this.isTopThree = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: isTopThree ? 1.h : 0.5.h,
        ),
        padding: EdgeInsets.all(isTopThree ? 4.w : 3.w),
        decoration: BoxDecoration(
          color: isCurrentUser
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(isTopThree ? 20 : 16),
          border: isCurrentUser
              ? Border.all(color: colorScheme.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow
                  .withValues(alpha: isTopThree ? 0.15 : 0.08),
              blurRadius: isTopThree ? 12 : 8,
              offset: Offset(0, isTopThree ? 4 : 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildRankBadge(context, colorScheme),
            SizedBox(width: 3.w),
            _buildAvatar(context, colorScheme),
            SizedBox(width: 3.w),
            Expanded(
              child: _buildUserInfo(context, colorScheme),
            ),
            _buildStats(context, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildRankBadge(BuildContext context, ColorScheme colorScheme) {
    Color badgeColor;
    IconData? crownIcon;

    switch (rank) {
      case 1:
        badgeColor = const Color(0xFFFFD700); // Gold
        crownIcon = Icons.emoji_events;
        break;
      case 2:
        badgeColor = const Color(0xFFC0C0C0); // Silver
        crownIcon = Icons.emoji_events;
        break;
      case 3:
        badgeColor = const Color(0xFFCD7F32); // Bronze
        crownIcon = Icons.emoji_events;
        break;
      default:
        badgeColor = colorScheme.primary;
    }

    return Container(
      width: isTopThree ? 12.w : 10.w,
      height: isTopThree ? 12.w : 10.w,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        boxShadow: isTopThree
            ? [
                BoxShadow(
                  color: badgeColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: crownIcon != null
            ? CustomIconWidget(
                iconName: 'emoji_events',
                color: Colors.white,
                size: isTopThree ? 24 : 20,
              )
            : Text(
                '$rank',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isTopThree ? 16.sp : 14.sp,
                    ),
              ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: isTopThree ? 16.w : 12.w,
      height: isTopThree ? 16.w : 12.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCurrentUser
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: CustomImageWidget(
          imageUrl: student['avatar'] as String,
          width: isTopThree ? 16.w : 12.w,
          height: isTopThree ? 16.w : 12.w,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                student['name'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: isTopThree ? 16.sp : 14.sp,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isCurrentUser)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'You',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Class ${student['class']} • ${student['school']}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
          overflow: TextOverflow.ellipsis,
        ),
        if (isTopThree) ...[
          SizedBox(height: 1.h),
          _buildAchievementBadges(context, colorScheme),
        ],
      ],
    );
  }

  Widget _buildStats(BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'stars',
              color: const Color(0xFFFFD700),
              size: 16,
            ),
            SizedBox(width: 1.w),
            Text(
              '${student['totalXP']}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                    fontSize: isTopThree ? 16.sp : 14.sp,
                  ),
            ),
          ],
        ),
        SizedBox(height: 0.5.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconWidget(
              iconName: 'local_fire_department',
              color: const Color(0xFFFF4500),
              size: 14,
            ),
            SizedBox(width: 1.w),
            Text(
              '${student['streak']} days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        if (isTopThree) ...[
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: colorScheme.tertiary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+${student['weeklyProgress']} this week',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAchievementBadges(
      BuildContext context, ColorScheme colorScheme) {
    final badges = (student['badges'] as List).take(3).toList();

    return Row(
      children: badges.map<Widget>((badge) {
        return Container(
          margin: EdgeInsets.only(right: 1.w),
          padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.3.h),
          decoration: BoxDecoration(
            color: colorScheme.secondary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            badge as String,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.secondary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      }).toList(),
    );
  }
}
