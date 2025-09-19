import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PodiumWidget extends StatelessWidget {
  final List<Map<String, dynamic>> topThree;
  final Function(Map<String, dynamic>) onUserTap;

  const PodiumWidget({
    super.key,
    required this.topThree,
    required this.onUserTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (topThree.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 35.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Stack(
        children: [
          _buildPodiumBase(context, colorScheme),
          _buildPodiumUsers(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPodiumBase(BuildContext context, ColorScheme colorScheme) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Second place podium
          if (topThree.length > 1)
            Expanded(
              child: Container(
                height: 15.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFC0C0C0), Color(0xFF999999)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '2',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.sp,
                        ),
                  ),
                ),
              ),
            ),

          // First place podium
          Expanded(
            child: Container(
              height: 20.h,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFD700), Color(0xFFDAA520)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'emoji_events',
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      '1',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.sp,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Third place podium
          if (topThree.length > 2)
            Expanded(
              child: Container(
                height: 12.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFCD7F32), Color(0xFFA0522D)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    '3',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp,
                        ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPodiumUsers(BuildContext context, ColorScheme colorScheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Second place user
        if (topThree.length > 1)
          Expanded(
            child: _buildPodiumUser(
              context,
              colorScheme,
              topThree[1],
              2,
              18.h,
            ),
          ),

        // First place user
        Expanded(
          child: _buildPodiumUser(
            context,
            colorScheme,
            topThree[0],
            1,
            15.h,
          ),
        ),

        // Third place user
        if (topThree.length > 2)
          Expanded(
            child: _buildPodiumUser(
              context,
              colorScheme,
              topThree[2],
              3,
              20.h,
            ),
          ),
      ],
    );
  }

  Widget _buildPodiumUser(
    BuildContext context,
    ColorScheme colorScheme,
    Map<String, dynamic> user,
    int position,
    double bottomOffset,
  ) {
    final isFirst = position == 1;

    return Positioned(
      bottom: bottomOffset,
      child: GestureDetector(
        onTap: () => onUserTap(user),
        child: Column(
          children: [
            // Crown for first place
            if (isFirst) ...[
              CustomIconWidget(
                iconName: 'workspace_premium',
                color: const Color(0xFFFFD700),
                size: 32,
              ),
              SizedBox(height: 1.h),
            ],

            // Avatar with glow effect
            Container(
              width: isFirst ? 20.w : 16.w,
              height: isFirst ? 20.w : 16.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isFirst
                      ? const Color(0xFFFFD700)
                      : position == 2
                          ? const Color(0xFFC0C0C0)
                          : const Color(0xFFCD7F32),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (isFirst
                            ? const Color(0xFFFFD700)
                            : position == 2
                                ? const Color(0xFFC0C0C0)
                                : const Color(0xFFCD7F32))
                        .withValues(alpha: 0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: CustomImageWidget(
                  imageUrl: user['avatar'] as String,
                  width: isFirst ? 20.w : 16.w,
                  height: isFirst ? 20.w : 16.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 1.h),

            // User name
            Container(
              constraints: BoxConstraints(maxWidth: 25.w),
              child: Text(
                user['name'] as String,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: isFirst ? 14.sp : 12.sp,
                    ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),

            SizedBox(height: 0.5.h),

            // XP Score
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: 'stars',
                    color: const Color(0xFFFFD700),
                    size: 14,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${user['totalXP']}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
