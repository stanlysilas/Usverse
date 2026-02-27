import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:usverse/models/goals_model.dart';

class GoalsService {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> goalsRef(String relationshipId) {
    return _db
        .collection('relationships')
        .doc(relationshipId)
        .collection('goals');
  }

  Stream<List<GoalModel>> watchGoals(String relationshipId) {
    return goalsRef(relationshipId)
        .where('isArchived', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => GoalModel.fromFirestore(doc)).toList(),
        );
  }

  Future<void> createGoal({
    required String relationshipId,
    required String title,
    required String icon,
    String? description,
    DateTime? targetDate,
  }) async {
    final doc = goalsRef(relationshipId).doc();

    await doc.set({
      'relationshipId': relationshipId,
      'goalId': doc.id,
      'title': title,
      'icon': icon,
      'description': description,
      'status': 'planned',
      'progress': 0,
      'createdBy': _auth.currentUser!.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'targetDate': targetDate == null ? null : Timestamp.fromDate(targetDate),
      'isArchived': false,
    });
  }

  Future<void> updateProgress({
    required String relationshipId,
    required String goalId,
    required int progress,
  }) async {
    await goalsRef(relationshipId).doc(goalId).update({
      'progress': progress,
      'status': progress >= 100 ? 'completed' : 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> archiveGoal(String relationshipId, String goalId) async {
    await goalsRef(relationshipId).doc(goalId).update({
      'isArchived': true,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
