import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/models/memory_model.dart';

class MemoriesService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  User get currentUser => auth.currentUser!;

  CollectionReference<Map<String, dynamic>> memoriesRef(String relationshipId) {
    return db
        .collection('relationships')
        .doc(relationshipId)
        .collection('memories');
  }

  Future<void> createEncryptedMemory({
    required String relationshipId,
    required String mediaUrl,
    required String nonce,
    required String mac,
    required String caption,
    required DateTime memoryDate,
    required DateTime sortDate,
    bool isMilestone = false,
    String? icon = '❤️',
    String? milestoneTitle,
  }) async {
    final docRef = memoriesRef(relationshipId).doc();

    await docRef.set({
      'relationshipId': relationshipId,
      'memoryId': docRef.id,
      'createdBy': currentUser.uid,
      'mediaUrl': mediaUrl,
      'nonce': nonce,
      'mac': mac,
      'type': 'image',
      'caption': caption,
      'memoryDate': Timestamp.fromDate(memoryDate),
      'sortDate': Timestamp.fromDate(sortDate),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': null,
      'isDeleted': false,
      'isMilestone': isMilestone,
      'icon': icon,
      'milestoneTitle': milestoneTitle,
    });
  }

  Stream<List<MemoryModel>> watchMemories(String relationshipId) {
    return memoriesRef(relationshipId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('sortDate', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MemoryModel.fromFirestore(doc))
              .toList(),
        );
  }

  Future<List<MemoryModel>> fetchMemories(
    String relationshipId, {
    DocumentSnapshot? lastDoc,
    int limit = 20,
  }) async {
    Query query = memoriesRef(relationshipId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('sortDate', descending: true)
        .limit(limit);

    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) => MemoryModel.fromFirestore(doc)).toList();
  }

  Future<void> deleteMemory(String relationshipId, String memoryId) async {
    await memoriesRef(relationshipId).doc(memoryId).update({
      'isDeleted': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateMemory({
    required String relationshipId,
    required String memoryId,
    String? caption,
    DateTime? memoryDate,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };

    if (caption != null) updates['caption'] = caption;
    if (memoryDate != null) {
      updates['memoryDate'] = Timestamp.fromDate(memoryDate);
      updates['sortDate'] = Timestamp.fromDate(memoryDate);
    }

    await memoriesRef(relationshipId).doc(memoryId).update(updates);
  }

  Stream<List<MemoryModel>> watchMilestones(String relationshipId) {
    return memoriesRef(relationshipId)
        .where('isDeleted', isEqualTo: false)
        .where('isMilestone', isEqualTo: true)
        .orderBy('sortDate')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MemoryModel.fromFirestore(doc))
              .toList(),
        );
  }
}
