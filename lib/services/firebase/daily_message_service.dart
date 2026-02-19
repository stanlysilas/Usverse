import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/models/daily_message_model.dart';

class DailyMessageService {
  CollectionReference<Map<String, dynamic>> messagesRef(String relationshipId) {
    return FirebaseFirestore.instance
        .collection('relationships')
        .doc(relationshipId)
        .collection('dailyMessages');
  }

  Future<void> createMessage({
    required String relationshipId,
    required String text,
    required DateTime startAt,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;

    final expiresAt = startAt.add(const Duration(hours: 24));

    final doc = messagesRef(relationshipId).doc();

    await doc.set({
      'relationshipId': relationshipId,
      'createdBy': user.uid,
      'message': text,
      'startAt': Timestamp.fromDate(startAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DailyMessage?> watchActiveMessage(String relationshipId) {
    return messagesRef(
      relationshipId,
    ).orderBy('startAt', descending: true).limit(5).snapshots().map((snapshot) {
      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        final message = DailyMessage.fromFirestore(doc);

        if (message.startAt.isBefore(now) && message.expiresAt.isAfter(now)) {
          return message;
        }
      }

      return null;
    });
  }
}
