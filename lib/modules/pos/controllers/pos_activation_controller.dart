import 'package:get/get.dart';

class PosActivationController extends GetxController {
  final venueCode = ''.obs;
  final isActivated = false.obs;

  void activate() {
    isActivated.value = venueCode.value.trim().isNotEmpty;
  }
}
