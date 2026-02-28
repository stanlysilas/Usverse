import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:usverse/core/utils/date_functions.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';
import 'package:usverse/shared/pickers/date_time_pickers.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';

class MessageComposerBar extends StatefulWidget {
  final String relationshipId;

  const MessageComposerBar({super.key, required this.relationshipId});

  @override
  State<MessageComposerBar> createState() => _MessageComposerBarState();
}

class _MessageComposerBarState extends State<MessageComposerBar> {
  final controller = TextEditingController();
  DateTime scheduledDateTime = DateTime.now();
  String? formattedDateTime = '';

  Future<void> _pickSchedule() async {
    scheduledDateTime = await pickDate(context, scheduledDateTime);
    if (mounted) {
      scheduledDateTime = await pickTime(context, scheduledDateTime);
    }

    setState(() {
      scheduledDateTime = DateTime(
        scheduledDateTime.year,
        scheduledDateTime.month,
        scheduledDateTime.day,
        scheduledDateTime.hour,
        scheduledDateTime.minute,
      );
    });

    formattedDateTime =
        "${await DateFunctions().formatDateToString(scheduledDateTime)}, ${DateFormat('h:mm a').format(scheduledDateTime)}";
  }

  Future<void> _sendMessage() async {
    final text = controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please type a message before sending')),
      );
      return;
    }

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final userData = userDoc.data()!;

    await DailyMessageService().createMessage(
      relationshipId: widget.relationshipId,
      text: text,
      startAt: scheduledDateTime,
      userDisplayName: userData['displayName'],
      userPhotoUrl: userData['photoUrl'],
    );

    controller.clear();
    scheduledDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Write a letter…",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0.2),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          formattedDateTime!.isEmpty
                              ? 'Today'
                              : formattedDateTime!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        UsverseIconButton(
                          icon: HugeIcons.strokeRoundedCalendarAdd01,
                          message: 'Schedule letter',
                          onTap: _pickSchedule,
                        ),
                        const SizedBox(width: 8),
                        UsverseIconButton(
                          icon: HugeIcons.strokeRoundedSquareArrowUpRight02,
                          message: 'Send letter',
                          onTap: _sendMessage,
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
