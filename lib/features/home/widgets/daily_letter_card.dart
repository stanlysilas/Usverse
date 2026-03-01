import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:usverse/models/daily_letter_model.dart';
import 'package:usverse/services/firebase/daily_letters_service.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_confirm_dialog.dart';

class DailyLettersCard extends StatelessWidget {
  final DailyLetter letter;
  DailyLettersCard({super.key, required this.letter});

  final auth = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
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
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedMail01,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Today's Letter",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),

                if (letter.senderId == auth.uid)
                  UsverseIconButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => UsverseConfirmDialog(
                          title: 'Are you sure you want to delete this letter?',
                          message:
                              "You won't be able to recover this letter once after deleting it.",
                          onConfirm: () async {
                            await DailyLettersService().deleteLetter(
                              letter.id,
                              letter.relationshipId,
                            );

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Letter deleted succesfully'),
                                ),
                              );

                              Navigator.pop(context);
                            }
                          },
                        ),
                      );
                    },
                    icon: HugeIcons.strokeRoundedDelete01,
                    message: 'Delete message',
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),

            Text(letter.message, style: TextStyle(fontSize: 16)),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "From: ${letter.senderDisplayName}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                Text(
                  DateFormat('h:MM a').format(letter.startAt),
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
