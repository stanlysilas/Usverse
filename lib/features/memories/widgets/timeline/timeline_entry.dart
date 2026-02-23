import 'package:usverse/models/memory_model.dart';

class TimelineEntry {
  final String? header;
  final MemoryModel? memory;

  const TimelineEntry.header(this.header) : memory = null;
  const TimelineEntry.memory(this.memory) : header = null;

  bool get isHeader => header != null;
}
