import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizResultCardWidget extends StatefulWidget {
  final Map<String, dynamic> quizResult;
  final VoidCallback? onTap;

  const QuizResultCardWidget({
    super.key,
    required this.quizResult,
    this.onTap,
  });

  @override
  State<QuizResultCardWidget> createState() => _QuizResultCardWidgetState();
}

class _QuizResultCardWidgetState extends State<QuizResultCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _xpAnimationController;
  late Animation<double> _xpScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _xpAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _xpScaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _xpAnimationController,
      curve: Curves.elasticOut,
    ));

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _xpAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _xpAnimationController.dispose();
    super.dispose();
  }

  Color _getScoreColor(double scorePercentage) {
    if (scorePercentage >= 0.8) {
      return Colors.green[600]!;
    } else if (scorePercentage >= 0.6) {
      return Colors.orange[600]!;
    } else {
      return Colors.red[600]!;
    }
  }

  String _getScoreGrade(double scorePercentage) {
    if (scorePercentage >= 0.9) {
      return 'A+';
    } else if (scorePercentage >= 0.8) {
      return 'A';
    } else if (scorePercentage >= 0.7) {
      return 'B';
    } else if (scorePercentage >= 0.6) {
      return 'C';
    } else {
      return 'D';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String quizTitle = (widget.quizResult['title'] as String?) ?? 'Quiz';
    final String subject = (widget.quizResult['subject'] as String?) ?? 'Math';
    final int score = (widget.quizResult['score'] as int?) ?? 0;
    final int totalQuestions =
        (widget.quizResult['totalQuestions'] as int?) ?? 10;
    final int xpGained = (widget.quizResult['xpGained'] as int?) ?? 0;
    final int coinsGained = (widget.quizResult['coinsGained'] as int?) ?? 0;
    final DateTime completedAt =
        widget.quizResult['completedAt'] as DateTime? ?? DateTime.now();
    final String difficulty =
        (widget.quizResult['difficulty'] as String?) ?? 'Medium';

    final double scorePercentage =
        totalQuestions > 0 ? score / totalQuestions : 0.0;
    final Color scoreColor = _getScoreColor(scorePercentage);
    final String grade = _getScoreGrade(scorePercentage);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: scoreColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quizTitle,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  AppTheme.primaryLight.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              subject,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 2.w,
                              vertical: 0.5.h,
                            ),
                            decoration: BoxDecoration(
                              color: scoreColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(2.w),
                            ),
                            child: Text(
                              difficulty,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scoreColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 15.w,
                  height: 15.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        scoreColor,
                        scoreColor.withValues(alpha: 0.7),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: scoreColor.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      grade,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Score',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '$score/$totalQuestions',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Accuracy',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${(scorePercentage * 100).toInt()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: scoreColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Completed',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '${completedAt.day}/${completedAt.month}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: Row(
                children: [
                  AnimatedBuilder(
                    animation: _xpScaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _xpScaleAnimation.value,
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'stars',
                              color: Colors.yellow[600]!,
                              size: 4.w,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              '+$xpGained XP',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryLight,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 4.w),
                  CustomIconWidget(
                    iconName: 'monetization_on',
                    color: Colors.amber[600]!,
                    size: 4.w,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '+$coinsGained coins',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  CustomIconWidget(
                    iconName: 'arrow_forward_ios',
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                    size: 4.w,
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
