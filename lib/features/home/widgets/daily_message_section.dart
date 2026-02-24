import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/daily_message_card.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';

class DailyMessageSection extends StatelessWidget {
  final String relationshipId;

  const DailyMessageSection({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final service = DailyMessageService();

    return StreamBuilder(
      stream: service.watchActiveMessage(relationshipId),
      builder: (context, snapshot) {
        final message = snapshot.data;

        if (message == null) {
          debugPrint('No messages for today');
          return Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16.0,
              ),
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
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  Text('No messages for today', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          );
        }

        return DailyMessageCard(message: message);
      },
    );
  }
}
