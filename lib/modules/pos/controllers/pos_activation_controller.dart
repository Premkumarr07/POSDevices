import 'package:get/get.dart';
import 'package:posdevices/core/constants/app_constants.dart';
import 'package:posdevices/routes/app_routes.dart';

class PosActivationController extends GetxController {
  final venueCode = ''.obs;
  final isActivated = false.obs;
  final errorMessage = ''.obs;

  void activate() {
    final code = venueCode.value.trim().toUpperCase();
    if (code.isEmpty) {
      errorMessage.value = 'Enter the venue code to continue.';
      return;
    }

    final valid =
        code == AppConstants.demoVenueCode || code == AppConstants.demoVenueId;
    if (!valid) {
      errorMessage.value =
          'Unknown venue. Use ${AppConstants.demoVenueCode} for the demo.';
      return;
    }

    errorMessage.value = '';
    isActivated.value = true;
    Get.offNamed(
      AppRoutes.posMenu,
      arguments: {'venueId': AppConstants.demoVenueId},
    );
  }
}