import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class OverlappingAvatars extends StatelessWidget {
  final String? photoA;
  final String? photoB;
  final String relationshipName;

  const OverlappingAvatars({
    super.key,
    required this.photoA,
    required this.photoB,
    required this.relationshipName,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedManWoman,
                      color: colors.onPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Us',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              Center(
                child: SizedBox(
                  width: 120,
                  height: 70,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(left: 0, child: avatar(photoA)),
                      Positioned(right: 0, child: avatar(photoB)),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                relationshipName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget avatar(String? url) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        color: Colors.grey.shade300,
      ),
      child: ClipOval(
        child: url == null
            ? const HugeIcon(icon: HugeIcons.strokeRoundedUser)
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, _, _) =>
                    const HugeIcon(icon: HugeIcons.strokeRoundedUser),
              ),
      ),
    );
  }
}
