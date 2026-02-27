import 'package:flutter/material.dart';
import 'package:usverse/models/goals_model.dart';
import 'package:usverse/services/firebase/goals_services.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';

class GoalProgressDialog extends StatefulWidget {
  final GoalModel goal;

  const GoalProgressDialog({super.key, required this.goal});

  @override
  State<GoalProgressDialog> createState() => _GoalProgressDialogState();
}

class _GoalProgressDialogState extends State<GoalProgressDialog> {
  late double progress;

  @override
  void initState() {
    super.initState();
    progress = widget.goal.progress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      constraints: BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.goal.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Text(
              "${progress.round()}%",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
            ),
            Slider(
              value: progress,
              min: 0,
              max: 100,
              divisions: 100,
              label: progress.round().toString(),
              onChanged: (value) {
                setState(() => progress = value);
              },
            ),
            const SizedBox(height: 12),
            UsverseButton(
              onSubmit: () async {
                await GoalsService().updateProgress(
                  relationshipId: widget.goal.relationshipId,
                  goalId: widget.goal.goalId,
                  progress: progress.round(),
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              message: 'Update',
              color: colors.primaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}
