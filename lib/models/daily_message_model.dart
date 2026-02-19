import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMessage {
  final String id;
  final String relationshipId;
  final String createdBy;
  final String message;
  final DateTime startAt;
  final DateTime expiresAt;
  final DateTime createdAt;

  DailyMessage({
    required this.id,
    required this.relationshipId,
    required this.createdBy,
    required this.message,
    required this.startAt,
    required this.expiresAt,
    required this.createdAt,
  });

  factory DailyMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DailyMessage(
      id: doc.id,
      relationshipId: data['relationshipId'],
      createdBy: data['createdBy'],
      message: data['message'],
      startAt: (data['startAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'relationshipId': relationshipId,
      'createdBy': createdBy,
      'message': message,
      'startAt': Timestamp.fromDate(startAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
