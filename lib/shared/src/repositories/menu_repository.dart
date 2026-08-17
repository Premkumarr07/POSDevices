import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';
import '../models/category_model.dart';
import '../services/firestore_service.dart';
import '../constants/firestore_paths.dart';

class MenuRepository {
  final FirestoreService _firestoreService;

  MenuRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  // Menu Items
  Future<MenuItemModel> getMenuItem(String itemId) async {
    final doc =
        await _firestoreService.getDocument(FirestorePaths.menuItemDoc(itemId));
    return MenuItemModel.fromFirestore(doc);
  }

  Stream<List<MenuItemModel>> watchMenu(String venueId) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.menuItemsCollection,
          queryBuilder: (query) =>
              query.where('venueId', isEqualTo: venueId).orderBy('name'),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc))
            .toList());
  }

  Stream<List<MenuItemModel>> watchMenuByCategory(
    String venueId,
    String categoryId,
  ) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.menuItemsCollection,
          queryBuilder: (query) => query
              .where('venueId', isEqualTo: venueId)
              .where('categoryId', isEqualTo: categoryId)
              .orderBy('name'),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => MenuItemModel.fromFirestore(doc))
            .toList());
  }

  Future<List<MenuItemModel>> getMenu(String venueId) async {
    final snapshot = await _firestoreService.getCollection(
      FirestorePaths.menuItemsCollection,
      queryBuilder: (query) =>
          query.where('venueId', isEqualTo: venueId).orderBy('name'),
    );

    return snapshot.docs
        .map((doc) => MenuItemModel.fromFirestore(doc))
        .toList();
  }

  Future<void> createMenuItem(MenuItemModel item) async {
    await _firestoreService.setDocument(
      FirestorePaths.menuItemDoc(item.id),
      item.toFirestore(),
    );
  }

  Future<void> updateMenuItem(String itemId, MenuItemModel item) async {
    await _firestoreService.updateDocument(
      FirestorePaths.menuItemDoc(itemId),
      {...item.toFirestore(), 'updatedAt': Timestamp.now()},
    );
  }

  Future<void> deleteMenuItem(String itemId) async {
    await _firestoreService.deleteDocument(FirestorePaths.menuItemDoc(itemId));
  }

  Future<void> toggleAvailability(String itemId, bool available) async {
    await _firestoreService.updateDocument(
      FirestorePaths.menuItemDoc(itemId),
      {
        'available': available,
        'updatedAt': Timestamp.now(),
      },
    );
  }

  // Categories
  Future<List<CategoryModel>> getCategories(String venueId) async {
    final snapshot = await _firestoreService.getCollection(
      FirestorePaths.categoriesCollection,
      queryBuilder: (query) => query
          .where('venueId', isEqualTo: venueId)
          .orderBy('order')
          .orderBy('name'),
    );

    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<CategoryModel>> watchCategories(String venueId) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.categoriesCollection,
          queryBuilder: (query) => query
              .where('venueId', isEqualTo: venueId)
              .orderBy('order')
              .orderBy('name'),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList());
  }

  Future<CategoryModel> getCategory(String categoryId) async {
    final doc = await _firestoreService
        .getDocument(FirestorePaths.categoryDoc(categoryId));
    return CategoryModel.fromFirestore(doc);
  }

  Future<void> createCategory(CategoryModel category) async {
    await _firestoreService.setDocument(
      FirestorePaths.categoryDoc(category.id),
      category.toFirestore(),
    );
  }

  Future<void> updateCategory(String categoryId, CategoryModel category) async {
    await _firestoreService.updateDocument(
      FirestorePaths.categoryDoc(categoryId),
      category.toFirestore(),
    );
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestoreService
        .deleteDocument(FirestorePaths.categoryDoc(categoryId));
  }
}
