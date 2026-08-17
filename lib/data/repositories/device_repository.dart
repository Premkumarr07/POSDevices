import '../local/local_app_store.dart';
import '../models/device_model.dart';

class DeviceRepository {
  DeviceRepository({LocalAppStore? store})
    : _store = store ?? LocalAppStore.instance {
    _store.seed();
  }

  final LocalAppStore _store;

  List<DeviceModel> get devices => List.unmodifiable(_store.devices);
}
