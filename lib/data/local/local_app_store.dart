import 'package:get/get.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

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
    venue.value = VenueModel(
      id: 'venue_001',
      name: 'The Copper Fox',
      type: 'restaurant',
      active: true,
      timezone: 'Asia/Calcutta',
      createdAt: now,
      updatedAt: now,
    );

    categories.assignAll([
      CategoryModel(
        id: 'cat_burger',
        venueId: 'venue_001',
        name: 'Burgers',
        icon: null,
        order: 1,
        createdAt: now,
      ),
      CategoryModel(
        id: 'cat_drinks',
        venueId: 'venue_001',
        name: 'Drinks',
        icon: null,
        order: 2,
        createdAt: now,
      ),
      CategoryModel(
        id: 'cat_specials',
        venueId: 'venue_001',
        name: 'Specials',
        icon: null,
        order: 3,
        createdAt: now,
      ),
    ]);

    menuItems.assignAll([
      MenuItemModel(
        id: 'item_001',
        venueId: 'venue_001',
        name: 'Classic Burger',
        description:
            'Angus beef burger with cheddar, lettuce, tomato, onion, and house sauce.',
        price: 16.0,
        categoryId: 'cat_burger',
        available: true,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      MenuItemModel(
        id: 'item_002',
        venueId: 'venue_001',
        name: 'Chicken Wings',
        description: 'Crispy wings tossed in a smoky glaze.',
        price: 14.0,
        categoryId: 'cat_specials',
        available: true,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      MenuItemModel(
        id: 'item_003',
        venueId: 'venue_001',
        name: 'Loaded Fries',
        description: 'Fries, bacon, cheese sauce, and jalapenos.',
        price: 9.0,
        categoryId: 'cat_specials',
        available: false,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      MenuItemModel(
        id: 'item_004',
        venueId: 'venue_001',
        name: 'Margarita',
        description: 'Fresh lime margarita with a salted rim.',
        price: 12.0,
        categoryId: 'cat_drinks',
        available: true,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
      MenuItemModel(
        id: 'item_005',
        venueId: 'venue_001',
        name: 'Old Fashioned',
        description: 'Bourbon, bitters, and orange peel.',
        price: 13.0,
        categoryId: 'cat_drinks',
        available: true,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
    ]);

    devices.assignAll([
      DeviceModel(
        id: 'device_001',
        venueId: 'venue_001',
        name: 'Table Tent #01',
        platform: 'android',
        status: 'online',
        lastSeenAt: now.subtract(const Duration(seconds: 10)),
        appVersion: '1.0.0',
        menuVersion: 42,
        createdAt: now,
      ),
      DeviceModel(
        id: 'device_002',
        venueId: 'venue_001',
        name: 'TV Stick #01',
        platform: 'web',
        status: 'online',
        lastSeenAt: now.subtract(const Duration(minutes: 4)),
        appVersion: '1.0.0',
        menuVersion: 41,
        createdAt: now,
      ),
    ]);

    orders.assignAll([
      OrderModel(
        id: 'order_1001',
        venueId: 'venue_001',
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
