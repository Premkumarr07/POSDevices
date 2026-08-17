import '../models/category_model.dart';
import '../models/device_model.dart';
import '../models/menu_item_model.dart';
import '../models/venue_model.dart';
import '../../core/constants/app_constants.dart';

class DemoCatalog {
  DemoCatalog._();

  static VenueModel venue(DateTime now) {
    return VenueModel(
      id: AppConstants.demoVenueId,
      name: 'The Copper Fox',
      type: 'restaurant',
      active: true,
      timezone: 'Asia/Calcutta',
      createdAt: now,
      updatedAt: now,
    );
  }

  static List<CategoryModel> categories(DateTime now) {
    const venueId = AppConstants.demoVenueId;
    return [
      CategoryModel(
        id: 'cat_burger',
        venueId: venueId,
        name: 'Burgers',
        icon: null,
        order: 1,
        createdAt: now,
      ),
      CategoryModel(
        id: 'cat_drinks',
        venueId: venueId,
        name: 'Drinks',
        icon: null,
        order: 2,
        createdAt: now,
      ),
      CategoryModel(
        id: 'cat_specials',
        venueId: venueId,
        name: 'Specials',
        icon: null,
        order: 3,
        createdAt: now,
      ),
    ];
  }

  static List<MenuItemModel> menuItems(DateTime now) {
    const venueId = AppConstants.demoVenueId;
    return [
      MenuItemModel(
        id: 'item_001',
        venueId: venueId,
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
        venueId: venueId,
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
        venueId: venueId,
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
        venueId: venueId,
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
        venueId: venueId,
        name: 'Old Fashioned',
        description: 'Bourbon, bitters, and orange peel.',
        price: 13.0,
        categoryId: 'cat_drinks',
        available: true,
        imageUrl: null,
        createdAt: now,
        updatedAt: now,
      ),
    ];
  }

  static List<DeviceModel> devices(DateTime now) {
    const venueId = AppConstants.demoVenueId;
    return [
      DeviceModel(
        id: 'device_001',
        venueId: venueId,
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
        venueId: venueId,
        name: 'TV Stick #01',
        platform: 'web',
        status: 'online',
        lastSeenAt: now.subtract(const Duration(minutes: 4)),
        appVersion: '1.0.0',
        menuVersion: 41,
        createdAt: now,
      ),
    ];
  }
}