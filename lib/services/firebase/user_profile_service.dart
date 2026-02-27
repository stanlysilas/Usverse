import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/models/user_model.dart';

class UserProfileService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Stream<UserModel?> watchCurrentUser() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return watchUser(uid);
  }

  Stream<UserModel?> watchUser(String uid) {
    return _db.collection('users').doc(uid).snapshots().map((doc) {
      final data = doc.data();
      if (data == null) return null;
      return UserModel.fromMap(doc.id, data);
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();

    final data = doc.data();
    if (data == null) return null;

    return UserModel.fromMap(doc.id, data);
  }

  Stream<List<UserModel>> watchUsers(List<String> uids) {
    return _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: uids)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => UserModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }
}
