import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:usverse/services/firebase/location_repository.dart';
import 'package:usverse/features/location/services/location_tracker.dart';
import 'package:usverse/features/location/widgets/location_map.dart';
import 'package:usverse/models/location_model.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';

class LocationMapScreen extends StatefulWidget {
  final String relationshipId;

  const LocationMapScreen({super.key, required this.relationshipId});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  final relationshipService = RelationshipService();
  final locationRepository = LocationRepository();
  final profileService = UserProfileService();
  final tracker = LocationTracker();

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    final allowed = await tracker.requestPermission();

    if (allowed) {
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          tracker.startTracking(widget.relationshipId);
        } else {
          tracker.stopTracking();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Location', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: relationshipService.fetchRelationship(widget.relationshipId),
        builder: (context, partnerSnapshot) {
          if (!partnerSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = partnerSnapshot.data!;
          final partnerA = data.partnerA;
          final partnerB = data.partnerB;

          return StreamBuilder<List<UserModel>>(
            stream: profileService.watchUsers([partnerA, partnerB]),
            builder: (context, userSnapshot) {
              if (!userSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final users = userSnapshot.data!;

              final avatars = {
                for (final user in users) user.uid: user.photoUrl ?? '',
              };

              return StreamBuilder<List<UserLocation>>(
                stream: locationRepository.watchLocations(
                  widget.relationshipId,
                ),
                builder: (context, locationSnapshot) {
                  if (locationSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final locations = locationSnapshot.data ?? [];

                  if (locations.isEmpty) {
                    return const Center(child: Text('No active locations'));
                  }

                  final center = LatLng(
                    locations.first.latitude,
                    locations.first.longitude,
                  );

                  return LocationMap(
                    center: center,
                    locations: locations,
                    avatars: avatars,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
