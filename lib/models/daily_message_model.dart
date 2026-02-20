import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMessage {
  final String id;
  final String relationshipId;
  final String senderId;
  final String message;
  final DateTime startAt;
  final DateTime expiresAt;
  final DateTime createdAt;
  final String senderDisplayName;
  final String senderPhotoUrl;

  DailyMessage({
    required this.id,
    required this.relationshipId,
    required this.senderId,
    required this.message,
    required this.startAt,
    required this.expiresAt,
    required this.createdAt,
    required this.senderDisplayName,
    required this.senderPhotoUrl,
  });

  factory DailyMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return DailyMessage(
      id: doc.id,
      relationshipId: data['relationshipId'],
      senderId: data['senderId'],
      message: data['message'],
      startAt: (data['startAt'] as Timestamp).toDate(),
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      senderDisplayName: data['senderDisplayName'] ?? '',
      senderPhotoUrl: data['senderPhotoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'relationshipId': relationshipId,
      'senderId': senderId,
      'message': message,
      'startAt': Timestamp.fromDate(startAt),
      'expiresAt': Timestamp.fromDate(expiresAt),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
