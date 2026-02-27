import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:usverse/models/daily_message_model.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';

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
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
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
                  UsverseIconButton(
                    onTap: () {
                      DailyMessageService().deleteMessage(
                        message.id,
                        message.relationshipId,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Message deleted succesfully')),
                      );
                    },
                    icon: HugeIcons.strokeRoundedDelete01,
                    message: 'Delete',
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            Text(message.message, style: TextStyle(fontSize: 16)),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From: ${message.senderDisplayName}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  DateFormat('h:MM a').format(message.startAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
