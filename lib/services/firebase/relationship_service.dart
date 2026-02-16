import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RelationshipService {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  Future<String?> joinWithInviteCode(String inviteCode) async {
    final user = auth.currentUser!;
    final userRef = db.collection('users').doc(user.uid);

    return await db.runTransaction((transaction) async {
      final userSnap = await transaction.get(userRef);

      final existingRelationship = userSnap.data()?['relationshipId'];

      if (existingRelationship != null) {
        return "ALREADY_IN_RELATIONSHIP";
      }

      final query = await db
          .collection('relationships')
          .where('inviteCode', isEqualTo: inviteCode)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return "INVALID_CODE";
      }

      final relationshipDoc = query.docs.first;
      final relationshipRef = relationshipDoc.reference;
      final data = relationshipDoc.data();

      final partnerA = data['partnerA'];
      final partnerB = data['partnerB'];

      if (partnerA == user.uid) {
        return "SELF_JOIN";
      }

      if (partnerB != null) {
        return "ALREADY_CONNECTED";
      }

      transaction.update(relationshipRef, {'partnerB': user.uid});

      transaction.update(userRef, {'relationshipId': relationshipRef.id});

      return null;
    });
  }

  Future<String?> createInviteCode() async {
    final user = auth.currentUser!;
    final userRef = db.collection('users').doc(user.uid);

    final userSnap = await userRef.get();
    final existingRelationship = userSnap.data()?['relationshipId'];

    if (existingRelationship != null) {
      return null;
    }

    final code = await generateInviteCode();

    final relationshipRef = await db.collection('relationships').add({
      'partnerA': user.uid,
      'partnerB': null,
      'inviteCode': code,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await userRef.update({'relationshipId': relationshipRef.id});

    return code;
  }

  Future<String> generateInviteCode() async {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789';
    final random = Random();

    while (true) {
      final code = List.generate(
        6,
        (_) => chars[random.nextInt(chars.length)],
      ).join();

      final query = await db
          .collection('relationships')
          .where('inviteCode', isEqualTo: code)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return code;
      }
    }
  }
}
