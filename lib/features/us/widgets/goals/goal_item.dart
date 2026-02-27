import 'package:flutter/material.dart';
import 'package:usverse/features/us/widgets/goals/goal_progress_dialog.dart';
import 'package:usverse/models/goals_model.dart';

class GoalItem extends StatelessWidget {
  final GoalModel goal;

  const GoalItem({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final progressValue = goal.progress / 100;
    final isCompleted = goal.status == 'completed';
    final background = isCompleted
        ? colors.primaryContainer
        : colors.surfaceContainerHigh;
    final border = isCompleted
        ? Border.all(color: colors.primary, width: 1.2)
        : null;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => GoalProgressDialog(goal: goal),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: background,
          border: border,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: Text(goal.icon, style: const TextStyle(fontSize: 24)),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearProgressIndicator(
                      value: progressValue,
                      minHeight: 6,
                      color: isCompleted ? colors.primary : colors.secondary,
                      backgroundColor: colors.surfaceContainerHighest,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _statusText(goal.status),
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
  }

  String _statusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'active':
        return 'In progress';
      default:
        return 'Planned';
    }
  }
}
