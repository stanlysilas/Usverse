import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usverse/features/memories/widgets/encrypted_memory_image.dart';
import 'package:usverse/models/memory_model.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_feature_dialog.dart';

class MemoryCard extends StatelessWidget {
  final MemoryModel memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => UsverseFeatureDialog(
            image: EncryptedMemoryImage(
              imageUrl: memory.mediaUrl,
              nonce: memory.nonce,
              mac: memory.mac,
            ),
            title: memory.caption!,
            description:
                "Memory from: ${DateFormat('EEE d, yy').format(memory.memoryDate)} at ${DateFormat('h:mm a').format(memory.memoryDate)}",
            cancelText: 'Close',
          ),
        ),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EncryptedMemoryImage(
                imageUrl: memory.mediaUrl,
                nonce: memory.nonce,
                mac: memory.mac,
              ),

              if (memory.caption!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    memory.caption!,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
