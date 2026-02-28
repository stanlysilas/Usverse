import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/utils/date_functions.dart';
import 'package:usverse/models/relationship_model.dart';
import 'package:usverse/models/user_model.dart';

class RelationshipDetailsCard extends StatelessWidget {
  final Relationship relationship;
  final List<UserModel> partners;

  const RelationshipDetailsCard({
    super.key,
    required this.relationship,
    required this.partners,
  });

  @override
  Widget build(BuildContext context) {
    final anniversary = relationship.anniversaryDate;

    int daysTogether = 0;
    String nextAnniversaryText = "";

    daysTogether = DateTime.now().difference(anniversary).inDays;

    final next = DateFunctions().getNextAnniversary(anniversary);

    final remaining = DateFunctions().timeUntil(next);

    nextAnniversaryText = "${remaining.inDays} days until next anniversary";

    final names = partners.map((e) => e.displayName).toList();

    final partnersText = names.length > 1
        ? "${names[0]} ❤️ ${names[1]}"
        : names.first;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: HugeIcon(
                    icon: HugeIcons.strokeRoundedFavourite,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                Text(
                  relationship.relationshipName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 12),
            statRow("Days Together", "$daysTogether days", context),
            const SizedBox(height: 8),
            statRow("Partners", partnersText, context),

            const SizedBox(height: 8),
            statRow(
              "Anniversary",
              "${anniversary.day}/${anniversary.month}/${anniversary.year}",
              context,
            ),

            if (nextAnniversaryText.isNotEmpty) ...[
              const SizedBox(height: 8),
              statRow("Next Milestone", nextAnniversaryText, context),
            ],
          ],
        ),
      ),
    );
  }

  Widget statRow(String label, String value, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.clip,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
