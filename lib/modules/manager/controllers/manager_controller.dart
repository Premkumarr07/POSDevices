import 'package:get/get.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

import '../../../data/repositories/menu_repository.dart';

class ManagerController extends GetxController {
  ManagerController({MenuRepository? repository})
    : _repository = repository ?? MenuRepository();

  final MenuRepository _repository;

  final searchQuery = ''.obs;
  final selectedCategoryId = RxnString();
  final filteredMenu = <MenuItemModel>[].obs;

  List<CategoryModel> get categories => _repository.categories;
  List<OrderModel> get orders => _repository.orders;
  VenueModel? get venue => _repository.venue.value;
  List<DeviceModel> get devices => _repository.devices;

  @override
  void onInit() {
    super.onInit();
    _repository.seed();
    ever(_repository.menuItems, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCategoryId, (_) => _applyFilters());
    _applyFilters();
  }

  void updateSearch(String value) {
    searchQuery.value = value;
    _applyFilters();
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();

    final items = _repository.menuItems.where((item) {
      final matchesCategory =
          selectedCategoryId.value == null ||
          item.categoryId == selectedCategoryId.value;
      final matchesQuery =
          query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList()..sort((a, b) => a.name.compareTo(b.name));

    filteredMenu.assignAll(items);
  }

  Future<void> saveItem(MenuItemModel item) async {
    await _repository.upsertMenuItem(item);
    _applyFilters();
  }

  Future<void> toggleAvailability(MenuItemModel item) async {
    await _repository.toggleAvailability(item.id, !item.available);
    _applyFilters();
  }

  Future<void> deleteItem(String itemId) async {
    await _repository.deleteMenuItem(itemId);
    _applyFilters();
  }

  int get totalItems => _repository.menuItems.length;
  int get availableItems =>
      _repository.menuItems.where((item) => item.available).length;
  int get soldOutItems =>
      _repository.menuItems.where((item) => !item.available).length;
  int get activeDevices =>
      _repository.devices.where((device) => device.status == 'online').length;
}
