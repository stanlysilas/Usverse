import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/core/crypto/crypto_service.dart';
import 'package:usverse/models/relationship_model.dart';

class RelationshipService {
  final relationshipKey = CryptoService.generateRelationshipKey();

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

      transaction.update(relationshipRef, {
        'partnerB': user.uid,
        'status': 'setup',
      });

      transaction.update(userRef, {'relationshipId': relationshipRef.id});

      return null;
    });
  }

  Future<(String code, String relationshipId)> createInviteCode() async {
    final user = auth.currentUser!;
    final userRef = db.collection('users').doc(user.uid);

    final userSnap = await userRef.get();
    final existingRelationship = userSnap.data()?['relationshipId'];

    if (existingRelationship != null) {
      return ('', '');
    }

    final code = await generateInviteCode();

    final relationshipRef = await db.collection('relationships').add({
      'partnerA': user.uid,
      'partnerB': null,
      'inviteCode': code,
      'status': 'waiting',
      'createdAt': FieldValue.serverTimestamp(),

      'crypto': {
        'key': relationshipKey,
        'version': 1,
        'createdAt': FieldValue.serverTimestamp(),
      },
    });

    return (code, relationshipRef.id);
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

  Future<void> saveRelationshipDetails(
    String relationshipId,
    String relationshipName,
    DateTime anniversaryDate,
    String? partnerANickname,
    String? partnerBNickname,
  ) async {
    final user = auth.currentUser!;

    final doc = await db.collection('relationships').doc(relationshipId).get();

    final partnerBUid = doc.data()?['partnerB'];

    await db.collection('relationships').doc(relationshipId).update({
      'relationshipName': relationshipName,
      'anniversaryDate': anniversaryDate,
      'nicknames': {user.uid: partnerANickname, partnerBUid: partnerBNickname},
      'status': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getCurrentUserRelationshipId() async {
    final user = auth.currentUser;

    if (user == null) return null;

    final doc = await db.collection('users').doc(user.uid).get();

    final data = doc.data();

    return data!['relationshipId'];
  }

  Future<Relationship?> fetchRelationship(String relationshipId) async {
    final doc = await db.collection('relationships').doc(relationshipId).get();

    if (!doc.exists) return null;

    return Relationship.fromFirestore(doc);
  }

  Stream<Relationship?> watchRelationship(String relationshipId) {
    return db
        .collection('relationships')
        .doc(relationshipId)
        .snapshots()
        .asyncMap((doc) async {
          if (!doc.exists) return null;

          final data = doc.data()!;

          if (data['crypto'] == null) {
            await ensureCryptoSetup(relationshipId);

            final updated = await db
                .collection('relationships')
                .doc(relationshipId)
                .get();
            return Relationship.fromFirestore(updated);
          }

          return Relationship.fromFirestore(doc);
        });
  }

  Future<void> updateRelationshipDetails({
    required String relationshipId,
    required String relationshipName,
    required DateTime anniversaryDate,
    required Map<String, dynamic> nicknames,
  }) async {
    await db.collection('relationships').doc(relationshipId).update({
      'relationshipName': relationshipName.trim(),
      'anniversaryDate': anniversaryDate,
      'nicknames': nicknames,
      'status': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> attachUserToRelationship(String relationshipId) async {
    final user = auth.currentUser!;

    await db.collection('users').doc(user.uid).update({
      'relationshipId': relationshipId,
    });
  }

  Future<void> deleteRelationship(String relationshipId) async {
    final user = auth.currentUser!;

    await db.collection('relationships').doc(relationshipId).delete();

    await db.collection('users').doc(user.uid).update({'relationshipId': null});
  }

  /// This method ensures that the crypto setup is properly done and all
  /// existing relationships are migrated to include this crypto [Map] in
  /// [FirebaseFirestore].
  Future<void> ensureCryptoSetup(String relationshipId) async {
    final ref = db.collection('relationships').doc(relationshipId);

    final snap = await ref.get();

    if (!snap.exists) return;

    final data = snap.data()!;

    if (data['crypto'] != null) return;

    await ref.update({
      'crypto': {
        'key': relationshipKey,
        'version': 1,
        'createdAt': FieldValue.serverTimestamp(),
      },
    });
  }
}
