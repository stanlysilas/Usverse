import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/anniversary_countdown_card.dart';
import 'package:usverse/features/home/widgets/daily_message_section.dart';
import 'package:usverse/features/home/widgets/days_together_card.dart';
import 'package:usverse/features/memories/widgets/memories_timeline.dart';
import 'package:usverse/features/messages/messages_screen.dart';
import 'package:usverse/features/us/widgets/relationship_details_card.dart';
import 'package:usverse/models/memory_model.dart';
import 'package:usverse/models/relationship_model.dart';
import 'package:usverse/services/firebase/memories_service.dart';
import 'package:usverse/services/firebase/relationship_service.dart';

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
                actions: [
                  IconButton(
                    icon: Icon(Icons.mail_rounded),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              MessagesScreen(relationshipId: relationship.id),
                        ),
                      );
                    },
                  ),
                ],
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
                                flex: 2,
                                child: LeftColumn(
                                  relationship: relationship,
                                  relationshipId: relationshipId,
                                ),
                              ),

                              const SizedBox(width: 24),

                              Expanded(
                                flex: 1,
                                child: RightColumn(
                                  relationshipId: relationshipId,
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              LeftColumn(
                                relationship: relationship,
                                relationshipId: relationshipId,
                              ),
                              RightColumn(relationshipId: relationshipId),
                            ],
                          ),
                  );

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 1200),
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

class LeftColumn extends StatelessWidget {
  final Relationship relationship;
  final String relationshipId;

  const LeftColumn({
    super.key,
    required this.relationship,
    required this.relationshipId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),

        DaysTogetherCard(relationship: relationship),

        const SizedBox(height: 20),

        AnniversaryCountdownCard(relationship: relationship),

        const SizedBox(height: 20),

        RelationshipDetailsCard(relationshipId: relationshipId),
      ],
    );
  }
}

class RightColumn extends StatelessWidget {
  final String relationshipId;

  const RightColumn({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final memoriesService = MemoriesService();

    return Column(
      children: [
        DailyMessageSection(relationshipId: relationshipId),

        const SizedBox(height: 20),

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Icon(
                        Icons.timeline_rounded,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      "Memory Timeline",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const Divider(),
                const SizedBox(height: 12),

                SizedBox(
                  height: 500,
                  child: StreamBuilder<List<MemoryModel>>(
                    stream: memoriesService.watchMemories(relationshipId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        debugPrint(snapshot.error.toString());
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      final memories = snapshot.data!;

                      if (memories.isEmpty) {
                        return const Center(child: Text('No memories yet ❤️'));
                      }

                      return MemoriesTimeline(memories: memories);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
