// import '../models/menu_item_model.dart';

// class MenuRules {
//   /// Check if an item can be ordered
//   static bool canOrder(MenuItemModel item) {
//     return item.available;
//   }

//   /// Validate price is positive
//   static bool isValidPrice(double price) {
//     return price >= 0;
//   }

//   /// Validate menu item has required fields
//   static bool isValidMenuItem(MenuItemModel item) {
//     return item.name.isNotEmpty &&
//         item.categoryId.isNotEmpty &&
//         isValidPrice(item.price);
//   }

//   /// Check if item is sold out
//   static bool isSoldOut(MenuItemModel item) {
//     return !item.available;
//   }

//   /// Get status text for UI
//   static String getStatusText(MenuItemModel item) {
//     return item.available ? 'Available' : 'Sold Out';
//   }

//   /// Check if item can be edited (not historical)
//   static bool canEditItem(MenuItemModel item) {
//     // In a real app, you might check historical flags, archived status, etc.
//     return true;
//   }

//   /// Check if item can be deleted
//   static bool canDeleteItem(MenuItemModel item) {
//     // In a real app, you might check if it's been ordered recently
//     return true;
//   }

//   /// Format price for display
//   static String formatPrice(double price) {
//     return '\$${price.toStringAsFixed(2)}';
//   }

//   /// Get category name (could be localized)
//   static String getCategoryDisplayName(String categoryId) {
//     final categoryNames = {
//       'cat_burger': 'Burgers',
//       'cat_pizza': 'Pizza',
//       'cat_drinks': 'Drinks',
//       'cat_desserts': 'Desserts',
//       'cat_apps': 'Appetizers',
//       'cat_salads': 'Salads',
//     };
//     return categoryNames[categoryId] ?? categoryId;
//   }
// }
