// import 'package:plugin_pos/shared/plugin_shared.dart';
import 'package:posdevices/business/cart_calculator.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';

import '../local/local_app_store.dart';

class OrderRepository {
  OrderRepository({LocalAppStore? store})
    : _store = store ?? LocalAppStore.instance {
    _store.seed();
  }

  final LocalAppStore _store;

  List<OrderModel> get orders => List.unmodifiable(_store.orders);

  Future<void> placeOrder(List<CartItemModel> cartItems) async {
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
