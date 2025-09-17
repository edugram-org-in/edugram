import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnswerOptionsWidget extends StatefulWidget {
  final List<String> options;
  final int? selectedIndex;
  final int? correctIndex;
  final bool showResults;
  final Function(int) onOptionSelected;

  const AnswerOptionsWidget({
    super.key,
    required this.options,
    this.selectedIndex,
    this.correctIndex,
    this.showResults = false,
    required this.onOptionSelected,
  });

  @override
  State<AnswerOptionsWidget> createState() => _AnswerOptionsWidgetState();
}

class _AnswerOptionsWidgetState extends State<AnswerOptionsWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _scaleAnimations;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = List.generate(
      widget.options.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );

    _scaleAnimations = _animationControllers
        .map((controller) => Tween<double>(begin: 1.0, end: 0.95).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeInOut)))
        .toList();

    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 10).animate(
        CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn));
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  void _onOptionTap(int index) {
    _animationControllers[index].forward().then((_) {
      _animationControllers[index].reverse();
    });

    widget.onOptionSelected(index);

    if (widget.showResults &&
        widget.correctIndex != null &&
        index != widget.correctIndex) {
      _shakeController.forward().then((_) {
        _shakeController.reset();
      });
    }
  }

  Color _getOptionColor(int index, ColorScheme colorScheme) {
    if (!widget.showResults) {
      return widget.selectedIndex == index
          ? AppTheme.primaryLight.withValues(alpha: 0.1)
          : colorScheme.surface;
    }

    if (index == widget.correctIndex) {
      return AppTheme.successLight.withValues(alpha: 0.1);
    } else if (index == widget.selectedIndex && index != widget.correctIndex) {
      return AppTheme.errorLight.withValues(alpha: 0.1);
    }

    return colorScheme.surface.withValues(alpha: 0.5);
  }

  Color _getOptionBorderColor(int index, ColorScheme colorScheme) {
    if (!widget.showResults) {
      return widget.selectedIndex == index
          ? AppTheme.primaryLight
          : colorScheme.outline.withValues(alpha: 0.3);
    }

    if (index == widget.correctIndex) {
      return AppTheme.successLight;
    } else if (index == widget.selectedIndex && index != widget.correctIndex) {
      return AppTheme.errorLight;
    }

    return colorScheme.outline.withValues(alpha: 0.2);
  }

  Widget _getOptionIcon(int index) {
    if (!widget.showResults) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.selectedIndex == index
                ? AppTheme.primaryLight
                : Colors.grey.withValues(alpha: 0.5),
            width: 2,
          ),
          color: widget.selectedIndex == index
              ? AppTheme.primaryLight
              : Colors.transparent,
        ),
        child: widget.selectedIndex == index
            ? CustomIconWidget(
                iconName: 'check',
                color: Colors.white,
                size: 16,
              )
            : null,
      );
    }

    if (index == widget.correctIndex) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.successLight,
        ),
        child: CustomIconWidget(
          iconName: 'check',
          color: Colors.white,
          size: 16,
        ),
      );
    } else if (index == widget.selectedIndex && index != widget.correctIndex) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.errorLight,
        ),
        child: CustomIconWidget(
          iconName: 'close',
          color: Colors.white,
          size: 16,
        ),
      );
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: widget.options.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          return AnimatedBuilder(
            animation:
                Listenable.merge([_scaleAnimations[index], _shakeAnimation]),
            builder: (context, child) {
              return Transform.translate(
                offset: widget.selectedIndex == index &&
                        widget.showResults &&
                        index != widget.correctIndex
                    ? Offset(
                        _shakeAnimation.value * (index % 2 == 0 ? 1 : -1), 0)
                    : Offset.zero,
                child: Transform.scale(
                  scale: _scaleAnimations[index].value,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 2.h),
                    child: GestureDetector(
                      onTap:
                          widget.showResults ? null : () => _onOptionTap(index),
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: _getOptionColor(index, colorScheme),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: _getOptionBorderColor(index, colorScheme),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.shadow.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            _getOptionIcon(index),
                            SizedBox(width: 4.w),
                            Expanded(
                              child: Text(
                                option,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
