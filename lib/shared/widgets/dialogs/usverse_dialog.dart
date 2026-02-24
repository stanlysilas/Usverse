import 'package:flutter/material.dart';

class UsverseDialog extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const UsverseDialog({super.key, required this.child, this.maxWidth = 420});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
