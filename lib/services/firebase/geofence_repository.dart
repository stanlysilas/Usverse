// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:usverse/models/geofence_model.dart';

// class GeofenceRepository {
//   final FirebaseFirestore firestore;

//   GeofenceRepository({FirebaseFirestore? firestore})
//     : firestore = firestore ?? FirebaseFirestore.instance;

//   Future<void> addGeofence({
//     required String relationshipId,
//     required Geofence geofence,
//   }) async {
//     await firestore
//         .collection('relationships')
//         .doc(relationshipId)
//         .collection('geofences')
//         .doc(geofence.id)
//         .set(geofence.toFirestore());
//   }

//   Stream<List<Geofence>> watchGeofences(String relationshipId) {
//     return firestore
//         .collection('relationships')
//         .doc(relationshipId)
//         .collection('geofences')
//         .snapshots()
//         .map(
//           (snapshot) => snapshot.docs
//               .map((d) => Geofence.fromFirestore(d.data()))
//               .toList(),
//         );
//   }
// }
