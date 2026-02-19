import 'package:flutter/material.dart';

Future<DateTime> pickDate(
  BuildContext context,
  DateTime? selectedDate,
  Function(DateTime) onDateSelected,
) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime(1990),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    onDateSelected(picked);
  }

  return selectedDate!;
}
