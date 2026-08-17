import 'package:get/get.dart';
import 'package:posdevices/business/cart_calculator.dart';
import 'package:posdevices/business/menu_rules.dart';
import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/category_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';
import 'package:posdevices/data/models/venue_model.dart';

import '../../../data/repositories/menu_repository.dart';
import '../../../data/repositories/order_repository.dart';

class PosController extends GetxController {
  PosController({
    MenuRepository? menuRepository,
    OrderRepository? orderRepository,
  }) : _menuRepository = menuRepository ?? MenuRepository(),
       _orderRepository = orderRepository ?? OrderRepository();

  final MenuRepository _menuRepository;
  final OrderRepository _orderRepository;

  final searchQuery = ''.obs;
  final selectedCategoryId = RxnString();
  final cart = <CartItemModel>[].obs;
  final filteredMenu = <MenuItemModel>[].obs;

  List<CategoryModel> get categories => _menuRepository.categories;
  VenueModel? get venue => _menuRepository.venue.value;

  @override
  void onInit() {
    super.onInit();
    _menuRepository.seed();
    ever(_menuRepository.menuItems, (_) => _applyFilters());
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
    final items = _menuRepository.menuItems.where((item) {
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

  void addItem(MenuItemModel item) {
    if (!MenuRules.canOrder(item)) {
      return;
    }
    cart.assignAll(CartCalculator.addOrUpdateItem(cart, item, 1));
  }

  void removeItem(String menuItemId) {
    cart.assignAll(CartCalculator.removeItem(cart, menuItemId));
  }

  void setQuantity(String menuItemId, int quantity) {
    cart.assignAll(CartCalculator.updateQuantity(cart, menuItemId, quantity));
  }

  void clearCart() {
    cart.clear();
  }

  double get subtotal => CartCalculator.calculateSubtotal(cart);
  double get tax => CartCalculator.calculateTax(cart, taxPercentage: 8.0);
  double get total => CartCalculator.calculateTotal(cart, taxPercentage: 8.0);

  Future<void> placeOrder() async {
    await _orderRepository.placeOrder(cart.toList());
    cart.clear();
  }
}
