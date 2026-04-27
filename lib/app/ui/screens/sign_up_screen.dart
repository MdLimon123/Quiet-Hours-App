import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late final AuthController _authController;
  late final FocusNode _nameFocus;
  late final FocusNode _emailFocus;
  late final FocusNode _passwordFocus;
  late final FocusNode _confirmPasswordFocus;

  @override
  void initState() {
    super.initState();
    _authController = Get.put(AuthController());
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24),
          child: Column(
            children: [
        
        
              // // Header Section with gradient
              Container(
                height: screenHeight * 0.22,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF1A5F7A),
                      Color(0xFF0D3D52),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_add,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Create Account',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Join the Quiet Hours community',
                      style: GoogleFonts.hindSiliguri(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
        
        
        
              // Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full Name Field
                    _buildLabel('Full Name'),
                    const SizedBox(height: 8),
                    _buildNameField(),
                    const SizedBox(height: 20),
        
                    // Email Field
                    _buildLabel('Email Address'),
                    const SizedBox(height: 8),
                    _buildEmailField(),
                    const SizedBox(height: 20),
        
                    // Password Field
                    _buildLabel('Password'),
                    const SizedBox(height: 8),
                    _buildPasswordField(),
                    const SizedBox(height: 8),
                    _buildPasswordStrengthIndicator(),
                    const SizedBox(height: 20),
        
                    // Confirm Password Field
                    _buildLabel('Confirm Password'),
                    const SizedBox(height: 8),
                    _buildConfirmPasswordField(),
                    const SizedBox(height: 20),
        
                    // Password Requirements
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A5F7A).withOpacity(0.05),
                        border: Border.all(
                          color: const Color(0xFF1A5F7A).withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Password Requirements:',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A5F7A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildRequirement('At least 6 characters'),
                          _buildRequirement('One uppercase letter'),
                          _buildRequirement('One lowercase letter'),
                          _buildRequirement('One number'),
                          _buildRequirement('One special character (!@#\$%^&*)'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
        
                    // Error Message
                    Obx(
                      () => _authController.errorMessage.value.isNotEmpty
                          ? Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _authController.errorMessage.value,
                                      style: GoogleFonts.hindSiliguri(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    const SizedBox(height: 24),
        
                    // Sign Up Button
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () => _authController.signUp(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A5F7A),
                            disabledBackgroundColor:
                                const Color(0xFF1A5F7A).withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 3,
                            shadowColor: const Color(0xFF1A5F7A).withOpacity(0.4),
                          ),
                          child: _authController.isLoading.value
                              ? SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                )
                              : Text(
                                  'Create Account',
                                  style: GoogleFonts.hindSiliguri(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
        
                    // Divider
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or',
                            style: GoogleFonts.hindSiliguri(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey.withOpacity(0.3),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
        
                    // Sign In Link
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                            TextSpan(
                              text: 'Sign In',
                              style: GoogleFonts.hindSiliguri(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A5F7A),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.back(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
        
                    // Terms and Conditions
                    Center(
                      child: Text(
                        'By signing up, you agree to our Terms & Conditions',
                        style: GoogleFonts.hindSiliguri(
                          fontSize: 10,
                          color: Colors.grey[500],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.hindSiliguri(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF0D3D52),
      ),
    );
  }

  Widget _buildNameField() {
    return TextField(
      controller: _authController.nameController,
      focusNode: _nameFocus,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        _nameFocus.unfocus();
        FocusScope.of(context).requestFocus(_emailFocus);
      },
      decoration: InputDecoration(
        hintText: 'John Doe',
        hintStyle: GoogleFonts.hindSiliguri(
          fontSize: 13,
          color: Colors.grey[400],
        ),
        prefixIcon: const Icon(
          Icons.person_outline,
          color: Color(0xFF1A5F7A),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.15),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF1A5F7A),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: _authController.emailController,
      focusNode: _emailFocus,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onSubmitted: (_) {
        _emailFocus.unfocus();
        FocusScope.of(context).requestFocus(_passwordFocus);
      },
      decoration: InputDecoration(
        hintText: 'your@email.com',
        hintStyle: GoogleFonts.hindSiliguri(
          fontSize: 13,
          color: Colors.grey[400],
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color(0xFF1A5F7A),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.15),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.15),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF1A5F7A),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Obx(
      () => TextField(
        controller: _authController.passwordController,
        focusNode: _passwordFocus,
        obscureText: !_authController.isPasswordVisible.value,
        textInputAction: TextInputAction.next,
        onSubmitted: (_) {
          _passwordFocus.unfocus();
          FocusScope.of(context).requestFocus(_confirmPasswordFocus);
        },
        onChanged: (_) {
          setState(() {});
        },
        decoration: InputDecoration(
          hintText: '••••••••',
          hintStyle: GoogleFonts.hindSiliguri(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF1A5F7A),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _authController.isPasswordVisible.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF1A5F7A),
              size: 20,
            ),
            onPressed: _authController.togglePasswordVisibility,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1A5F7A),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmPasswordField() {
    return Obx(
      () => TextField(
        controller: _authController.confirmPasswordController,
        focusNode: _confirmPasswordFocus,
        obscureText: !_authController.isConfirmPasswordVisible.value,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) {
          _confirmPasswordFocus.unfocus();
          _authController.signUp();
        },
        decoration: InputDecoration(
          hintText: '••••••••',
          hintStyle: GoogleFonts.hindSiliguri(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.lock_outline,
            color: Color(0xFF1A5F7A),
            size: 20,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _authController.isConfirmPasswordVisible.value
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: const Color(0xFF1A5F7A),
              size: 20,
            ),
            onPressed: _authController.toggleConfirmPasswordVisibility,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: Colors.grey.withOpacity(0.15),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
              color: Color(0xFF1A5F7A),
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _authController.passwordController.text;
    final hasLength = password.length >= 6;
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars =
        password.contains(RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?/~`-]'));

    final strength = [hasLength, hasUppercase, hasLowercase, hasDigits, hasSpecialChars]
        .where((element) => element)
        .length;

    Color getStrengthColor() {
      if (strength <= 2) return Colors.red;
      if (strength == 3) return Colors.orange;
      if (strength == 4) return Colors.yellow;
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index < 4 ? 6 : 0),
                decoration: BoxDecoration(
                  color: index < strength
                      ? getStrengthColor()
                      : Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _getStrengthText(strength),
          style: GoogleFonts.hindSiliguri(
            fontSize: 11,
            color: getStrengthColor(),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirement(String requirement) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 14,
            color: Colors.grey[400],
          ),
          const SizedBox(width: 8),
          Text(
            requirement,
            style: GoogleFonts.hindSiliguri(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getStrengthText(int strength) {
    if (strength == 0) return 'No password';
    if (strength <= 2) return 'Weak';
    if (strength == 3) return 'Fair';
    if (strength == 4) return 'Good';
    return 'Strong';
  }
}
