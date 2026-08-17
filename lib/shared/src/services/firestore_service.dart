import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/firestore_paths.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firestore})
    : _db = firestore ?? FirebaseFirestore.instance;

  // Generic document operations
  Future<void> setDocument(
    String path,
    Map<String, dynamic> data, {
    bool merge = false,
  }) async {
    await _db.doc(path).set(data, SetOptions(merge: merge));
  }

  Future<void> updateDocument(String path, Map<String, dynamic> data) async {
    await _db.doc(path).update(data);
  }

  Future<void> deleteDocument(String path) async {
    await _db.doc(path).delete();
  }

  Future<DocumentSnapshot> getDocument(String path) async {
    return await _db.doc(path).get();
  }

  Stream<DocumentSnapshot> watchDocument(String path) {
    return _db.doc(path).snapshots();
  }

  Future<QuerySnapshot> getCollection(
    String collectionPath, {
    Query Function(Query)? queryBuilder,
  }) async {
    Query query = _db.collection(collectionPath);
    if (queryBuilder != n ull) {
      query = queryBuilder(query);
    }
    return await query.get();
  }

  Stream<QuerySnapshot> watchCollection(
    String collectionPath, {
    Query Function(Query)? queryBuilder,
  }) {
    Query query = _db.collection(collectionPath);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query.snapshots();
  }

  // Batch operations
  Future<void> batchWrite(Function(WriteBatch) operation) async {
    final batch = _db.batch();
    operation(batch);
    await batch.commit();
  }

  // Transaction support
  Future<T> runTransaction<T>(Future<T> Function(Transaction) operation) async {
    return await _db.runTransaction(operation);
  }
}
