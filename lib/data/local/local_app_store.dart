import 'package:get/get.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

import 'demo_catalog.dart';

class LocalAppStore {
  LocalAppStore._();

  static final LocalAppStore instance = LocalAppStore._();

  final Rxn<VenueModel> venue = Rxn<VenueModel>();
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<MenuItemModel> menuItems = <MenuItemModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<DeviceModel> devices = <DeviceModel>[].obs;

  void seed() {
    if (menuItems.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    venue.value = DemoCatalog.venue(now);
    categories.assignAll(DemoCatalog.categories(now));
    menuItems.assignAll(DemoCatalog.menuItems(now));
    devices.assignAll(DemoCatalog.devices(now));
    orders.assignAll([
      OrderModel(
        id: 'order_1001',
        venueId: venue.value!.id,
        deviceId: 'device_001',
        items: [
          CartItemModel(
            menuItemId: 'item_001',
            name: 'Classic Burger',
            price: 16.0,
            quantity: 2,
            imageUrl: null,
          ),
          CartItemModel(
            menuItemId: 'item_004',
            name: 'Margarita',
            price: 12.0,
            quantity: 1,
            imageUrl: null,
          ),
        ],
        subtotal: 44.0,
        total: 44.0,
        status: 'completed',
        createdAt: now.subtract(const Duration(minutes: 18)),
        updatedAt: now.subtract(const Duration(minutes: 17)),
      ),
    ]);
  }
}