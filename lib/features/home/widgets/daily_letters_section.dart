import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/daily_letter_card.dart';
import 'package:usverse/features/letters/create_daily_letter_prompt.dart';
import 'package:usverse/features/letters/create_daily_letter_sheet.dart';
import 'package:usverse/services/firebase/daily_letters_service.dart';

class DailyLettersSection extends StatelessWidget {
  final String relationshipId;

  const DailyLettersSection({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final service = DailyLettersService();

    return StreamBuilder(
      stream: service.watchActiveLetters(relationshipId),
      builder: (context, snapshot) {
        final letter = snapshot.data;

        if (letter == null) {
          return CreateDailyLetterPrompt(
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              showDragHandle: true,
              useSafeArea: true,
              builder: (_) => const CreateDailyLetterSheet(),
            ),
          );
        }

        return DailyLettersCard(letter: letter);
      },
    );
  }
}
