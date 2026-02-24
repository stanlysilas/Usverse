import 'package:flutter/material.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'usverse_dialog.dart';

class UsverseConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;

  const UsverseConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return UsverseDialog(
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),

            const SizedBox(height: 24),

            UsverseButton(
              onSubmit: onConfirm,
              message: confirmText,
              color: colors.primaryContainer,
            ),

            const SizedBox(height: 12),

            UsverseButton(
              onSubmit: () {
                Navigator.pop(context);
              },
              message: cancelText,
              color: colors.surfaceContainer,
              useBorder: true,
            ),
          ],
        ),
      ),
    );
  }
}
