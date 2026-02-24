import 'package:flutter/material.dart';
import 'usverse_dialog.dart';

class UsverseFeatureDialog extends StatelessWidget {
  final ImageProvider image;
  final String title;
  final String description;

  const UsverseFeatureDialog({
    super.key,
    required this.image,
    required this.title,
    required this.description,
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
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(image: image, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 8),

          Text(description),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
