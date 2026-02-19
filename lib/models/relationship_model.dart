import 'package:cloud_firestore/cloud_firestore.dart';

class Relationship {
  final String id;

  final String partnerA;
  final String partnerB;

  final String status;

  final String relationshipName;
  final DateTime anniversaryDate;

  final Map<String, dynamic> nicknames;

  final DateTime createdAt;
  final DateTime updatedAt;

  Relationship({
    required this.id,
    required this.partnerA,
    required this.partnerB,
    required this.status,
    required this.relationshipName,
    required this.anniversaryDate,
    required this.nicknames,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Relationship.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Relationship(
      id: doc.id,
      partnerA: data['partnerA'],
      partnerB: data['partnerB'],
      status: data['status'],

      relationshipName: data['relationshipName'] ?? '',

      anniversaryDate: (data['anniversaryDate'] as Timestamp).toDate(),

      nicknames: Map<String, dynamic>.from(data['nicknames'] ?? {}),

      createdAt: (data['createdAt'] as Timestamp).toDate(),

      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'partnerA': partnerA,
      'partnerB': partnerB,
      'status': status,
      'relationshipName': relationshipName,
      'anniversaryDate': anniversaryDate,
      'nicknames': nicknames,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
