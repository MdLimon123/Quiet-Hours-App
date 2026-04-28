import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import 'session_controller.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  // Observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Form controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController confirmPasswordController;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  /// Sign in with email and password
  Future<void> signIn() async {
    try {
      clearError();
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;

      if (email.isEmpty || password.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      if (!GetUtils.isEmail(email)) {
        errorMessage.value = 'Please enter a valid email';
        return;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
      }

      await _authService.signIn(email: email, password: password);

      await Get.find<SessionController>().syncSessionAfterFirebaseAuth();

      clearFormFields();

      final hasProfile =
          Get.find<SessionController>().profile.value != null;
      Get.offAllNamed(hasProfile ? AppRoutes.shell : AppRoutes.onboarding);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      if (kDebugMode) print('Sign in error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign up with email, password, and name
  Future<void> signUp() async {
    try {
      clearError();
      isLoading.value = true;

      final email = emailController.text.trim();
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final name = nameController.text.trim();

      // Validation
      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      if (!GetUtils.isEmail(email)) {
        errorMessage.value = 'Please enter a valid email';
        return;
      }

      if (name.length < 2) {
        errorMessage.value = 'Name must be at least 2 characters';
        return;
      }

      if (password.length < 6) {
        errorMessage.value = 'Password must be at least 6 characters';
        return;
      }

      if (password != confirmPassword) {
        errorMessage.value = 'Passwords do not match';
        return;
      }

      // Check password strength
      if (!_isStrongPassword(password)) {
        errorMessage.value = 'Password must contain uppercase, lowercase, digit, and special character';
        return;
      }

      await _authService.signUp(
        email: email,
        password: password,
        name: name,
      );

      await Get.find<SessionController>().syncSessionAfterFirebaseAuth();

      clearFormFields();
      Get.offAllNamed(AppRoutes.onboarding);
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      if (kDebugMode) print('Sign up error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  /// Clear error message
  void clearError() {
    errorMessage.value = '';
  }

  /// Clear form fields
  void clearFormFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
  }

  /// Check if password is strong
  bool _isStrongPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?/~`-]'));

    return hasUppercase && hasLowercase && hasDigits && hasSpecialChars;
  }
}
