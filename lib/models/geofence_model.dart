// class Geofence {
//   final String id;
//   final String name;
//   final double latitude;
//   final double longitude;
//   final double radius;
//   final String createdBy;

//   const Geofence({
//     required this.id,
//     required this.name,
//     required this.latitude,
//     required this.longitude,
//     required this.radius,
//     required this.createdBy,
//   });

//   Map<String, dynamic> toFirestore() {
//     return {
//       'id': id,
//       'name': name,
//       'latitude': latitude,
//       'longitude': longitude,
//       'radius': radius,
//       'createdBy': createdBy,
//     };
//   }

//   factory Geofence.fromFirestore(Map<String, dynamic> map) {
//     return Geofence(
//       id: map['id'],
//       name: map['name'],
//       latitude: map['latitude'],
//       longitude: map['longitude'],
//       radius: map['radius'],
//       createdBy: map['createdBy'],
//     );
//   }
// }
