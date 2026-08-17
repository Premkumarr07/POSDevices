import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:posdevices/business/cart_calculator.dart';
import 'package:posdevices/core/constants/app_constants.dart';
import 'package:posdevices/core/constants/firestore_paths.dart';
import 'package:posdevices/core/services/firebase_service.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';

import '../local/local_app_store.dart';

class OrderRepository {
  OrderRepository({LocalAppStore? store})
    : _store = store ?? LocalAppStore.instance;

  final LocalAppStore _store;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSub;

  bool get _useFirestore => FirebaseService.isReady;

  Future<void> bindVenue(String venueId) async {
    if (_useFirestore) {
      _ordersSub?.cancel();
      _ordersSub = FirebaseFirestore.instance
          .collection(FirestorePaths.ordersCollection)
          .where('venueId', isEqualTo: venueId)
          .snapshots()
          .listen((snapshot) {
            final items = snapshot.docs
                .map(OrderModel.fromFirestore)
                .toList()
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            orders.assignAll(items);
          });
      return;
    }

    _store.seed();
    orders.assignAll(_store.orders);
  }

  Future<void> placeOrder(List<CartItemModel> cartItems) async {
    if (cartItems.isEmpty) {
      return;
    }

    final subtotal = CartCalculator.calculateSubtotal(cartItems);
    final tax = CartCalculator.calculateTax(cartItems, taxPercentage: 8.0);
    final now = DateTime.now();
    final order = OrderModel(
      id: 'order_${now.millisecondsSinceEpoch}',
      venueId: AppConstants.demoVenueId,
      deviceId: AppConstants.demoDeviceId,
      items: cartItems,
      subtotal: subtotal,
      total: subtotal + tax,
      status: 'completed',
      createdAt: now,
      updatedAt: now,
    );

    if (_useFirestore) {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.ordersCollection)
          .doc(order.id)
          .set(order.toFirestore());
      return;
    }

    _store.orders.insert(0, order);
    orders.assignAll(_store.orders);
  }

  void dispose() {
    _ordersSub?.cancel();
  }
}