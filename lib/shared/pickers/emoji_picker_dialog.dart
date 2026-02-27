import 'package:flutter/material.dart';

class EmojiPickerDialog extends StatelessWidget {
  const EmojiPickerDialog({super.key});

  static const emojis = [
    '❤️',
    '🌍',
    '🎓',
    '🏡',
    '✈️',
    '💍',
    '🎉',
    '📸',
    '🌅',
    '⭐',
    '🎯',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: emojis.map((emoji) {
            return GestureDetector(
              onTap: () => Navigator.pop(context, emoji),
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            );
          }).toList(),
        ),
      ),
    );
  }
}
