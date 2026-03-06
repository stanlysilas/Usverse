import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:usverse/features/location/widgets/interactive_location_pin.dart';
import 'package:usverse/models/location_model.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';

class LocationMap extends StatefulWidget {
  final LatLng center;
  final List<UserLocation> locations;
  final Map<String, String> avatars;

  const LocationMap({
    super.key,
    required this.center,
    required this.locations,
    required this.avatars,
  });

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap>
    with TickerProviderStateMixin {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  late final AnimatedMapController animatedMapController;
  final UserProfileService profileService = UserProfileService();

  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    animatedMapController = AnimatedMapController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusPartner(widget.locations.firstWhere((l) => l.userId != uid));
    });
  }

  void focusUser(double latitude, double longitude) {
    final point = LatLng(latitude, longitude);

    animatedMapController.animateTo(
      dest: point,
      zoom: animatedMapController.mapController.camera.zoom,
    );
  }

  void focusCurrentUser() {
    if (uid == null) return;

    final location = widget.locations.firstWhere(
      (l) => l.userId == uid,
      orElse: () => widget.locations[0],
    );

    animatedMapController.animateTo(
      dest: LatLng(location.latitude, location.longitude),
      zoom: animatedMapController.mapController.camera.zoom,
    );
  }

  void focusPartner(UserLocation location) {
    if (isAnimating) return;

    isAnimating = true;

    animatedMapController
        .animateTo(
          dest: LatLng(location.latitude, location.longitude),
          zoom: animatedMapController.mapController.camera.zoom,
        )
        .whenComplete(() {
          isAnimating = false;
        });
  }

  String lastUpdated(DateTime timestamp) {
    final diff = DateTime.now().difference(timestamp);

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
  void dispose() {
    animatedMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tileUrl =
        'https://api.maptiler.com/maps/streets-v4/{z}/{x}/{y}.png?key=i3icjtzkiRlCjDGvneD3';

    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    final partner = widget.locations.firstWhere(
      (l) => l.userId != currentUid,
      orElse: () => widget.locations[0],
    );

    final partnerAvatar = widget.avatars[partner.userId];

    return Stack(
      children: [
        FlutterMap(
          mapController: animatedMapController.mapController,

          options: MapOptions(
            initialCenter: widget.center,
            initialZoom: 13,
            minZoom: 3,
            maxZoom: 20,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),

          children: [
            TileLayer(
              urlTemplate: tileUrl,
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.usverse.app',
              maxZoom: 20,
              keepBuffer: 2,
              tileProvider: NetworkTileProvider(),
              tileDimension: 512,
              zoomOffset: -1,
            ),

            MarkerLayer(
              markers: [
                for (int i = 0; i < widget.locations.length; i++)
                  Marker(
                    width: 60,
                    height: 70,
                    point: LatLng(
                      widget.locations[i].latitude + (i * 0.00003),
                      widget.locations[i].longitude + (i * 0.00003),
                    ),
                    child: InteractiveLocationPin(
                      avatarUrl: widget.avatars[widget.locations[i].userId],
                      location: widget.locations[i],
                    ),
                  ),
              ],
            ),
          ],
        ),

        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    onTap: () {
                      final zoom =
                          animatedMapController.mapController.camera.zoom + 1;
                      animatedMapController.animateTo(
                        dest: animatedMapController.mapController.camera.center,
                        zoom: zoom,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
                    ),
                  ),

                  InkWell(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    ),
                    onTap: () {
                      final zoom =
                          animatedMapController.mapController.camera.zoom - 1;
                      animatedMapController.animateTo(
                        dest: animatedMapController.mapController.camera.center,
                        zoom: zoom,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      child: HugeIcon(icon: HugeIcons.strokeRoundedMinusSign),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 90,
          left: 160,
          right: 160,

          child: StreamBuilder<UserModel?>(
            stream: profileService.watchUser(partner.userId),
            builder: (context, snapshot) {
              final user = snapshot.data;

              return GestureDetector(
                onTap: () {
                  focusPartner(partner);
                },
                child: Card(
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: partnerAvatar != null
                              ? CachedNetworkImage(
                                  imageUrl: partnerAvatar,
                                  fit: BoxFit.cover,
                                  scale: 3,
                                  placeholder: (_, _) => const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  errorWidget: (_, _, _) => const HugeIcon(
                                    icon: HugeIcons.strokeRoundedManWoman,
                                  ),
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
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Updated ${lastUpdated(partner.timestamp)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        const HugeIcon(
                          icon: HugeIcons.strokeRoundedArrowRight01,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        Positioned(
          bottom: 90,
          right: 24,
          child: FloatingActionButton(
            onPressed: focusCurrentUser,
            tooltip: 'Current Location',
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            mini: true,
            child: const HugeIcon(icon: HugeIcons.strokeRoundedLocation01),
          ),
        ),
      ],
    );
  }
}
