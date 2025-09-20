import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/animated_mascot_widget.dart';
import './widgets/avatar_selection_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';

class StudentRegistration extends StatefulWidget {
  const StudentRegistration({super.key});

  @override
  State<StudentRegistration> createState() => _StudentRegistrationState();
}

class _StudentRegistrationState extends State<StudentRegistration>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _successAnimationController;
  late Animation<double> _successAnimation;

  Map<String, dynamic> _formData = {};
  XFile? _profileImage;
  double _formProgress = 0.0;
  bool _isFormValid = false;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  void _onFormChanged(Map<String, dynamic> formData) {
    setState(() {
      _formData = formData;
      _formProgress = _calculateProgress(formData);
      _isFormValid = _validateForm(formData);
    });
  }

  double _calculateProgress(Map<String, dynamic> formData) {
    double progress = 0.0;

    if (formData['name']?.isNotEmpty == true) progress += 0.2;
    if (formData['school']?.isNotEmpty == true) progress += 0.2;
    if (formData['class'] != null) progress += 0.2;
    if (formData['email']?.isNotEmpty == true) progress += 0.2;
    if (formData['phone']?.isNotEmpty == true) progress += 0.1;
    if (formData['termsAccepted'] == true) progress += 0.1;

    return progress.clamp(0.0, 1.0);
  }

  bool _validateForm(Map<String, dynamic> formData) {
    return formData['name']?.isNotEmpty == true &&
        formData['school']?.isNotEmpty == true &&
        formData['class'] != null &&
        formData['email']?.isNotEmpty == true &&
        formData['phone']?.isNotEmpty == true &&
        formData['termsAccepted'] == true;
  }

  String _getCurrentStep() {
    if (_formProgress < 0.2) return 'Personal Information';
    if (_formProgress < 0.4) return 'School Details';
    if (_formProgress < 0.6) return 'Class Selection';
    if (_formProgress < 0.8) return 'Contact Information';
    if (_formProgress < 1.0) return 'Final Details';
    return 'Registration Complete';
  }

  void _onImageSelected(XFile? image) {
    setState(() {
      _profileImage = image;
    });
  }

  Future<void> _submitRegistration() async {
    if (!_isFormValid) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Show success animation
      await _successAnimationController.forward();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/student-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            ProgressIndicatorWidget(
              progress: _formProgress,
              currentStep: _getCurrentStep(),
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    AnimatedMascotWidget(
                      formProgress: _formProgress,
                      currentField: _getCurrentStep(),
                    ),
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow
                                .withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CustomIconWidget(
                                iconName: 'school',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 32,
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Join Edugram',
                                      style: AppTheme
                                          .lightTheme.textTheme.headlineSmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppTheme
                                            .lightTheme.colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      'Start your gamified learning adventure',
                                      style: AppTheme
                                          .lightTheme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppTheme
                                            .lightTheme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          AvatarSelectionWidget(
                            onImageSelected: _onImageSelected,
                          ),
                          SizedBox(height: 4.h),
                          RegistrationFormWidget(
                            onFormChanged: _onFormChanged,
                            onSubmit: _submitRegistration,
                            isFormValid: _isFormValid,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'info',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              'Your data is secure and will only be used to personalize your learning experience.',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _formProgress > 0.5
          ? FloatingActionButton.extended(
              onPressed: _isFormValid ? _submitRegistration : null,
              backgroundColor: _isFormValid
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.3),
              icon: _isSubmitting
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : CustomIconWidget(
                      iconName: 'rocket_launch',
                      color: Colors.white,
                      size: 20,
                    ),
              label: Text(
                _isSubmitting ? 'Creating...' : 'Start Learning',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}
