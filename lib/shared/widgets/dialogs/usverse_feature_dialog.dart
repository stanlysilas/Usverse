import 'package:flutter/material.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'usverse_dialog.dart';

class UsverseFeatureDialog extends StatelessWidget {
  final Widget image;
  final String title;
  final String description;
  final String cancelText;
  final String confirmText;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;

  const UsverseFeatureDialog({
    super.key,
    required this.image,
    required this.title,
    required this.description,
    this.cancelText = 'Cancel',
    this.onCancel,
    this.confirmText = 'Confirm',
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return UsverseDialog(
      maxWidth: 520,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AspectRatio(aspectRatio: 16 / 9, child: image),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          Text(description),

          const SizedBox(height: 24),

          if (onConfirm != null)
            UsverseButton(
              onSubmit: onConfirm!,
              message: confirmText,
              color: Theme.of(context).colorScheme.primaryContainer,
            ),

          if (onConfirm != null) const SizedBox(height: 12),

          UsverseButton(
            onSubmit: onCancel ?? () => Navigator.pop(context),
            message: cancelText,
            color: Theme.of(context).colorScheme.surfaceContainer,
            useBorder: true,
          ),
        ],
      ),
    );
  }
}
