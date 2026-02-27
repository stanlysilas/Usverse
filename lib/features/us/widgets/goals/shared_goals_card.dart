import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/features/us/widgets/goals/goals_list.dart';
import 'package:usverse/models/goals_model.dart';
import 'package:usverse/services/firebase/goals_services.dart';
import 'package:usverse/shared/widgets/app_empty_state.dart';

class SharedGoalsCard extends StatelessWidget {
  final String relationshipId;

  const SharedGoalsCard({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final service = GoalsService();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedTarget02,
                    color: colors.onPrimary,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Shared Goals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 12),

            StreamBuilder<List<GoalModel>>(
              stream: service.watchGoals(relationshipId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (snapshot.hasError) {
                  debugPrint(snapshot.error.toString());
                  return Center(
                    child: Text("Error: ${snapshot.error.toString()}"),
                  );
                }

                final goals = snapshot.data ?? [];

                if (goals.isEmpty) {
                  return AppEmptyState(
                    icon: '🎯',
                    title: 'Dream together',
                    subtitle: 'Set shared goals and grow toward them',
                  );
                }

                return GoalsList(goals: goals);
              },
            ),
          ],
        ),
      ),
    );
  }
}
