import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:usverse/shared/pickers/emoji_picker_dialog.dart';
import 'package:usverse/services/firebase/goals_services.dart';
import 'package:usverse/shared/pickers/date_time_pickers.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class CreateSharedGoalSheet extends StatefulWidget {
  final String relationshipId;

  const CreateSharedGoalSheet({super.key, required this.relationshipId});

  @override
  State<CreateSharedGoalSheet> createState() => _CreateSharedGoalSheetState();
}

class _CreateSharedGoalSheetState extends State<CreateSharedGoalSheet> {
  final titleController = TextEditingController();

  String icon = '🎯';
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();

    selectedDateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Goal 🎯',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Goal title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              UsverseListTile(
                onTap: () async {
                  final selected = await showDialog<String>(
                    context: context,
                    builder: (_) => const EmojiPickerDialog(),
                  );

                  if (selected != null) {
                    setState(() => icon = selected);
                  }
                },
                leading: Text(icon, style: TextStyle(fontSize: 18)),
                title: 'Choose emoji',
                selected: false,
                extended: true,
              ),

              UsverseListTile(
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCalendarAdd01,
                ),
                extended: true,
                title: selectedDateTime == null
                    ? "Select date"
                    : DateFormat.yMMMMd().format(selectedDateTime!),
                selected: false,
                onTap: () async {
                  selectedDateTime = await pickDate(context, selectedDateTime!);

                  setState(() {});
                },
              ),

              const SizedBox(height: 20),

              UsverseButton(
                onSubmit: () async {
                  final title = titleController.text.trim();

                  if (title.isEmpty) return;

                  await GoalsService().createGoal(
                    relationshipId: widget.relationshipId,
                    title: title,
                    icon: icon,
                    targetDate: selectedDateTime,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                message: 'Create Goal',
                color: colors.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
