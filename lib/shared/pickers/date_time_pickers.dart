import 'package:flutter/material.dart';

Future<DateTime> pickDate(BuildContext context, DateTime selectedDate) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(1990),
    lastDate: DateTime.now(),
  );

  if (picked == null) return selectedDate;

  return DateTime(
    picked.year,
    picked.month,
    picked.day,
    selectedDate.hour,
    selectedDate.minute,
  );
}

Future<DateTime> pickTime(
  BuildContext context,
  DateTime selectedDateTime,
) async {
  final picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(selectedDateTime),
  );

  if (picked == null) return selectedDateTime;

  return DateTime(
    selectedDateTime.year,
    selectedDateTime.month,
    selectedDateTime.day,
    picked.hour,
    picked.minute,
  );
}
