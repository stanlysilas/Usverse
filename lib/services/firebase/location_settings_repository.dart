// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:usverse/models/location_settings_model.dart';

// class LocationSettingsRepository {
//   final FirebaseFirestore firestore;

//   LocationSettingsRepository({FirebaseFirestore? firestore})
//     : firestore = firestore ?? FirebaseFirestore.instance;

//   Future<void> updateConsent({
//     required String relationshipId,
//     required String userId,
//   }) async {
//     final ref = firestore
//         .collection('relationships')
//         .doc(relationshipId)
//         .collection('settings')
//         .doc('location');

//     await firestore.runTransaction((tx) async {
//       final snapshot = await tx.get(ref);

//       if (!snapshot.exists) {
//         tx.set(ref, {
//           'enabled': false,
//           'consentUsers': [userId],
//         });
//         return;
//       }

//       final data = snapshot.data()!;
//       final users = List<String>.from(data['consentUsers']);

//       if (!users.contains(userId)) {
//         users.add(userId);
//       }

//       final enabled = users.length >= 2;

//       tx.update(ref, {'consentUsers': users, 'enabled': enabled});
//     });
//   }

//   Stream<LocationSettings> watchSettings(String relationshipId) {
//     return firestore
//         .collection('relationships')
//         .doc(relationshipId)
//         .collection('settings')
//         .doc('location')
//         .snapshots()
//         .map((doc) => LocationSettings.fromFirestore(doc.data()!));
//   }
// }
