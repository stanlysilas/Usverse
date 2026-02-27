import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/anniversary_countdown_card.dart';
import 'package:usverse/features/home/widgets/daily_message_section.dart';
import 'package:usverse/features/home/widgets/days_together_card.dart';
import 'package:usverse/features/home/widgets/memory_timeline_card.dart';
import 'package:usverse/features/us/widgets/relationship_details_card.dart';
import 'package:usverse/models/relationship_model.dart';
import 'package:usverse/models/user_model.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/services/firebase/user_profile_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Hello "),
                    Text(
                      relationship.relationshipName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DaysTogetherCard(relationship: relationship),

        const SizedBox(height: 20),

        AnniversaryCountdownCard(relationship: relationship),

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
    return Column(
      children: [
        DailyMessageSection(relationshipId: relationshipId),

        const SizedBox(height: 20),

        MemoryTimelineCard(relationshipId: relationshipId),
      ],
    );
  }
}
