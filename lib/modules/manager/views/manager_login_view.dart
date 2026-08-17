import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/manager_auth_controller.dart';

class ManagerLoginView extends StatelessWidget {
  ManagerLoginView({super.key});

  final ManagerAuthController controller = Get.put(ManagerAuthController());

  final TextEditingController loginController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  static const Color background = Color(0xFF02060B);
  static const Color inputBackground = Color(0xFF080D13);
  static const Color borderColor = Color(0xFF30363D);
  static const Color primary = Color(0xFF00D9E8);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF9AA1AA);
  static const Color hintColor = Color(0xFF747B85);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 35),

                  Center(
                    child: Image.asset(
                      'assets/images/logo (1).png',
                      width: 230,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 70),

                  const Text(
                    'Welcome back! 👋',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.8,
                    ),
                  ),

                  const SizedBox(height: 42),

                  const Text(
                    'Phone number or Email ID',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  _InputField(
                    controller: loginController,
                    hint: 'Enter phone number or email',
                    icon: Icons.phone_iphone_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Password',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Obx(
                    () => _InputField(
                      controller: passwordController,
                      hint: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                      obscureText: controller.obscurePassword.value,
                      keyboardType: TextInputType.visiblePassword,
                      suffixIcon: IconButton(
                        onPressed: controller.togglePasswordVisibility,
                        icon: Icon(
                          controller.obscurePassword.value
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: const Color(0xFF9BA1A8),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: controller.forgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Obx(() {
                    final loading = controller.isLoading.value;

                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF08B7C8), Color(0xFF0EDCE3)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : () {
                                  controller.login(
                                    loginController.text.trim(),
                                    passwordController.text,
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 23,
                                  height: 23,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      ),
                    );
                  }),

                  const SizedBox(height: 42),

                  Row(
                    children: [
                      Expanded(child: Container(height: 1, color: borderColor)),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'or',
                          style: TextStyle(color: textSecondary, fontSize: 16),
                        ),
                      ),
                      Expanded(child: Container(height: 1, color: borderColor)),
                    ],
                  ),

                  const SizedBox(height: 45),

                  const Center(
                    child: Text(
                      'By continuing, you agree to our',
                      style: TextStyle(color: Color(0xFFA2A7AE), fontSize: 13),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Center(
                    child: RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text: '   and   ',
                            style: TextStyle(
                              color: Color(0xFFA2A7AE),
                              fontSize: 13,
                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                              color: primary,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        color: const Color(0xFF080D13),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF30363D)),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        cursorColor: const Color(0xFF00D9E8),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF747B85), fontSize: 16),
          prefixIcon: Icon(icon, color: const Color(0xFF00D9E8), size: 24),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
