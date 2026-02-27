import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'package:usverse/features/memories/services/memory_upload_service.dart';
import 'package:usverse/shared/pickers/emoji_picker_dialog.dart';
import 'package:usverse/services/firebase/memories_service.dart';
import 'package:usverse/shared/pickers/date_time_pickers.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class CreateMemorySheet extends StatefulWidget {
  final String relationshipId;

  const CreateMemorySheet({super.key, required this.relationshipId});

  @override
  State<CreateMemorySheet> createState() => _CreateMemorySheetState();
}

class _CreateMemorySheetState extends State<CreateMemorySheet> {
  final picker = ImagePicker();
  final captionController = TextEditingController();

  late DateTime? selectedDateTime;
  late TimeOfDay? selectedTime;

  final uploadService = MemoryUploadService();
  final memoriesService = MemoriesService();

  bool isMilestone = false;
  String icon = '❤️';
  String milestoneTitle = '';

  Uint8List? selectedImage;

  @override
  void initState() {
    super.initState();

    selectedDateTime = DateTime.now();
    selectedTime = TimeOfDay.now();
  }

  Future<void> pickImage() async {
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    final bytes = await file.readAsBytes();

    setState(() {
      selectedImage = bytes;
    });
  }

  String formatMemoryDate(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final suffix = date.hour >= 12 ? "PM" : "AM";
    final minute = date.minute.toString().padLeft(2, '0');

    return "${date.day}/${date.month}/${date.year} • $hour:$minute $suffix";
  }

  Future<void> submit() async {
    if (selectedImage == null) return;

    if (isMilestone && milestoneTitle.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please give your Milestone a title")),
      );

      return;
    }

    final result = await uploadService.uploadMemory(selectedImage!);

    await memoriesService.createEncryptedMemory(
      relationshipId: widget.relationshipId,
      mediaUrl: result['imageUrl'],
      nonce: result['nonce'],
      mac: result['mac'],
      caption: captionController.text.trim(),
      memoryDate: selectedDateTime!,
      sortDate: selectedDateTime!,
      isMilestone: isMilestone,
      icon: icon,
      milestoneTitle: milestoneTitle,
    );

    if (mounted) Navigator.pop(context);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Memory created ❤️")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create Memory 📸",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: selectedImage == null
                      ? const HugeIcon(
                          icon: HugeIcons.strokeRoundedImageAdd01,
                          size: 40,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            selectedImage!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: captionController,
                decoration: InputDecoration(
                  hintText: 'Write something about this memory...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 2,
              ),

              const SizedBox(height: 16),

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

              UsverseListTile(
                leading: const HugeIcon(
                  icon: HugeIcons.strokeRoundedTimeSchedule,
                ),
                extended: true,
                title: selectedTime == null
                    ? "Select time"
                    : selectedTime!.format(context),
                selected: false,
                onTap: () async {
                  selectedDateTime = await pickTime(context, selectedDateTime!);

                  setState(() {
                    selectedTime = TimeOfDay.fromDateTime(selectedDateTime!);
                  });
                },
              ),

              UsverseListTile(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                leading: Checkbox(
                  value: isMilestone,
                  onChanged: (value) {
                    setState(() {
                      isMilestone = value ?? false;
                    });
                  },
                ),
                title: 'Mark as milestone',
                selected: false,
                extended: true,
                onTap: () {
                  setState(() {
                    isMilestone = !isMilestone;
                  });
                },
              ),

              if (!isMilestone) const SizedBox(height: 12),

              if (isMilestone)
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

              if (isMilestone) const SizedBox(height: 12),

              if (isMilestone)
                TextField(
                  onChanged: (value) => milestoneTitle = value,
                  decoration: InputDecoration(
                    labelText: 'Milestone title',
                    hintText: 'e.g. First Trip',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

              if (isMilestone) const SizedBox(height: 12),

              if (selectedDateTime != null || selectedTime != null)
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
                      const HugeIcon(icon: HugeIcons.strokeRoundedTimeSchedule),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Memory from ${DateFormat.yMMMd().add_jm().format(selectedDateTime!)}",
                        ),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 20),

              UsverseButton(
                onSubmit: submit,
                message: 'Save Memory',
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
