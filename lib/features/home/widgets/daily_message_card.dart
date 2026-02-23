import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/models/daily_message_model.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';

class DailyMessageCard extends StatelessWidget {
  final DailyMessage message;
  DailyMessageCard({super.key, required this.message});

  final auth = FirebaseAuth.instance.currentUser!;

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
                Expanded(
                  child: Text(
                    "Today's Message",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                if (message.senderId == auth.uid)
                  IconButton(
                    onPressed: () {
                      DailyMessageService().deleteMessage(
                        message.id,
                        message.relationshipId,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Message deleted succesfully')),
                      );

                      debugPrint(
                        'User tapped on delete message: ${message.message}',
                      );
                    },
                    icon: Icon(
                      Icons.delete_rounded,
                      color: Theme.of(context).colorScheme.error,
                    ),
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
