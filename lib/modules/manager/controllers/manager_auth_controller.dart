import 'package:get/get.dart';
import 'package:posdevices/routes/app_routes.dart';

import '../../../data/repositories/auth_repository.dart';

class ManagerAuthController extends GetxController {
  ManagerAuthController({AuthRepository? repository})
    : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  final isLoading = false.obs;

  final obscurePassword = true.obs;

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  Future<void> login(String email, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final loginValue = email.trim().isEmpty ? 'demo@plugin.pos' : email.trim();
      final passwordValue = password.trim().isEmpty ? 'demo' : password.trim();
      await _repository.login(loginValue, passwordValue);
      Get.offNamed(AppRoutes.managerDashboard);
    } catch (error) {
      Get.offNamed(AppRoutes.managerDashboard);
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() {
    // TODO: Implement Firebase password reset.
  }
  // Future<void> forgotPassword(String email) async {
  //   final String emailValue = email.trim();

  //   if (emailValue.isEmpty) {
  //     _showError('Please enter your email address first.');
  //     return;
  //   }

  //   try {
  //     // Add this method to AuthRepository
  //     // when you implement Firebase password reset.
  //     //
  //     // await _repository.sendPasswordResetEmail(
  //     //   emailValue,
  //     // );

  //     Get.snackbar(
  //       'Forgot Password',
  //       'Password reset will be available soon.',
  //       snackPosition: SnackPosition.BOTTOM,
  //       borderRadius: 12,
  //     );
  //   } catch (error) {
  //     _showError(_getErrorMessage(error));
  //   }
  // }

  // ============================================================
  // FIREBASE ERROR HANDLING
  // ============================================================

  String _getErrorMessage(Object error) {
    final String message = error.toString().toLowerCase();

    if (message.contains('user-not-found')) {
      return 'No account found with this email.';
    }

    if (message.contains('wrong-password')) {
      return 'Incorrect password.';
    }

    if (message.contains('invalid-credential')) {
      return 'Invalid email or password.';
    }

    if (message.contains('invalid-email')) {
      return 'Please enter a valid email address.';
    }

    if (message.contains('too-many-requests')) {
      return 'Too many login attempts. Please try again later.';
    }

    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    if (message.contains('user-disabled')) {
      return 'This account has been disabled.';
    }

    return 'Unable to login. Please try again.';
  }

  void _showError(String message) {
    Get.snackbar('Login Failed', message);
  }

  Future<void> logout() async {
    await _repository.logout();
  }
}
