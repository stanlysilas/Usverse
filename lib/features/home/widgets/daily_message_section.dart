import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/daily_message_card.dart';
import 'package:usverse/features/messages/create_daily_message_prompt.dart';
import 'package:usverse/features/messages/create_daily_message_sheet.dart';
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
          return CreateDailyMessagePrompt(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              useSafeArea: true,
              builder: (_) => const CreateDailyMessageSheet(),
            ),
          );
        }

        return DailyMessageCard(message: message);
      },
    );
  }
}
