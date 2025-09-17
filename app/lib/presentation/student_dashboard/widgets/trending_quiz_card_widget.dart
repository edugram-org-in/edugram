import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TrendingQuizCardWidget extends StatefulWidget {
  final Map<String, dynamic> quizData;
  final VoidCallback? onTap;

  const TrendingQuizCardWidget({
    super.key,
    required this.quizData,
    this.onTap,
  });

  @override
  State<TrendingQuizCardWidget> createState() => _TrendingQuizCardWidgetState();
}

class _TrendingQuizCardWidgetState extends State<TrendingQuizCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onTapDown() {
    setState(() => _isPressed = true);
    _hoverController.forward();
  }

  void _onTapUp() {
    setState(() => _isPressed = false);
    _hoverController.reverse();
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green[600]!;
      case 'medium':
        return Colors.orange[600]!;
      case 'hard':
        return Colors.red[600]!;
      default:
        return AppTheme.primaryLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String title = (widget.quizData['title'] as String?) ?? 'Quiz';
    final String subject = (widget.quizData['subject'] as String?) ?? 'Math';
    final String difficulty =
        (widget.quizData['difficulty'] as String?) ?? 'Medium';
    final int questions = (widget.quizData['questions'] as int?) ?? 10;
    final int participants = (widget.quizData['participants'] as int?) ?? 0;
    final double rating = (widget.quizData['rating'] as double?) ?? 4.5;
    final int duration = (widget.quizData['duration'] as int?) ?? 15;
    final String imageUrl = (widget.quizData['imageUrl'] as String?) ?? '';

    final Color difficultyColor = _getDifficultyColor(difficulty);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: widget.onTap,
            onTapDown: (_) => _onTapDown(),
            onTapUp: (_) => _onTapUp(),
            onTapCancel: () => _onTapUp(),
            child: Container(
              width: 70.w,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(4.w),
                boxShadow: [
                  BoxShadow(
                    color: _isPressed
                        ? AppTheme.primaryLight.withValues(alpha: 0.2)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: _isPressed ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: _isPressed
                    ? Border.all(
                        color: AppTheme.primaryLight.withValues(alpha: 0.3),
                        width: 1,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image section
                  Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.w),
                        topRight: Radius.circular(4.w),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppTheme.primaryLight.withValues(alpha: 0.8),
                          AppTheme.primaryLight.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                    child: Stack(
                      children: [
                        if (imageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.w),
                              topRight: Radius.circular(4.w),
                            ),
                            child: CustomImageWidget(
                              imageUrl: imageUrl,
                              width: double.infinity,
                              height: 20.h,
                              fit: BoxFit.cover,
                            ),
                          ),
                        // Overlay gradient
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.w),
                              topRight: Radius.circular(4.w),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.3),
                              ],
                            ),
                          ),
                        ),
                        // Trending badge
                        Positioned(
                          top: 2.w,
                          left: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red[600],
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'trending_up',
                                  color: Colors.white,
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  'TRENDING',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Difficulty badge
                        Positioned(
                          top: 2.w,
                          right: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 1.h,
                            ),
                            decoration: BoxDecoration(
                              color: difficultyColor,
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              difficulty.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 8.sp,
                              ),
                            ),
                          ),
                        ),
                        // Subject badge
                        Positioned(
                          bottom: 2.w,
                          left: 2.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              subject,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Content section
                  Padding(
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'quiz',
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '$questions questions',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                            SizedBox(width: 3.w),
                            CustomIconWidget(
                              iconName: 'schedule',
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '${duration}min',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber[600]!,
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  rating.toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'people',
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$participants',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
