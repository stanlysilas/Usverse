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
          return const SizedBox();
        }

        return DailyMessageCard(message: message);
      },
    );
  }
}
