import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class CustomGlowButtonWidget extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const CustomGlowButtonWidget({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  State<CustomGlowButtonWidget> createState() => _CustomGlowButtonWidgetState();
}

class _CustomGlowButtonWidgetState extends State<CustomGlowButtonWidget>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _scaleController;
  late Animation<double> _glowAnimation;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));

    if (widget.isEnabled && !widget.isLoading) {
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(CustomGlowButtonWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEnabled && !widget.isLoading && !_glowController.isAnimating) {
      _glowController.repeat(reverse: true);
    } else if ((!widget.isEnabled || widget.isLoading) &&
        _glowController.isAnimating) {
      _glowController.stop();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() {
        _isPressed = true;
      });
      _scaleController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (widget.isEnabled && !widget.isLoading) {
      setState(() {
        _isPressed = false;
      });
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? AppTheme.lightTheme.primaryColor;
    final textColor = widget.textColor ?? Colors.white;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.isEnabled && !widget.isLoading ? widget.onPressed : null,
      child: AnimatedBuilder(
        animation: Listenable.merge([_glowController, _scaleController]),
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: double.infinity,
              height: 6.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: widget.isEnabled && !widget.isLoading
                    ? [
                        BoxShadow(
                          color: backgroundColor.withValues(
                              alpha: _glowAnimation.value * 0.6),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: backgroundColor.withValues(
                              alpha: _glowAnimation.value * 0.3),
                          blurRadius: 40,
                          spreadRadius: 4,
                          offset: const Offset(0, 8),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: widget.isEnabled && !widget.isLoading
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            backgroundColor,
                            backgroundColor.withValues(alpha: 0.8),
                          ],
                        )
                      : LinearGradient(
                          colors: [
                            backgroundColor.withValues(alpha: 0.5),
                            backgroundColor.withValues(alpha: 0.3),
                          ],
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: widget.isEnabled && !widget.isLoading
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                ),
                child: Center(
                  child: widget.isLoading
                      ? SizedBox(
                          width: 5.w,
                          height: 5.w,
                          child: CircularProgressIndicator(
                            color: textColor,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (widget.icon != null) ...[
                              CustomIconWidget(
                                iconName:
                                    widget.icon.toString().split('.').last,
                                color: textColor,
                                size: 5.w,
                              ),
                              SizedBox(width: 2.w),
                            ],
                            Text(
                              widget.text,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                                shadows: widget.isEnabled && !widget.isLoading
                                    ? [
                                        Shadow(
                                          color: Colors.black
                                              .withValues(alpha: 0.3),
                                          offset: const Offset(0, 1),
                                          blurRadius: 2,
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}