import 'package:posdevices/data/models/cart_item_model.dart';
import 'package:posdevices/data/models/menu_item_model.dart';

class CartCalculator {
  /// Calculate subtotal (before any taxes/fees)
  static double calculateSubtotal(List<CartItemModel> items) {
    return items.fold(
      0.0,
      (total, item) => total + (item.price * item.quantity),
    );
  }

  /// Calculate total with optional tax percentage
  static double calculateTotal(
    List<CartItemModel> items, {
    double taxPercentage = 0.0,
  }) {
    final subtotal = calculateSubtotal(items);
    final tax = subtotal * (taxPercentage / 100);
    return subtotal + tax;
  }

  /// Calculate tax amount
  static double calculateTax(
    List<CartItemModel> items, {
    double taxPercentage = 0.0,
  }) {
    final subtotal = calculateSubtotal(items);
    return subtotal * (taxPercentage / 100);
  }

  /// Check if cart is empty
  static bool isEmpty(List<CartItemModel> items) {
    return items.isEmpty;
  }

  /// Count total items in cart
  static int getTotalItemCount(List<CartItemModel> items) {
    return items.fold(0, (total, item) => total + item.quantity);
  }

  /// Remove an item from cart
  static List<CartItemModel> removeItem(
    List<CartItemModel> items,
    String menuItemId,
  ) {
    return items.where((item) => item.menuItemId != menuItemId).toList();
  }

  /// Update quantity of an item
  static List<CartItemModel> updateQuantity(
    List<CartItemModel> items,
    String menuItemId,
    int quantity,
  ) {
    if (quantity <= 0) {
      return removeItem(items, menuItemId);
    }

    return items.map((item) {
      if (item.menuItemId == menuItemId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
  }

  /// Add or update an item in cart
  static List<CartItemModel> addOrUpdateItem(
    List<CartItemModel> items,
    MenuItemModel menuItem,
    int quantity,
  ) {
    final existingIndex = items.indexWhere(
      (item) => item.menuItemId == menuItem.id,
    );

    if (existingIndex >= 0) {
      // Item already in cart, update quantity
      final currentQuantity = items[existingIndex].quantity;
      return updateQuantity(items, menuItem.id, currentQuantity + quantity);
    } else {
      // New item, add to cart
      return [
        ...items,
        CartItemModel(
          menuItemId: menuItem.id,
          name: menuItem.name,
          price: menuItem.price,
          quantity: quantity,
          imageUrl: menuItem.imageUrl,
        ),
      ];
    }
  }
}
