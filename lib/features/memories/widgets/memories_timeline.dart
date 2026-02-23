import 'package:flutter/material.dart';
import 'package:usverse/models/memory_model.dart';
import 'timeline/timeline_grouping.dart';
import 'timeline_header.dart';
import 'timeline_item.dart';

class MemoriesTimeline extends StatelessWidget {
  final List<MemoryModel> memories;

  const MemoriesTimeline({super.key, required this.memories});

  @override
  Widget build(BuildContext context) {
    final entries = TimelineGrouping.group(memories);

    return ListView.builder(
      shrinkWrap: true,
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];

        if (entry.isHeader) {
          return TimelineHeader(title: entry.header!);
        }

        final memory = entry.memory!;

        final memoryIndex =
            entries.take(index).where((e) => !e.isHeader).length - 1;

        final total = entries.where((e) => !e.isHeader).length;

        return TimelineItem(
          memory: memory,
          isFirst: memoryIndex == 0,
          isLast: memoryIndex == total - 1,
        );
      },
    );
  }
}
