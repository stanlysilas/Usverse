import 'package:cloud_firestore/cloud_firestore.dart';

class UserLocation {
  final String userId;
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  const UserLocation({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory UserLocation.fromFirestore(Map<String, dynamic> map) {
    return UserLocation(
      userId: map['userId'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }
}
