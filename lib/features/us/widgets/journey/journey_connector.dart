import 'package:flutter/material.dart';

class JourneyConnector extends StatelessWidget {
  const JourneyConnector({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SizedBox(
      width: 40,
      child: Center(child: Container(height: 2, color: colors.outlineVariant)),
    );
  }
}
