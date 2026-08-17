// class FirestorePaths {
//   // Collections
//   static const String usersCollection = 'users';
//   static const String venuesCollection = 'venues';
//   static const String categoriesCollection = 'categories';
//   static const String menuItemsCollection = 'menu_items';
//   static const String ordersCollection = 'orders';
//   static const String devicesCollection = 'devices';

//   // Document paths
//   static String userDoc(String uid) => '$usersCollection/$uid';
//   static String venueDoc(String venueId) => '$venuesCollection/$venueId';
//   static String categoryDoc(String categoryId) =>
//       '$categoriesCollection/$categoryId';
//   static String menuItemDoc(String itemId) => '$menuItemsCollection/$itemId';
//   static String orderDoc(String orderId) => '$ordersCollection/$orderId';
//   static String deviceDoc(String deviceId) => '$devicesCollection/$deviceId';

//   // Subcollections
//   static String menuItemsByVenue(String venueId) =>
//       '$venuesCollection/$venueId/$menuItemsCollection';
//   static String categoriesByVenue(String venueId) =>
//       '$venuesCollection/$venueId/$categoriesCollection';
//   static String ordersByVenue(String venueId) =>
//       '$venuesCollection/$venueId/$ordersCollection';
//   static String devicesByVenue(String venueId) =>
//       '$venuesCollection/$venueId/$devicesCollection';
// }
