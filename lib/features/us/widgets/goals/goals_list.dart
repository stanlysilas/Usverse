import 'package:flutter/material.dart';
import 'package:usverse/features/us/widgets/goals/goal_item.dart';
import 'package:usverse/models/goals_model.dart';

class GoalsList extends StatelessWidget {
  final List<GoalModel> goals;

  const GoalsList({super.key, required this.goals});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        goals.length,
        (index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: GoalItem(goal: goals[index]),
        ),
      ),
    );
  }
}
