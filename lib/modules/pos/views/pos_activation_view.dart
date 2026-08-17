import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posdevices/core/constants/app_constants.dart';

import '../controllers/pos_activation_controller.dart';

class PosActivationView extends StatelessWidget {
  const PosActivationView({super.key});

  static const Color background = Color(0xFF02060B);
  static const Color primary = Color(0xFF00D9E8);
  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF9AA1AA);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PosActivationController());

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text(
                    'Activate this POS',
                    style: TextStyle(
                      color: textPrimary,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Enter the venue code so this terminal can load the live menu.',
                    style: TextStyle(color: textSecondary, fontSize: 16),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    textCapitalization: TextCapitalization.characters,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    decoration: InputDecoration(
                      hintText: AppConstants.demoVenueCode,
                      hintStyle: const TextStyle(color: Color(0xFF747B85)),
                      filled: true,
                      fillColor: const Color(0xFF080D13),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFF30363D)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: primary),
                      ),
                    ),
                    onChanged: (value) => controller.venueCode.value = value,
                    onSubmitted: (_) => controller.activate(),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demo code: ${AppConstants.demoVenueCode}',
                    style: const TextStyle(color: primary, fontSize: 14),
                  ),
                  Obx(() {
                    if (controller.errorMessage.value.isEmpty) {
                      return const SizedBox(height: 24);
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Color(0xFFF87171)),
                      ),
                    );
                  }),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: controller.activate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Continue to menu',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}