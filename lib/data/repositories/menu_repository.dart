import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:posdevices/core/constants/app_constants.dart';
import 'package:posdevices/core/constants/firestore_paths.dart';
import 'package:posdevices/core/services/firebase_service.dart';
import 'package:posdevices/data/local/demo_catalog.dart';
import 'package:posdevices/data/local/local_app_store.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

class MenuRepository {
  MenuRepository({LocalAppStore? store})
    : _store = store ?? LocalAppStore.instance;

  final LocalAppStore _store;
  final Rxn<VenueModel> venue = Rxn<VenueModel>();
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<MenuItemModel> menuItems = <MenuItemModel>[].obs;
  final RxList<DeviceModel> devices = <DeviceModel>[].obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _menuSub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _categorySub;
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _deviceSub;
  String? _boundVenueId;

  bool get _useFirestore => FirebaseService.isReady;

  Future<void> bindVenue(String venueId) async {
    _boundVenueId = venueId;
    if (_useFirestore) {
      await _seedFirestore(venueId);
      _listenFirestore(venueId);
      return;
    }

    _store.seed();
    venue.value = _store.venue.value;
    categories.assignAll(_store.categories);
    menuItems.assignAll(_store.menuItems);
    devices.assignAll(_store.devices);
  }

  void seed() {
    bindVenue(AppConstants.demoVenueId);
  }

  Future<void> upsertMenuItem(MenuItemModel item) async {
    final updated = item.copyWith(updatedAt: DateTime.now());
    if (_useFirestore) {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.menuItemsCollection)
          .doc(updated.id)
          .set(updated.toFirestore());
      return;
    }

    final index = _store.menuItems.indexWhere((entry) => entry.id == item.id);
    if (index >= 0) {
      _store.menuItems[index] = updated;
    } else {
      _store.menuItems.add(updated);
    }
    _store.menuItems.refresh();
    menuItems.assignAll(_store.menuItems);
  }

  Future<void> deleteMenuItem(String itemId) async {
    if (_useFirestore) {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.menuItemsCollection)
          .doc(itemId)
          .delete();
      return;
    }

    _store.menuItems.removeWhere((item) => item.id == itemId);
    menuItems.assignAll(_store.menuItems);
  }

  Future<void> toggleAvailability(String itemId, bool available) async {
    if (_useFirestore) {
      await FirebaseFirestore.instance
          .collection(FirestorePaths.menuItemsCollection)
          .doc(itemId)
          .update({
            'available': available,
            'updatedAt': Timestamp.now(),
          });
      return;
    }

    final index = _store.menuItems.indexWhere((entry) => entry.id == itemId);
    if (index == -1) {
      return;
    }
    _store.menuItems[index] = _store.menuItems[index].copyWith(
      available: available,
      updatedAt: DateTime.now(),
    );
    menuItems.assignAll(_store.menuItems);
  }

  void dispose() {
    _menuSub?.cancel();
    _categorySub?.cancel();
    _deviceSub?.cancel();
  }

  void _listenFirestore(String venueId) {
    final db = FirebaseFirestore.instance;
    _menuSub?.cancel();
    _categorySub?.cancel();
    _deviceSub?.cancel();

    _menuSub = db
        .collection(FirestorePaths.menuItemsCollection)
        .where('venueId', isEqualTo: venueId)
        .snapshots()
        .listen((snapshot) {
          final items = snapshot.docs
              .map(MenuItemModel.fromFirestore)
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
          menuItems.assignAll(items);
        });

    _categorySub = db
        .collection(FirestorePaths.categoriesCollection)
        .where('venueId', isEqualTo: venueId)
        .snapshots()
        .listen((snapshot) {
          final cats = snapshot.docs
              .map(CategoryModel.fromFirestore)
              .toList()
            ..sort((a, b) => a.order.compareTo(b.order));
          categories.assignAll(cats);
        });

    _deviceSub = db
        .collection(FirestorePaths.devicesCollection)
        .where('venueId', isEqualTo: venueId)
        .snapshots()
        .listen((snapshot) {
          devices.assignAll(
            snapshot.docs.map(DeviceModel.fromFirestore).toList(),
          );
        });

    db.collection(FirestorePaths.venuesCollection).doc(venueId).snapshots().listen((
      doc,
    ) {
      if (doc.exists) {
        venue.value = VenueModel.fromFirestore(doc);
      }
    });
  }

  Future<void> _seedFirestore(String venueId) async {
    final db = FirebaseFirestore.instance;
    final existing = await db
        .collection(FirestorePaths.menuItemsCollection)
        .where('venueId', isEqualTo: venueId)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      return;
    }

    final now = DateTime.now();
    final venueModel = DemoCatalog.venue(now);
    final batch = db.batch();
    batch.set(
      db.collection(FirestorePaths.venuesCollection).doc(venueModel.id),
      venueModel.toFirestore(),
    );
    for (final category in DemoCatalog.categories(now)) {
      batch.set(
        db.collection(FirestorePaths.categoriesCollection).doc(category.id),
        category.toFirestore(),
      );
    }
    for (final item in DemoCatalog.menuItems(now)) {
      batch.set(
        db.collection(FirestorePaths.menuItemsCollection).doc(item.id),
        item.toFirestore(),
      );
    }
    for (final device in DemoCatalog.devices(now)) {
      batch.set(
        db.collection(FirestorePaths.devicesCollection).doc(device.id),
        device.toFirestore(),
      );
    }
    await batch.commit();
    _boundVenueId ??= venueId;
  }
}