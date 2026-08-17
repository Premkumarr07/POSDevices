import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/device_model.dart';
import '../services/firestore_service.dart';
import '../constants/firestore_paths.dart';

class DeviceRepository {
  final FirestoreService _firestoreService;

  DeviceRepository({required FirestoreService firestoreService})
      : _firestoreService = firestoreService;

  Future<DeviceModel> getDevice(String deviceId) async {
    final doc =
        await _firestoreService.getDocument(FirestorePaths.deviceDoc(deviceId));
    return DeviceModel.fromFirestore(doc);
  }

  Stream<DeviceModel> watchDevice(String deviceId) {
    return _firestoreService
        .watchDocument(FirestorePaths.deviceDoc(deviceId))
        .map((doc) => DeviceModel.fromFirestore(doc));
  }

  Future<List<DeviceModel>> getDevicesByVenue(String venueId) async {
    final snapshot = await _firestoreService.getCollection(
      FirestorePaths.devicesCollection,
      queryBuilder: (query) => query.where('venueId', isEqualTo: venueId),
    );

    return snapshot.docs.map((doc) => DeviceModel.fromFirestore(doc)).toList();
  }

  Stream<List<DeviceModel>> watchDevicesByVenue(String venueId) {
    return _firestoreService
        .watchCollection(
          FirestorePaths.devicesCollection,
          queryBuilder: (query) => query.where('venueId', isEqualTo: venueId),
        )
        .map((snapshot) => snapshot.docs
            .map((doc) => DeviceModel.fromFirestore(doc))
            .toList());
  }

  Future<void> createDevice(DeviceModel device) async {
    await _firestoreService.setDocument(
      FirestorePaths.deviceDoc(device.id),
      device.toFirestore(),
    );
  }

  Future<void> updateDevice(String deviceId, DeviceModel device) async {
    await _firestoreService.updateDocument(
      FirestorePaths.deviceDoc(deviceId),
      device.toFirestore(),
    );
  }

  Future<void> updateDeviceStatus(String deviceId, String status) async {
    await _firestoreService.updateDocument(
      FirestorePaths.deviceDoc(deviceId),
      {
        'status': status,
        'lastSeenAt': Timestamp.now(),
      },
    );
  }

  Future<void> updateMenuVersion(String deviceId, int version) async {
    await _firestoreService.updateDocument(
      FirestorePaths.deviceDoc(deviceId),
      {
        'menuVersion': version,
        'lastSeenAt': Timestamp.now(),
      },
    );
  }

  Future<void> deleteDevice(String deviceId) async {
    await _firestoreService.deleteDocument(FirestorePaths.deviceDoc(deviceId));
  }
}
