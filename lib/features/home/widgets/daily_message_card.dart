import 'package:flutter/material.dart';
import 'package:usverse/models/daily_message_model.dart';

class DailyMessageCard extends StatelessWidget {
  final DailyMessage message;
  const DailyMessageCard({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
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
                    Icons.mail_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  "Today's Message",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            Text(message.message, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
