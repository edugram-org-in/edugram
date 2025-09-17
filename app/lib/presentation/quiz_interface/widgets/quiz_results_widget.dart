import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuizResultsWidget extends StatefulWidget {
  final int score;
  final int totalQuestions;
  final int xpEarned;
  final int heartsRemaining;
  final bool streakMaintained;
  final List<String> badgesUnlocked;
  final VoidCallback onRetakeQuiz;
  final VoidCallback onBackToDashboard;
  final VoidCallback onShareResults;

  const QuizResultsWidget({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.heartsRemaining,
    required this.streakMaintained,
    required this.badgesUnlocked,
    required this.onRetakeQuiz,
    required this.onBackToDashboard,
    required this.onShareResults,
  });

  @override
  State<QuizResultsWidget> createState() => _QuizResultsWidgetState();
}

class _QuizResultsWidgetState extends State<QuizResultsWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _scoreController;
  late AnimationController _badgeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scoreAnimation;
  late Animation<double> _badgeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scoreController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _badgeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutBack,
    ));

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: widget.score.toDouble(),
    ).animate(CurvedAnimation(
      parent: _scoreController,
      curve: Curves.easeOutQuart,
    ));

    _badgeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _badgeController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _slideController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _scoreController.forward();
      }
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted && widget.badgesUnlocked.isNotEmpty) {
        _badgeController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _scoreController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  double get scorePercentage => (widget.score / widget.totalQuestions) * 100;

  String get performanceMessage {
    if (scorePercentage >= 90) return 'Outstanding! 🌟';
    if (scorePercentage >= 80) return 'Excellent work! 🎉';
    if (scorePercentage >= 70) return 'Great job! 👏';
    if (scorePercentage >= 60) return 'Good effort! 👍';
    return 'Keep practicing! 💪';
  }

  Color get performanceColor {
    if (scorePercentage >= 80) return AppTheme.successLight;
    if (scorePercentage >= 60) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: double.infinity,
        height: 100.h,
        color: colorScheme.surface,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Column(
              children: [
                SizedBox(height: 2.h),
                _buildHeader(theme, colorScheme),
                SizedBox(height: 4.h),
                _buildScoreDisplay(theme, colorScheme),
                SizedBox(height: 4.h),
                _buildStatsGrid(theme, colorScheme),
                if (widget.badgesUnlocked.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  _buildBadgesSection(theme, colorScheme),
                ],
                SizedBox(height: 6.h),
                _buildActionButtons(theme, colorScheme),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: performanceColor.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: scorePercentage >= 80 ? 'emoji_events' : 'school',
            color: performanceColor,
            size: 48,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'Quiz Complete!',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          performanceMessage,
          style: theme.textTheme.titleMedium?.copyWith(
            color: performanceColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildScoreDisplay(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryLight.withValues(alpha: 0.1),
                AppTheme.secondaryLight.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppTheme.primaryLight.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            children: [
              Text(
                'Your Score',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '${_scoreAnimation.value.toInt()}',
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: AppTheme.primaryLight,
                      fontWeight: FontWeight.w800,
                      fontSize: 48.sp,
                    ),
                  ),
                  Text(
                    '/${widget.totalQuestions}',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Text(
                '${(_scoreAnimation.value / widget.totalQuestions * 100).toInt()}%',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: performanceColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(ThemeData theme, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            colorScheme,
            'XP Earned',
            '+${widget.xpEarned}',
            'stars',
            AppTheme.warningLight,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            theme,
            colorScheme,
            'Hearts Left',
            '${widget.heartsRemaining}',
            'favorite',
            AppTheme.errorLight,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatCard(
            theme,
            colorScheme,
            'Streak',
            widget.streakMaintained ? 'Kept!' : 'Lost',
            'local_fire_department',
            widget.streakMaintained
                ? AppTheme.successLight
                : AppTheme.errorLight,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    ColorScheme colorScheme,
    String title,
    String value,
    String iconName,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 24,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesSection(ThemeData theme, ColorScheme colorScheme) {
    return AnimatedBuilder(
      animation: _badgeAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _badgeAnimation.value,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.accentLight.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentLight.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'military_tech',
                      color: AppTheme.accentLight,
                      size: 24,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'New Badges Unlocked!',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.accentLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: widget.badgesUnlocked.map((badge) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      decoration: BoxDecoration(
                        color: AppTheme.accentLight.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badge,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.accentLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: widget.onBackToDashboard,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Text(
              'Back to Dashboard',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: widget.onRetakeQuiz,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryLight,
                  side: BorderSide(color: AppTheme.primaryLight),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Retake Quiz',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: widget.onShareResults,
                icon: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.secondaryLight,
                  size: 20,
                ),
                label: Text(
                  'Share',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.secondaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.secondaryLight,
                  side: BorderSide(color: AppTheme.secondaryLight),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
