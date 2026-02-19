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

  Future<void> createMemory(MemoryModel memory) async {
    final docRef = memoriesRef(memory.relationshipId).doc();

    final newMemory = MemoryModel(
      id: docRef.id,
      relationshipId: memory.relationshipId,
      createdBy: currentUser.uid,
      mediaUrl: memory.mediaUrl,
      thumbnailUrl: memory.thumbnailUrl,
      type: memory.type,
      caption: memory.caption,
      memoryDate: memory.memoryDate,
      sortDate: memory.sortDate,
      createdAt: DateTime.now(),
      updatedAt: null,
      isDeleted: false,
    );

    await docRef.set(newMemory.toFirestore());
  }

  Stream<List<MemoryModel>> watchMemories(String relationshipId) {
    return memoriesRef(relationshipId)
        .where('isDeleted', isEqualTo: false)
        .orderBy('sortDate', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => MemoryModel.fromFirestore(doc))
              .toList();
        });
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
}
