import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/features/memories/widgets/memories_timeline.dart';
import 'package:usverse/models/memory_model.dart';
import 'package:usverse/services/firebase/memories_service.dart';
import 'package:usverse/shared/widgets/app_empty_state.dart';

class MemoryTimelineCard extends StatelessWidget {
  final String relationshipId;
  const MemoryTimelineCard({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final memoriesService = MemoriesService();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  "Memory Timeline",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  final memories = snapshot.data!;

                  if (memories.isEmpty) {
                    return AppEmptyState(
                      icon: '📸',
                      title: 'Capture your first memory',
                      subtitle: 'Moments you save together will live here',
                    );
                  }

                  return MemoriesTimeline(memories: memories);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
