import 'package:get/get.dart';
import 'package:posdevices/core/constants/app_constants.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/device_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/order_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

import '../../../data/repositories/menu_repository.dart';
import '../../../data/repositories/order_repository.dart';

class ManagerController extends GetxController {
  ManagerController({
    MenuRepository? repository,
    OrderRepository? orderRepository,
  }) : _repository = repository ?? MenuRepository(),
       _orderRepository = orderRepository ?? OrderRepository();

  final MenuRepository _repository;
  final OrderRepository _orderRepository;

  final searchQuery = ''.obs;
  final selectedCategoryId = RxnString();
  final filteredMenu = <MenuItemModel>[].obs;

  RxList<CategoryModel> get categories => _repository.categories;
  RxList<OrderModel> get orders => _orderRepository.orders;
  VenueModel? get venue => _repository.venue.value;
  RxList<DeviceModel> get devices => _repository.devices;

  @override
  void onInit() {
    super.onInit();
    ever(_repository.menuItems, (_) => _applyFilters());
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedCategoryId, (_) => _applyFilters());
    _start();
  }

  Future<void> _start() async {
    await _repository.bindVenue(AppConstants.demoVenueId);
    await _orderRepository.bindVenue(AppConstants.demoVenueId);
    _applyFilters();
  }

  @override
  void onClose() {
    _repository.dispose();
    _orderRepository.dispose();
    super.onClose();
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