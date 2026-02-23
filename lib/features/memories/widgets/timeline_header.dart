import 'package:flutter/material.dart';

class TimelineHeader extends StatelessWidget {
  final String title;

  const TimelineHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
