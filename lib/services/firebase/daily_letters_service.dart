import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/models/daily_letter_model.dart';

class DailyLettersService {
  CollectionReference<Map<String, dynamic>> lettersRef(String relationshipId) {
    return FirebaseFirestore.instance
        .collection('relationships')
        .doc(relationshipId)
        .collection('dailyMessages');
  }

  Future<void> createLetter({
    required String relationshipId,
    required String text,
    required DateTime startAt,
    required String userDisplayName,
    required String userPhotoUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser!;

    final expiresAt = startAt.add(const Duration(hours: 24));

    final doc = lettersRef(relationshipId).doc();

    await doc.set({
      'relationshipId': relationshipId,
      'message': text,
      'startAt': startAt,
      'expiresAt': expiresAt,

      'senderId': user.uid,
      'senderDisplayName': userDisplayName,
      'senderPhotoUrl': userPhotoUrl,

      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<DailyLetter?> watchActiveLetters(String relationshipId) {
    return lettersRef(
      relationshipId,
    ).orderBy('startAt', descending: true).limit(5).snapshots().map((snapshot) {
      final now = DateTime.now();

      for (final doc in snapshot.docs) {
        final message = DailyLetter.fromFirestore(doc);

        if (message.startAt.isBefore(now) && message.expiresAt.isAfter(now)) {
          return message;
        }
      }

      return null;
    });
  }

  Stream<List<DailyLetter>> watchLettersForDate(
    String relationshipId,
    DateTime date,
  ) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return lettersRef(relationshipId)
        .where(
          'startAt',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay),
        )
        .where('startAt', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('startAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => DailyLetter.fromFirestore(doc))
              .toList(),
        );
  }

  Future<void> deleteLetter(String letterId, String relationshipId) async {
    await lettersRef(relationshipId).doc(letterId).delete();
  }
}
