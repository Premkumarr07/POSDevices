import 'package:get/get.dart';

import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/device_repository.dart';
import '../../../data/repositories/menu_repository.dart';
import '../../../data/repositories/venue_repository.dart';
import '../controllers/manager_auth_controller.dart';
import '../controllers/manager_controller.dart';

class ManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthRepository());
    Get.lazyPut(() => MenuRepository());
    Get.lazyPut(() => VenueRepository());
    Get.lazyPut(() => DeviceRepository());
    Get.lazyPut(() => ManagerAuthController(repository: Get.find<AuthRepository>()));
    Get.lazyPut(() => ManagerController(repository: Get.find<MenuRepository>()));
  }
}
