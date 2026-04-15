// class LocationSettings {
//   final bool enabled;
//   final List<String> consentUsers;

//   const LocationSettings({required this.enabled, required this.consentUsers});

//   Map<String, dynamic> toFirestore() {
//     return {'enabled': enabled, 'consentUsers': consentUsers};
//   }

//   factory LocationSettings.fromFirestore(Map<String, dynamic> map) {
//     return LocationSettings(
//       enabled: map['enabled'],
//       consentUsers: List<String>.from(map['consentUsers']),
//     );
//   }
// }
