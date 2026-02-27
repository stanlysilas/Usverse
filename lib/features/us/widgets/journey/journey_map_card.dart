import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/features/us/widgets/journey/journey_timeline.dart';
import 'package:usverse/services/firebase/memories_service.dart';
import 'package:usverse/models/memory_model.dart';
import 'package:usverse/shared/widgets/app_empty_state.dart';

class JourneyMapCard extends StatelessWidget {
  final String relationshipId;

  const JourneyMapCard({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final service = MemoriesService();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedRoute02,
                    color: colors.onPrimary,
                  ),
                ),
                const Text(
                  'Our Journey',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: StreamBuilder<List<MemoryModel>>(
                stream: service.watchMilestones(relationshipId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    debugPrint(snapshot.error.toString());
                    return Center(
                      child: Text('Error: ${snapshot.error.toString()}'),
                    );
                  }

                  final milestones = snapshot.data!;

                  if (milestones.isEmpty) {
                    return AppEmptyState(
                      icon: '🧭',
                      title: 'Your journey begins here',
                      subtitle: 'Mark meaningful moments as milestones',
                    );
                  }

                  return JourneyTimeline(milestones: milestones);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
