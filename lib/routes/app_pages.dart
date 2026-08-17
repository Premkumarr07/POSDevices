import 'package:get/get.dart';

import '../modules/manager/bindings/manager_binding.dart';
import '../modules/manager/views/manager_dashboard_view.dart';
import '../modules/manager/views/manager_devices_view.dart';
import '../modules/manager/views/manager_login_view.dart';
import '../modules/manager/views/manager_menu_view.dart';
import '../modules/manager/views/manager_orders_view.dart';
import '../modules/manager/views/manager_settings_view.dart';
import '../modules/pos/bindings/pos_binding.dart';
import '../modules/pos/views/pos_activation_view.dart';
import '../modules/pos/views/pos_menu_view.dart';
import '../modules/pos/views/pos_order_success_view.dart';
import 'app_routes.dart';

class AppPages {
  static final manager = <GetPage>[
    GetPage(
      name: AppRoutes.managerLogin,
      page: () => ManagerLoginView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.managerDashboard,
      page: () => const ManagerDashboardView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.managerMenu,
      page: () => const ManagerMenuView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.managerOrders,
      page: () => const ManagerOrdersView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.managerDevices,
      page: () => const ManagerDevicesView(),
      binding: ManagerBinding(),
    ),
    GetPage(
      name: AppRoutes.managerSettings,
      page: () => const ManagerSettingsView(),
      binding: ManagerBinding(),
    ),
  ];

  static final pos = <GetPage>[
    GetPage(
      name: AppRoutes.posActivation,
      page: () => const PosActivationView(),
      binding: PosBinding(),
    ),
    GetPage(
      name: AppRoutes.posMenu,
      page: () => const PosMenuView(),
      binding: PosBinding(),
    ),
    GetPage(
      name: AppRoutes.posOrderSuccess,
      page: () => const PosOrderSuccessView(),
      binding: PosBinding(),
    ),
  ];
}
