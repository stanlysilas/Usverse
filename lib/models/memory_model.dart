import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryModel {
  final String memoryId;
  final String relationshipId;
  final String createdBy;

  final String nonce;
  final String mac;

  final String mediaUrl;
  final String type;
  final String? caption;

  final DateTime memoryDate;
  final DateTime sortDate;

  final DateTime createdAt;
  final DateTime? updatedAt;

  final bool isDeleted;

  final bool isMilestone;
  final String? milestoneTitle;
  final String? icon;

  MemoryModel({
    required this.memoryId,
    required this.relationshipId,
    required this.createdBy,
    required this.nonce,
    required this.mac,
    required this.mediaUrl,
    required this.type,
    this.caption,
    required this.memoryDate,
    required this.sortDate,
    required this.createdAt,
    this.updatedAt,
    required this.isDeleted,
    required this.isMilestone,
    this.icon,
    this.milestoneTitle,
  });

  factory MemoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return MemoryModel(
      memoryId: doc.id,
      relationshipId: data['relationshipId'],
      createdBy: data['createdBy'],
      nonce: data['nonce'],
      mac: data['mac'],
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
      isMilestone: data['isMilestone'] ?? false,
      icon: data['icon'] ?? '❤️',
      milestoneTitle: data['milestoneTitle'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'relationshipId': relationshipId,
      'createdBy': createdBy,
      'mediaUrl': mediaUrl,
      'nonce': nonce,
      'mac': mac,
      'type': type,
      'caption': caption,
      'memoryDate': Timestamp.fromDate(memoryDate),
      'sortDate': Timestamp.fromDate(sortDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'isDeleted': isDeleted,
      'isMilestone': isMilestone,
      'icon': icon,
      'milestoneTitle': milestoneTitle,
    };
  }
}
