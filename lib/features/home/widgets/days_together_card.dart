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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      child: Column(
        children: [
          Text(
            'Our Journey Together ❤️',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),

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
    );
  }
}
