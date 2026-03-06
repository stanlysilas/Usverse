import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:usverse/models/location_model.dart';

class LocationRepository {
  final FirebaseFirestore firestore;

  LocationRepository({FirebaseFirestore? firestore})
    : firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> updateLocation({
    required String relationshipId,
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    await firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('live_locations')
        .doc(userId)
        .set({
          'userId': userId,
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<UserLocation>> watchLocations(String relationshipId) {
    return firestore
        .collection('relationships')
        .doc(relationshipId)
        .collection('live_locations')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserLocation.fromFirestore(doc.data()))
              .toList(),
        );
  }
}
