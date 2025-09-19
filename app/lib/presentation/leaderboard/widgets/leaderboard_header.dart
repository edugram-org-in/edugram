import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LeaderboardHeader extends StatelessWidget {
  final String selectedClass;
  final String selectedSubject;
  final String selectedPeriod;
  final Function(String) onClassChanged;
  final Function(String) onSubjectChanged;
  final Function(String) onPeriodChanged;

  const LeaderboardHeader({
    super.key,
    required this.selectedClass,
    required this.selectedSubject,
    required this.selectedPeriod,
    required this.onClassChanged,
    required this.onSubjectChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
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
          Text(
            'Leaderboard',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 2.h),
          _buildFilterChips(context, colorScheme),
          SizedBox(height: 1.h),
          _buildTimePeriodSelector(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(
            context,
            colorScheme,
            'Class',
            selectedClass,
            ['All', '6', '7', '8', '9', '10', '11', '12'],
            onClassChanged,
          ),
          SizedBox(width: 2.w),
          _buildFilterChip(
            context,
            colorScheme,
            'Subject',
            selectedSubject,
            ['All', 'Math', 'Physics', 'Chemistry', 'Biology'],
            onSubjectChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    ColorScheme colorScheme,
    String label,
    String selectedValue,
    List<String> options,
    Function(String) onChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: PopupMenuButton<String>(
        onSelected: onChanged,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$label: $selectedValue',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              SizedBox(width: 1.w),
              CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                color: colorScheme.primary,
                size: 18,
              ),
            ],
          ),
        ),
        itemBuilder: (context) => options.map((option) {
          return PopupMenuItem<String>(
            value: option,
            child: Text(option),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTimePeriodSelector(
      BuildContext context, ColorScheme colorScheme) {
    final periods = ['Daily', 'Weekly', 'Monthly', 'All-time'];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: periods.asMap().entries.map((entry) {
          final index = entry.key;
          final period = entry.value;
          final isSelected = period == selectedPeriod;
          final isFirst = index == 0;
          final isLast = index == periods.length - 1;

          return Expanded(
            child: GestureDetector(
              onTap: () => onPeriodChanged(period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  borderRadius: BorderRadius.only(
                    topLeft: isFirst ? const Radius.circular(11) : Radius.zero,
                    bottomLeft:
                        isFirst ? const Radius.circular(11) : Radius.zero,
                    topRight: isLast ? const Radius.circular(11) : Radius.zero,
                    bottomRight:
                        isLast ? const Radius.circular(11) : Radius.zero,
                  ),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
