import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:usverse/services/firebase/location_repository.dart';
import 'package:usverse/models/location_model.dart';

class LocationStreamService {
  final LocationRepository repository;

  StreamSubscription<Position>? _subscription;

  double? _lastLat;
  double? _lastLng;

  LocationStreamService({required this.repository});

  void startSharing({required String relationshipId, required String userId}) {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 25,
    );

    _subscription = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) async {
          final lat = position.latitude;
          final lng = position.longitude;

          if (_shouldSend(lat, lng) == false) {
            return;
          }

          _lastLat = lat;
          _lastLng = lng;

          final location = UserLocation(
            userId: userId,
            latitude: lat,
            longitude: lng,
            timestamp: DateTime.now(),
          );

          await repository.updateLocation(
            userId: userId,
            relationshipId: relationshipId,
            latitude: location.latitude,
            longitude: location.longitude,
          );
        });
  }

  void stopSharing() {
    _subscription?.cancel();
    _subscription = null;
  }

  bool _shouldSend(double lat, double lng) {
    if (_lastLat == null || _lastLng == null) {
      return true;
    }

    final distance = Geolocator.distanceBetween(_lastLat!, _lastLng!, lat, lng);

    if (distance < 25) {
      return false;
    }

    return true;
  }
}
