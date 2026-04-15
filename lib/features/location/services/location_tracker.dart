import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/services/firebase/location_repository.dart';

class LocationTracker {
  final LocationRepository repository = LocationRepository();

  StreamSubscription<Position>? _subscription;

  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> startTracking(String relationshipId) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    final granted = await requestPermission();

    if (!granted) {
      return;
    }

    const settings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _subscription?.cancel();

    _subscription = Geolocator.getPositionStream(locationSettings: settings)
        .listen((position) {
          repository.updateLocation(
            relationshipId: relationshipId,
            userId: user.uid,
            latitude: position.latitude,
            longitude: position.longitude,
          );
        });
  }

  void stopTracking() {
    _subscription?.cancel();
    _subscription = null;
  }
}
