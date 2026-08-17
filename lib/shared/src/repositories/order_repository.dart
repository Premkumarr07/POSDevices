import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';
import '../services/firestore_service.dart';
import '../constants/firestore_paths.dart';

class OrderRepository {
  final FirestoreService _firestoreService;

  OrderRepository({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  Future<OrderModel> getOrder(String orderId) async {
    final doc = await _firestoreService.getDocument(
      FirestorePaths.orderDoc(orderId),
    );
    return OrderModel.fromFirestore(doc);
  }

  Future<void> createOrder(OrderModel order) async {
    await _firestoreService.setDocument(
      FirestorePaths.orderDoc(order.id),
      order.toFirestore(),
    );
  }

  Future<void> updateOrder(String orderId, OrderModel order) async {
    await _firestoreService.updateDocument(
      FirestorePaths.orderDoc(orderId),
      order.toFirestore(),
    );
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestoreService.updateDocument(FirestorePaths.orderDoc(orderId), {
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Stream<List<OrderModel>> watchOrdersByVenue(String venueId) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.ordersCollection,
          queryBuilder: (query) => query
              .where('venueId', isEqualTo: venueId)
              .orderBy('createdAt', descending: true),
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<List<OrderModel>> getOrdersByVenue(String venueId) async {
    final snapshot = await _firestoreService.getCollection(
      FirestorePaths.ordersCollection,
      queryBuilder: (query) => query
          .where('venueId', isEqualTo: venueId)
          .orderBy('createdAt', descending: true),
    );

    return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
  }

  Stream<List<OrderModel>> watchOrdersByDevice(String deviceId) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.ordersCollection,
          queryBuilder: (query) => query
              .where('deviceId', isEqualTo: deviceId)
              .orderBy('createdAt', descending: true)
              .limit(100),
        )
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> deleteOrder(String orderId) async {
    await _firestoreService.deleteDocument(FirestorePaths.orderDoc(orderId));
  }
}
