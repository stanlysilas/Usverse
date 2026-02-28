import 'package:flutter/material.dart';
import 'package:usverse/core/utils/date_functions.dart';
import 'package:usverse/models/relationship_model.dart';

class DaysTogetherCard extends StatelessWidget {
  final Relationship relationship;
  const DaysTogetherCard({super.key, required this.relationship});

  @override
  Widget build(BuildContext context) {
    final daysTogether = DateFunctions().calculateDaysTogether(
      relationship.anniversaryDate,
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 12,
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.timeline_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  'Days Together',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 12),

            Text(
              '$daysTogether',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            Text("Days", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
