import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/models/location_model.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';

class LocationInfoCard extends StatelessWidget {
  final UserLocation location;
  final String? avatarUrl;
  final bool expanded;

  const LocationInfoCard({
    super.key,
    required this.location,
    required this.avatarUrl,
    this.expanded = false,
  });

  String lastUpdated() {
    final diff = DateTime.now().difference(location.timestamp);

    if (diff.inSeconds < 60) {
      return '${diff.inSeconds}s ago';
    }

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }

    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }

    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final profileService = UserProfileService();

    return StreamBuilder<UserModel?>(
      stream: profileService.watchUser(location.userId),
      builder: (context, snapshot) {
        final user = snapshot.data;

        return Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(12),

          child: Container(
            width: expanded ? double.infinity : 220,

            padding: const EdgeInsets.all(12),

            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              children: [
                ClipOval(
                  child: avatarUrl != null
                      ? CachedNetworkImage(
                          imageUrl: avatarUrl!,
                          fit: BoxFit.cover,
                          scale: 3,
                          placeholder: (_, _) => const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          errorWidget: (_, _, _) =>
                              const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                        )
                      : null,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    mainAxisSize: MainAxisSize.min,

                    children: [
                      Text(
                        user?.displayName ?? 'User',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: colors.onSurface,
                        ),
                      ),

                      Text(
                        'Updated ${lastUpdated()}',
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
