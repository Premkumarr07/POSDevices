import 'package:flutter_test/flutter_test.dart';
import 'package:posdevices/business/cart_calculator.dart';
import 'package:posdevices/data/models/menu_item_model.dart';

void main() {
  final burger = MenuItemModel(
    id: 'item_001',
    venueId: 'venue_001',
    name: 'Classic Burger',
    description: 'Demo',
    price: 16,
    categoryId: 'cat_burger',
    available: true,
    createdAt: DateTime(2026, 1, 1),
    updatedAt: DateTime(2026, 1, 1),
  );

  test('addOrUpdateItem accumulates quantity and totals', () {
    var cart = CartCalculator.addOrUpdateItem([], burger, 1);
    cart = CartCalculator.addOrUpdateItem(cart, burger, 2);

    expect(cart.single.quantity, 3);
    expect(CartCalculator.calculateSubtotal(cart), 48);
    expect(CartCalculator.calculateTax(cart, taxPercentage: 8), 3.84);
    expect(CartCalculator.calculateTotal(cart, taxPercentage: 8), 51.84);
  });
}
