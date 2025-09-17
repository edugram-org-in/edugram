import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SubjectCardWidget extends StatefulWidget {
  final Map<String, dynamic> subjectData;
  final VoidCallback? onTap;

  const SubjectCardWidget({
    super.key,
    required this.subjectData,
    this.onTap,
  });

  @override
  State<SubjectCardWidget> createState() => _SubjectCardWidgetState();
}

class _SubjectCardWidgetState extends State<SubjectCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverAnimationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _hoverAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _hoverAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _hoverAnimationController.dispose();
    super.dispose();
  }

  void _onHoverStart() {
    setState(() => _isHovered = true);
    _hoverAnimationController.forward();
  }

  void _onHoverEnd() {
    setState(() => _isHovered = false);
    _hoverAnimationController.reverse();
  }

  Color _getSubjectColor(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return Colors.blue[600]!;
      case 'science':
        return Colors.green[600]!;
      case 'technology':
        return Colors.purple[600]!;
      case 'engineering':
        return Colors.orange[600]!;
      default:
        return AppTheme.primaryLight;
    }
  }

  IconData _getSubjectIcon(String subject) {
    switch (subject.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return Icons.calculate;
      case 'science':
        return Icons.science;
      case 'technology':
        return Icons.computer;
      case 'engineering':
        return Icons.engineering;
      default:
        return Icons.school;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String name = (widget.subjectData['name'] as String?) ?? 'Subject';
    final String description = (widget.subjectData['description'] as String?) ??
        'Learn more about this subject';
    final double progress = (widget.subjectData['progress'] as double?) ?? 0.0;
    final int totalQuizzes = (widget.subjectData['totalQuizzes'] as int?) ?? 0;
    final int completedQuizzes =
        (widget.subjectData['completedQuizzes'] as int?) ?? 0;
    final bool isLocked = (widget.subjectData['isLocked'] as bool?) ?? false;

    final Color subjectColor = _getSubjectColor(name);
    final IconData subjectIcon = _getSubjectIcon(name);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTap: isLocked ? null : widget.onTap,
            onTapDown: (_) => _onHoverStart(),
            onTapUp: (_) => _onHoverEnd(),
            onTapCancel: () => _onHoverEnd(),
            child: Container(
              width: 40.w,
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(4.w),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? subjectColor.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: 0.1),
                    blurRadius: _isHovered ? 12 : 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: _isHovered
                    ? Border.all(
                        color: subjectColor.withValues(alpha: 0.5),
                        width: 2,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          subjectColor.withValues(alpha: 0.1),
                          subjectColor.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4.w),
                    ),
                  ),
                  // Lock overlay
                  if (isLocked)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                    ),
                  // Content
                  Padding(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                color: subjectColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(2.w),
                              ),
                              child: Icon(
                                subjectIcon,
                                color: subjectColor,
                                size: 6.w,
                              ),
                            ),
                            const Spacer(),
                            if (isLocked)
                              CustomIconWidget(
                                iconName: 'lock',
                                color: Colors.white,
                                size: 5.w,
                              ),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color:
                                isLocked ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isLocked
                                ? Colors.white.withValues(alpha: 0.8)
                                : colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        if (!isLocked) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              Text(
                                '${(progress * 100).toInt()}%',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: subjectColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Stack(
                            children: [
                              Container(
                                height: 1.h,
                                decoration: BoxDecoration(
                                  color: subjectColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(0.5.h),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  height: 1.h,
                                  decoration: BoxDecoration(
                                    color: subjectColor,
                                    borderRadius: BorderRadius.circular(0.5.h),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            '$completedQuizzes/$totalQuizzes quizzes',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ] else ...[
                          Center(
                            child: Column(
                              children: [
                                CustomIconWidget(
                                  iconName: 'lock_outline',
                                  color: Colors.white.withValues(alpha: 0.8),
                                  size: 8.w,
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Complete previous\nsubjects to unlock',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
