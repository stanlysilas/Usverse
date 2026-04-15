import 'package:geolocator/geolocator.dart';

class LocationPermissionService {
  Future<bool> requestPermission() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.always ||
          result == LocationPermission.whileInUse;
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }
}
