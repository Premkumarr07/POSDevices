import '../data/models/menu_item_model.dart';

class MenuRules {
  static bool canOrder(MenuItemModel item) => item.available;

  static bool isValidPrice(double price) => price >= 0;

  static bool isValidMenuItem(MenuItemModel item) {
    return item.name.isNotEmpty &&
        item.categoryId.isNotEmpty &&
        isValidPrice(item.price);
  }

  static bool isSoldOut(MenuItemModel item) => !item.available;

  static String getStatusText(MenuItemModel item) {
    return item.available ? 'Available' : 'Sold Out';
  }

  static bool canEditItem(MenuItemModel item) => true;

  static bool canDeleteItem(MenuItemModel item) => true;

  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  static String getCategoryDisplayName(String categoryId) {
    final categoryNames = {
      'cat_burger': 'Burgers',
      'cat_pizza': 'Pizza',
      'cat_drinks': 'Drinks',
      'cat_desserts': 'Desserts',
      'cat_apps': 'Appetizers',
      'cat_salads': 'Salads',
    };
    return categoryNames[categoryId] ?? categoryId;
  }
}
