import '../local/local_app_store.dart';
import '../models/venue_model.dart';

class VenueRepository {
  VenueRepository({LocalAppStore? store})
      : _store = store ?? LocalAppStore.instance {
    _store.seed();
  }

  final LocalAppStore _store;

  VenueModel? get currentVenue => _store.venue.value;
}
