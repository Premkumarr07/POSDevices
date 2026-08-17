import 'package:get/get.dart';
import 'package:posdevices/business/cart_calculator.dart';
// import 'package:plugin_pos/shared/plugin_shared.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

import '../local/local_app_store.dart';

class MenuRepository {
  MenuRepository({LocalAppStore? store})
    : _store = store ?? LocalAppStore.instance {
    _store.seed();
  }

  final LocalAppStore _store;

  Rxn<VenueModel> get venue => _store.venue;
  RxList<CategoryModel> get categories => _store.categories;
  RxList<MenuItemModel> get menuItems => _store.menuItems;
  RxList<OrderModel> get orders => _store.orders;
  RxList<DeviceModel> get devices => _store.devices;

  void seed() => _store.seed();

  Future<void> upsertMenuItem(MenuItemModel item) async {
    final index = _store.menuItems.indexWhere((entry) => entry.id == item.id);
    final updated = item.copyWith(updatedAt: DateTime.now());
    if (index >= 0) {
      _store.menuItems[index] = updated;
    } else {
      _store.menuItems.add(updated);
    }
    _store.menuItems.refresh();
  }

  Future<void> deleteMenuItem(String itemId) async {
    _store.menuItems.removeWhere((item) => item.id == itemId);
    _store.menuItems.refresh();
  }

  Future<void> toggleAvailability(String itemId, bool available) async {
    final index = _store.menuItems.indexWhere((entry) => entry.id == itemId);
    if (index == -1) {
      return;
    }

    _store.menuItems[index] = _store.menuItems[index].copyWith(
      available: available,
      updatedAt: DateTime.now(),
    );
    _store.menuItems.refresh();
  }

  Future<void> createOrder(List<CartItemModel> cartItems) async {
    if (cartItems.isEmpty) {
      return;
    }

    final subtotal = CartCalculator.calculateSubtotal(cartItems);
    final now = DateTime.now();
    _store.orders.insert(
      0,
      OrderModel(
        id: 'order_${now.millisecondsSinceEpoch}',
        venueId: _store.venue.value?.id ?? 'venue_001',
        deviceId: 'local_demo_device',
        items: cartItems,
        subtotal: subtotal,
        total: subtotal,
        status: 'completed',
        createdAt: now,
        updatedAt: now,
      ),
    );
    _store.orders.refresh();
  }
}
