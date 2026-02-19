import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryModel {
  final String id;
  final String relationshipId;
  final String createdBy;

  final String mediaUrl;
  final String? thumbnailUrl;
  final String type;
  final String? caption;

  final DateTime memoryDate;
  final DateTime sortDate;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final bool isDeleted;

  MemoryModel({
    required this.id,
    required this.relationshipId,
    required this.createdBy,
    required this.mediaUrl,
    this.thumbnailUrl,
    required this.type,
    this.caption,
    required this.memoryDate,
    required this.sortDate,
    required this.createdAt,
    this.updatedAt,
    required this.isDeleted,
  });

  factory MemoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MemoryModel(
      id: doc.id,
      relationshipId: data['relationshipId'],
      createdBy: data['createdBy'],
      mediaUrl: data['mediaUrl'],
      type: data['type'],
      caption: data['caption'],
      memoryDate: (data['memoryDate'] as Timestamp).toDate(),
      sortDate: (data['sortDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'relationshipId': relationshipId,
      'createdBy': createdBy,
      'mediaUrl': mediaUrl,
      'thumbnailUrl': thumbnailUrl,
      'type': type,
      'caption': caption,
      'memoryDate': Timestamp.fromDate(memoryDate),
      'sortDate': Timestamp.fromDate(sortDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isDeleted': isDeleted,
    };
  }
}
