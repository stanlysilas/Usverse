import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usverse/services/firebase/daily_message_service.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/pickers/date_time_pickers.dart';
import 'package:usverse/shared/submit_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class CreateDailyMessageSheet extends StatefulWidget {
  const CreateDailyMessageSheet({super.key});

  @override
  State<CreateDailyMessageSheet> createState() =>
      _CreateDailyMessageSheetState();
}

class _CreateDailyMessageSheetState extends State<CreateDailyMessageSheet> {
  final DailyMessageService messageService = DailyMessageService();
  final RelationshipService relationshipService = RelationshipService();
  final TextEditingController messageController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  static const int maxCharacters = 300;

  DateTime? get scheduledDateTime {
    if (selectedDate == null || selectedTime == null) {
      return null;
    }

    return DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
  }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> submit() async {
    if (messageController.text.trim().isEmpty || scheduledDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill message and schedule time")),
      );
      return;
    }

    try {
      final relationshipId = await relationshipService
          .getCurrentUserRelationshipId();

      if (relationshipId == null) {
        throw Exception("No relationship found");
      }

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data()!;

      await messageService.createMessage(
        relationshipId: relationshipId,
        text: messageController.text.trim(),
        startAt: scheduledDateTime!,
        userDisplayName: userData['displayName'] ?? '',
        userPhotoUrl: userData['photoUrl'] ?? '',
      );

      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Message scheduled ❤️")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to schedule message")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Daily Message 💌",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: messageController,
                maxLength: maxCharacters,
                maxLines: 4,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: "Write something for your partner...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              UsverseListTile(
                leading: const Icon(Icons.calendar_today_rounded),
                title: selectedDate == null
                    ? "Select date"
                    : DateFormat.yMMMMd().format(selectedDate!),

                onTap: () async {
                  selectedDate = await pickDate(context, selectedDate!);

                  setState(() {});
                },
              ),

              UsverseListTile(
                leading: const Icon(Icons.access_time_rounded),
                title: selectedTime == null
                    ? "Select time"
                    : selectedTime!.format(context),

                onTap: () async {
                  selectedDate = await pickTime(context, selectedDate!);

                  setState(() {
                    selectedTime = TimeOfDay.fromDateTime(selectedDate!);
                  });
                },
              ),

              const SizedBox(height: 12),

              if (scheduledDateTime != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.schedule),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Visible from ${DateFormat.yMMMd().add_jm().format(scheduledDateTime!)} for 24 hours",
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              SubmitButton(
                message: "Schedule Message",
                onSubmit: submit,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
