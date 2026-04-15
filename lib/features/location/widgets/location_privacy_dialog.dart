// import 'package:flutter/material.dart';

// class LocationPrivacyDialog extends StatelessWidget {
//   final VoidCallback onAccept;

//   const LocationPrivacyDialog({super.key, required this.onAccept});

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Location Sharing'),
//       content: const Text(
//         'Usverse allows partners to share live location. '
//         'Your coordinates are stored only to update your partner '
//         'and are never used for tracking, analytics, or advertising.',
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           child: const Text('Decline'),
//         ),
//         FilledButton(
//           onPressed: () {
//             Navigator.pop(context);
//             onAccept();
//           },
//           child: const Text('Accept'),
//         ),
//       ],
//     );
//   }
// }
