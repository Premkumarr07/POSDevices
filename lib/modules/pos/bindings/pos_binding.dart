import 'package:get/get.dart';

import '../../../data/repositories/menu_repository.dart';
import '../../../data/repositories/order_repository.dart';
import '../controllers/pos_activation_controller.dart';
import '../controllers/pos_controller.dart';

class PosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MenuRepository());
    Get.lazyPut(() => OrderRepository());
    Get.lazyPut(() => PosActivationController());
    Get.lazyPut(
      () => PosController(
        menuRepository: Get.find<MenuRepository>(),
        orderRepository: Get.find<OrderRepository>(),
      ),
    );
  }
}
