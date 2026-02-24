import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RelationshipKeyProvider {
  RelationshipKeyProvider._();

  static final RelationshipKeyProvider instance = RelationshipKeyProvider._();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Uint8List? _cachedKey;
  String? _relationshipId;

  bool get hasKey => _cachedKey != null;

  Future<Uint8List> getKey() async {
    if (_cachedKey != null) {
      return _cachedKey!;
    }

    await _loadKey();

    if (_cachedKey == null) {
      throw Exception('Relationship key not available');
    }

    return _cachedKey!;
  }

  void clear() {
    _cachedKey = null;
    _relationshipId = null;
  }

  Future<void> _loadKey() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    final userDoc = await _db.collection('users').doc(user.uid).get();

    final relationshipId = userDoc.data()?['relationshipId'];

    if (relationshipId == null) {
      throw Exception('User has no relationship');
    }

    if (_relationshipId == relationshipId && _cachedKey != null) {
      return;
    }

    _relationshipId = relationshipId;

    final relDoc = await _db
        .collection('relationships')
        .doc(relationshipId)
        .get();

    final crypto = relDoc.data()?['crypto'];

    if (crypto == null) {
      throw Exception('Crypto not initialized');
    }

    final base64Key = crypto['key'];

    _cachedKey = base64Decode(base64Key);
  }
}
