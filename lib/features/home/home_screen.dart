import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/anniversary_countdown_card.dart';
import 'package:usverse/features/home/widgets/daily_message_section.dart';
import 'package:usverse/features/home/widgets/days_together_card.dart';
import 'package:usverse/features/messages/messages_screen.dart';
import 'package:usverse/features/us/widgets/relationship_details_card.dart';
import 'package:usverse/models/relationship_model.dart';
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
                title: Text("Hello ${relationship.relationshipName}"),
                actions: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.mail_rounded),
                    label: Text("Today's Messages"),
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
              body: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 800),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 24),

                          DaysTogetherCard(relationship: relationship),

                          const SizedBox(height: 16),

                          DailyMessageSection(relationshipId: relationshipId),

                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),

                          AnniversaryCountdownCard(relationship: relationship),

                          const SizedBox(height: 12),
                          const Divider(),
                          const SizedBox(height: 12),

                          RelationshipDetailsCard(
                            relationshipId: relationshipId,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
