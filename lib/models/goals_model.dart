import 'package:cloud_firestore/cloud_firestore.dart';

class GoalModel {
  final String relationshipId;
  final String goalId;
  final String title;
  final String icon;
  final String? description;
  final String status;
  final int progress;
  final String createdBy;
  final DateTime? targetDate;
  final bool isArchived;

  GoalModel({
    required this.goalId,
    required this.title,
    required this.icon,
    required this.status,
    required this.progress,
    required this.createdBy,
    required this.isArchived,
    this.description,
    this.targetDate,
    required this.relationshipId,
  });

  factory GoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return GoalModel(
      relationshipId: data['relationshipId'],
      goalId: data['goalId'],
      title: data['title'],
      icon: data['icon'],
      description: data['description'],
      status: data['status'],
      progress: data['progress'],
      createdBy: data['createdBy'],
      isArchived: data['isArchived'] ?? false,
      targetDate: (data['targetDate'] as Timestamp?)?.toDate(),
    );
  }
}
