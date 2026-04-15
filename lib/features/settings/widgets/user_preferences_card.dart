import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class UserPreferencesCard extends StatelessWidget {
  const UserPreferencesCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedUser,
                    color: colors.onPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    'User Preferences',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),

            const Divider(),
            const SizedBox(height: 12),

            Text('User preferences settings will populate this card.'),
          ],
        ),
      ),
    );
  }
}
