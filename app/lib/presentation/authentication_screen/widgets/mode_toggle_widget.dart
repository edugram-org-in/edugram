import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class ModeToggleWidget extends StatelessWidget {
  final String selectedMode;
  final ValueChanged<String> onModeChanged;

  const ModeToggleWidget({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onModeChanged('student'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selectedMode == 'student'
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: selectedMode == 'student'
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'school',
                        color: selectedMode == 'student'
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Student',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedMode == 'student'
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onModeChanged('admin'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  color: selectedMode == 'admin'
                      ? AppTheme.lightTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: selectedMode == 'admin'
                      ? [
                          BoxShadow(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'admin_panel_settings',
                        color: selectedMode == 'admin'
                            ? Colors.white
                            : AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                        size: 5.w,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Admin',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: selectedMode == 'admin'
                              ? Colors.white
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}