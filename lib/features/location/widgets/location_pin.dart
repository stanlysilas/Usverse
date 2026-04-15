// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:hugeicons/hugeicons.dart';

// class LocationPin extends StatelessWidget {
//   final String? avatarUrl;
//   final Color color;

//   const LocationPin({super.key, required this.avatarUrl, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;

//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Container(
//           width: 42,
//           height: 42,
//           decoration: BoxDecoration(
//             color: color,
//             shape: BoxShape.circle,
//             border: Border.all(color: colors.onSurface, width: 3),
//           ),
//           child: ClipOval(
//             child: avatarUrl != null && avatarUrl!.isNotEmpty
//                 ? CachedNetworkImage(
//                     imageUrl: avatarUrl!,
//                     fit: BoxFit.cover,
//                     placeholder: (_, _) => const Center(
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     ),
//                     errorWidget: (_, _, _) => Container(
//                       color: colors.primaryContainer,
//                       child: HugeIcon(icon: HugeIcons.strokeRoundedUser),
//                     ),
//                   )
//                 : Container(
//                     color: colors.primaryContainer,
//                     child: const HugeIcon(icon: HugeIcons.strokeRoundedUser),
//                   ),
//           ),
//         ),
//         Container(
//           width: 4,
//           height: 12,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(2),
//           ),
//         ),
//       ],
//     );
//   }
// }
