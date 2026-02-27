import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/features/us/widgets/goals/shared_goals_card.dart';
import 'package:usverse/features/us/widgets/journey/journey_map_card.dart';
import 'package:usverse/features/us/widgets/relationship_details_card.dart';
import 'package:usverse/models/relationship_model.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_confirm_dialog.dart';
import 'package:usverse/shared/widgets/overlapping_avatars_card.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class UsScreen extends StatefulWidget {
  const UsScreen({super.key});

  @override
  State<UsScreen> createState() => _UsScreenState();
}

class _UsScreenState extends State<UsScreen> {
  final RelationshipService relationshipService = RelationshipService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: relationshipService.getCurrentUserRelationshipId(),
      builder: (context, idSnapshot) {
        if (!idSnapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final relationshipId = idSnapshot.data!;

        return StreamBuilder<Relationship?>(
          stream: relationshipService.watchRelationship(relationshipId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final relationship = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  relationship.relationshipName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              body: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;

                  final content = Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 16.0,
                    ),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _LeftColumn(
                                  relationship: relationship,
                                  relationshipId: relationshipId,
                                ),
                              ),

                              const SizedBox(width: 24),

                              Expanded(
                                child: _RightColumn(
                                  relationshipId: relationshipId,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              _LeftColumn(
                                relationship: relationship,
                                relationshipId: relationshipId,
                              ),
                              const SizedBox(height: 20),
                              _RightColumn(relationshipId: relationshipId),
                            ],
                          ),
                  );

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1920),
                      child: SingleChildScrollView(child: content),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final Relationship relationship;
  final String relationshipId;

  const _LeftColumn({required this.relationship, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final userService = UserProfileService();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        StreamBuilder(
          stream: userService.watchUsers([
            relationship.partnerA,
            relationship.partnerB,
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final users = snapshot.data!;

            final photoA = users.isNotEmpty ? users[0].photoUrl : null;

            final photoB = users.length > 1 ? users[1].photoUrl : null;

            return OverlappingAvatars(
              photoA: photoA,
              photoB: photoB,
              relationshipName: relationship.relationshipName,
            );
          },
        ),

        const SizedBox(height: 20),

        StreamBuilder<List<UserModel>>(
          stream: userService.watchUsers([
            relationship.partnerA,
            if (relationship.partnerB.isNotEmpty) relationship.partnerB,
          ]),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            return RelationshipDetailsCard(
              relationship: relationship,
              partners: snapshot.data!,
            );
          },
        ),
      ],
    );
  }
}

class _RightColumn extends StatelessWidget {
  final String relationshipId;

  const _RightColumn({required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    return Column(
      children: [
        JourneyMapCard(relationshipId: relationshipId),

        const SizedBox(height: 20),

        SharedGoalsCard(relationshipId: relationshipId),

        const SizedBox(height: 20),
        const Divider(),
        const SizedBox(height: 12),

        UsverseListTile(
          leading: const HugeIcon(icon: HugeIcons.strokeRoundedLogout01),
          title: 'Log out of Usverse',
          onTap: () => showDialog(
            context: context,
            builder: (_) => UsverseConfirmDialog(
              title: 'Are you sure you want to log out?',
              message: 'Log out of Usverse as ${auth.currentUser!.email}?',
              confirmText: 'Log out',
              onConfirm: () {
                RelationshipKeyProvider.instance.clear();
                auth.signOut();
              },
              onCancel: () => Navigator.pop(context),
            ),
          ),
          selected: false,
          extended: true,
        ),
      ],
    );
  }
}
