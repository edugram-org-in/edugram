import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ClassFilterChipsWidget extends StatefulWidget {
  final int selectedClass;
  final ValueChanged<int>? onClassSelected;
  final bool isVisible;

  const ClassFilterChipsWidget({
    super.key,
    required this.selectedClass,
    this.onClassSelected,
    this.isVisible = false,
  });

  @override
  State<ClassFilterChipsWidget> createState() => _ClassFilterChipsWidgetState();
}

class _ClassFilterChipsWidgetState extends State<ClassFilterChipsWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  final List<int> _classes = [6, 7, 8, 9, 10, 11, 12];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(ClassFilterChipsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _slideAnimation.value * 10.h),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'filter_list',
                        color: AppTheme.primaryLight,
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Filter by Class',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.5.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _classes.map((classNumber) {
                        final bool isSelected =
                            classNumber == widget.selectedClass;
                        return Padding(
                          padding: EdgeInsets.only(right: 2.w),
                          child: _buildClassChip(
                            context,
                            theme,
                            colorScheme,
                            classNumber,
                            isSelected,
                          ),
                        );
                      }).toList(),
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

  Widget _buildClassChip(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
    int classNumber,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        if (widget.onClassSelected != null) {
          widget.onClassSelected!(classNumber);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryLight : colorScheme.surface,
          borderRadius: BorderRadius.circular(6.w),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryLight
                : colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryLight.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              CustomIconWidget(
                iconName: 'school',
                color: Colors.white,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
            ],
            Text(
              'Class $classNumber',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected ? Colors.white : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
            if (isSelected) ...[
              SizedBox(width: 1.w),
              Container(
                width: 2.w,
                height: 2.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
