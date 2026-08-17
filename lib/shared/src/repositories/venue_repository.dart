import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/venue_model.dart';
import '../services/firestore_service.dart';
import '../constants/firestore_paths.dart';

class VenueRepository {
  final FirestoreService _firestoreService;

  VenueRepository({required FirestoreService firestoreService})
    : _firestoreService = firestoreService;

  Future<VenueModel> getVenue(String venueId) async {
    final doc = await _firestoreService.getDocument(
      FirestorePaths.venueDoc(venueId),
    );
    return VenueModel.fromFirestore(doc);
  }

  Stream<VenueModel> watchVenue(String venueId) {
    return _firestoreService
        .watchDocument(FirestorePaths.venueDoc(venueId))
        .map((doc) => VenueModel.fromFirestore(doc));
  }

  Future<List<VenueModel>> getAllVenues() async {
    final snapshot = await _firestoreService.getCollection(
      FirestorePaths.venuesCollection,
      queryBuilder: (query) => query.where('active', isEqualTo: true),
    );

    return snapshot.docs.map((doc) => VenueModel.fromFirestore(doc)).toList();
  }

  Future<void> createVenue(VenueModel venue) async {
    await _firestoreService.setDocument(
      FirestorePaths.venueDoc(venue.id),
      venue.toFirestore(),
    );
  }

  Future<void> updateVenue(String venueId, Map<String, dynamic> data) async {
    await _firestoreService.updateDocument(FirestorePaths.venueDoc(venueId), {
      ...data,
      'updatedAt': Timestamp.now(),
    });
  }

  Future<void> deleteVenue(String venueId) async {
    await _firestoreService.deleteDocument(FirestorePaths.venueDoc(venueId));
  }
}
