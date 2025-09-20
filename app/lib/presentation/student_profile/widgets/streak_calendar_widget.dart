import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../core/app_export.dart';

class StreakCalendarWidget extends StatefulWidget {
  final List<DateTime> streakDates;
  final List<DateTime> missedDates;
  final int currentStreak;

  const StreakCalendarWidget({
    super.key,
    required this.streakDates,
    required this.missedDates,
    required this.currentStreak,
  });

  @override
  State<StreakCalendarWidget> createState() => _StreakCalendarWidgetState();
}

class _StreakCalendarWidgetState extends State<StreakCalendarWidget> {
  late final ValueNotifier<DateTime> _selectedDay;
  late final ValueNotifier<DateTime> _focusedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = ValueNotifier(DateTime.now());
    _focusedDay = ValueNotifier(DateTime.now());
  }

  @override
  void dispose() {
    _selectedDay.dispose();
    _focusedDay.dispose();
    super.dispose();
  }

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
          // Header with streak info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_fire_department',
                    color: AppTheme.errorLight,
                    size: 6.w,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    "Learning Streak",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.errorLight,
                      AppTheme.warningLight,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'local_fire_department',
                      color: Colors.white,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${widget.currentStreak} days",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Calendar Legend
          _buildCalendarLegend(context, theme, colorScheme),
          SizedBox(height: 2.h),

          // Calendar
          ValueListenableBuilder<DateTime>(
            valueListenable: _focusedDay,
            builder: (context, focusedDay, _) {
              return TableCalendar<DateTime>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                calendarStyle: CalendarStyle(
                  outsideDaysVisible: false,
                  weekendTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ) ?? const TextStyle(),
                  holidayTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ) ?? const TextStyle(),
                  defaultTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ) ?? const TextStyle(),
                  selectedTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ) ?? const TextStyle(),
                  todayTextStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ) ?? const TextStyle(),
                  selectedDecoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: AppTheme.secondaryLight,
                    shape: BoxShape.circle,
                  ),
                  markerDecoration: BoxDecoration(
                    color: AppTheme.errorLight,
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                ),
                headerStyle: HeaderStyle(
                  formatButtonVisible: true,
                  titleCentered: true,
                  formatButtonShowsNext: false,
                  formatButtonDecoration: BoxDecoration(
                    color: AppTheme.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  formatButtonTextStyle: theme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w500,
                  ) ?? const TextStyle(),
                  titleTextStyle: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ) ?? const TextStyle(),
                  leftChevronIcon: CustomIconWidget(
                    iconName: 'chevron_left',
                    color: AppTheme.primaryLight,
                    size: 6.w,
                  ),
                  rightChevronIcon: CustomIconWidget(
                    iconName: 'chevron_right',
                    color: AppTheme.primaryLight,
                    size: 6.w,
                  ),
                ),
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay.value = focusedDay;
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, day, events) {
                    if (_isStreakDay(day)) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: CustomIconWidget(
                          iconName: 'local_fire_department',
                          color: AppTheme.errorLight,
                          size: 4.w,
                        ),
                      );
                    } else if (_isMissedDay(day)) {
                      return Positioned(
                        right: 1,
                        bottom: 1,
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: AppTheme.errorLight.withValues(alpha: 0.3),
                            shape: BoxShape.circle,
                          ),
                          child: CustomIconWidget(
                            iconName: 'close',
                            color: AppTheme.errorLight,
                            size: 2.5.w,
                          ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              );
            },
          ),
          SizedBox(height: 3.h),

          // Streak Statistics
          _buildStreakStats(context, theme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildCalendarLegend(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(
          context,
          "Streak Day",
          AppTheme.errorLight,
          'local_fire_department',
          theme,
        ),
        _buildLegendItem(
          context,
          "Missed Day",
          AppTheme.errorLight.withValues(alpha: 0.3),
          'close',
          theme,
        ),
        _buildLegendItem(
          context,
          "Today",
          AppTheme.secondaryLight,
          'today',
          theme,
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    String label,
    Color color,
    String iconName,
    ThemeData theme,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: Colors.white,
            size: 2.5.w,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakStats(
    BuildContext context,
    ThemeData theme,
    ColorScheme colorScheme,
  ) {
    final totalDays = widget.streakDates.length;
    final missedDays = widget.missedDates.length;
    final completionRate = totalDays > 0
        ? (totalDays / (totalDays + missedDays) * 100).toInt()
        : 0;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.errorLight.withValues(alpha: 0.1),
            AppTheme.warningLight.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatColumn(
              context,
              "Total Days",
              "$totalDays",
              'calendar_today',
              AppTheme.primaryLight,
              theme,
            ),
          ),
          Expanded(
            child: _buildStatColumn(
              context,
              "Best Streak",
              "${widget.currentStreak}",
              'local_fire_department',
              AppTheme.errorLight,
              theme,
            ),
          ),
          Expanded(
            child: _buildStatColumn(
              context,
              "Success Rate",
              "$completionRate%",
              'trending_up',
              AppTheme.successLight,
              theme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    String iconName,
    Color color,
    ThemeData theme,
  ) {
    return Column(
      children: [
        CustomIconWidget(
          iconName: iconName,
          color: color,
          size: 5.w,
        ),
        SizedBox(height: 1.h),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  List<DateTime> _getEventsForDay(DateTime day) {
    return [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay.value, selectedDay)) {
      _selectedDay.value = selectedDay;
      _focusedDay.value = focusedDay;
    }
  }

  bool _isStreakDay(DateTime day) {
    return widget.streakDates.any((streakDay) => isSameDay(streakDay, day));
  }

  bool _isMissedDay(DateTime day) {
    return widget.missedDates.any((missedDay) => isSameDay(missedDay, day));
  }
}