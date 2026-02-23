import 'package:intl/intl.dart';
import 'package:usverse/models/memory_model.dart';
import 'timeline_entry.dart';

class TimelineGrouping {
  static List<TimelineEntry> group(List<MemoryModel> memories) {
    final result = <TimelineEntry>[];

    String? lastHeader;

    for (final memory in memories) {
      final header = _format(memory.memoryDate);

      if (header != lastHeader) {
        result.add(TimelineEntry.header(header));
        lastHeader = header;
      }

      result.add(TimelineEntry.memory(memory));
    }

    return result;
  }

  static String _format(DateTime date) {
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = today.difference(target).inDays;

    if (diff == 0) return "Today";
    if (diff == 1) return "Yesterday";
    if (diff < 7) return DateFormat('EEEE').format(date);

    return DateFormat('MMM d, yyyy').format(date);
  }
}
