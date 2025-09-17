import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class StudentLoginFormWidget extends StatefulWidget {
  final VoidCallback? onLogin;
  final bool isLoading;

  const StudentLoginFormWidget({
    super.key,
    this.onLogin,
    this.isLoading = false,
  });

  @override
  State<StudentLoginFormWidget> createState() => _StudentLoginFormWidgetState();
}

class _StudentLoginFormWidgetState extends State<StudentLoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _schoolIdController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  String _selectedAuthMethod = 'email';
  String _selectedCountryCode = '+1';
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _schoolIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _calculatePasswordStrength(String password) {
    double strength = 0.0;
    String strengthText = '';

    if (password.isEmpty) {
      strength = 0.0;
      strengthText = '';
    } else if (password.length < 6) {
      strength = 0.25;
      strengthText = 'Weak';
    } else if (password.length < 8) {
      strength = 0.5;
      strengthText = 'Fair';
    } else if (password.length >= 8 &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]'))) {
      strength = 1.0;
      strengthText = 'Strong';
    } else {
      strength = 0.75;
      strengthText = 'Good';
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateSchoolId(String? value) {
    if (value == null || value.isEmpty) {
      return 'School ID is required';
    }
    if (value.length < 4) {
      return 'School ID must be at least 4 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Authentication method selector
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMethodTab('email', 'Email', 'email'),
                ),
                Expanded(
                  child: _buildMethodTab('phone', 'Phone', 'phone'),
                ),
                Expanded(
                  child: _buildMethodTab('school_id', 'School ID', 'badge'),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Input field based on selected method
          _buildInputField(),

          SizedBox(height: 2.h),

          // Password field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            validator: _validatePassword,
            onChanged: _calculatePasswordStrength,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 5.w,
                ),
              ),
              suffixIcon: IconButton(
                icon: CustomIconWidget(
                  iconName:
                      _isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 5.w,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),

          if (_passwordController.text.isNotEmpty) ...[
            SizedBox(height: 1.h),
            _buildPasswordStrengthIndicator(),
          ],

          SizedBox(height: 1.h),

          // Forgot password link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Password reset link sent to your ${_selectedAuthMethod}'),
                    backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                );
              },
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.primaryColor,
                ),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Login button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _handleLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.primaryColor,
                foregroundColor: Colors.white,
                elevation: widget.isLoading ? 0 : 4,
                shadowColor:
                    AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Login',
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),

          SizedBox(height: 3.h),

          // Social login options
          _buildSocialLoginOptions(),
        ],
      ),
    );
  }

  Widget _buildMethodTab(String method, String label, String iconName) {
    final isSelected = _selectedAuthMethod == method;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedAuthMethod = method;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 2.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: isSelected
                  ? Colors.white
                  : AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
              size: 5.w,
            ),
            SizedBox(height: 0.5.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField() {
    switch (_selectedAuthMethod) {
      case 'email':
        return TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: _validateEmail,
          decoration: InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your school email',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'email_outlined',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 5.w,
              ),
            ),
          ),
        );

      case 'phone':
        return Row(
          children: [
            Container(
              width: 20.w,
              child: DropdownButtonFormField<String>(
                value: _selectedCountryCode,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                ),
                items: _countryCodes.map((country) {
                  return DropdownMenuItem<String>(
                    value: country['code'],
                    child: Text(
                      '${country['code']} ${country['country']}',
                      style: GoogleFonts.inter(fontSize: 12.sp),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCountryCode = value!;
                  });
                },
              ),
            ),
            SizedBox(width: 2.w),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: _validatePhone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter 10-digit number',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'phone_outlined',
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.6),
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

      case 'school_id':
        return TextFormField(
          controller: _schoolIdController,
          keyboardType: TextInputType.text,
          validator: _validateSchoolId,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            LengthLimitingTextInputFormatter(12),
          ],
          decoration: InputDecoration(
            labelText: 'School ID',
            hintText: 'Enter your school ID',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'badge_outlined',
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                size: 5.w,
              ),
            ),
          ),
        );

      default:
        return Container();
    }
  }

  Widget _buildPasswordStrengthIndicator() {
    Color strengthColor;
    if (_passwordStrength <= 0.25) {
      strengthColor = AppTheme.lightTheme.colorScheme.error;
    } else if (_passwordStrength <= 0.5) {
      strengthColor = AppTheme.lightTheme.colorScheme.tertiary;
    } else if (_passwordStrength <= 0.75) {
      strengthColor = Colors.orange;
    } else {
      strengthColor = AppTheme.lightTheme.colorScheme.secondary;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: LinearProgressIndicator(
                value: _passwordStrength,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                minHeight: 3,
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              _passwordStrengthText,
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
                color: strengthColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialLoginOptions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'Or continue with',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ),
            Expanded(child: Divider()),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle Google login
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Google login initiated'),
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'g_mobiledata',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                label: Text(
                  'Google',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  // Handle Apple login
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Apple login initiated'),
                      backgroundColor:
                          AppTheme.lightTheme.colorScheme.secondary,
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'apple',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                label: Text(
                  'Apple',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  side: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      // Mock credentials validation
      String correctEmail = 'student@edugram.com';
      String correctPhone = '1234567890';
      String correctSchoolId = 'EDU2024';
      String correctPassword = 'student123';

      bool isValidCredentials = false;
      String errorMessage = '';

      switch (_selectedAuthMethod) {
        case 'email':
          if (_emailController.text == correctEmail &&
              _passwordController.text == correctPassword) {
            isValidCredentials = true;
          } else {
            errorMessage =
                'Invalid email or password. Try: $correctEmail / $correctPassword';
          }
          break;
        case 'phone':
          if (_phoneController.text == correctPhone &&
              _passwordController.text == correctPassword) {
            isValidCredentials = true;
          } else {
            errorMessage =
                'Invalid phone or password. Try: $correctPhone / $correctPassword';
          }
          break;
        case 'school_id':
          if (_schoolIdController.text == correctSchoolId &&
              _passwordController.text == correctPassword) {
            isValidCredentials = true;
          } else {
            errorMessage =
                'Invalid school ID or password. Try: $correctSchoolId / $correctPassword';
          }
          break;
      }

      if (isValidCredentials) {
        HapticFeedback.lightImpact();
        if (widget.onLogin != null) {
          widget.onLogin!();
        }
        Navigator.pushNamed(context, '/student-dashboard');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}