import 'package:flutter/material.dart';
import 'package:usverse/features/memories/widgets/encrypted_memory_image.dart';
import 'package:usverse/models/memory_model.dart';

class MemoryCard extends StatelessWidget {
  final MemoryModel memory;

  const MemoryCard({super.key, required this.memory});

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
