import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:usverse/core/utils/date_functions.dart';

class RelationshipDetailsCard extends StatelessWidget {
  final String relationshipId;

  const RelationshipDetailsCard({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;

    return StreamBuilder<DocumentSnapshot>(
      stream: db.collection('relationships').doc(relationshipId).snapshots(),
      builder: (context, relSnap) {
        if (relSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!relSnap.hasData || !relSnap.data!.exists) {
          return const SizedBox();
        }

        final relData = relSnap.data!.data() as Map<String, dynamic>?;

        if (relData == null) return const SizedBox();

        final partnerA = relData['partnerA'];
        final partnerB = relData['partnerB'];
        final relationshipName = relData['relationshipName'] ?? "Relationship";

        final anniversary = (relData['anniversaryDate'] as Timestamp?)
            ?.toDate();

        return FutureBuilder<List<DocumentSnapshot>>(
          future: Future.wait([
            db.collection('users').doc(partnerA).get(),
            if (partnerB != null) db.collection('users').doc(partnerB).get(),
          ]),
          builder: (context, usersSnap) {
            if (usersSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!usersSnap.hasData) {
              return const SizedBox();
            }

            final users = usersSnap.data!;

            final userA = users[0].data() as Map<String, dynamic>?;

            final userB = users.length > 1
                ? users[1].data() as Map<String, dynamic>?
                : null;

            final nameA = userA?['displayName'] ?? "Partner";
            final nameB = userB?['displayName'];

            int daysTogether = 0;
            String nextAnniversaryText = "";

            if (anniversary != null) {
              daysTogether = DateTime.now().difference(anniversary).inDays;

              final next = DateFunctions().getNextAnniversary(anniversary);

              final remaining = DateFunctions().timeUntil(next);

              nextAnniversaryText =
                  "${remaining.inDays} days until next anniversary";
            }

            return Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16.0,
                ),
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
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Icon(
                            Icons.favorite,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          relationshipName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const Divider(),
                    const SizedBox(height: 12),

                    statRow("Days Together", "$daysTogether days"),

                    const SizedBox(height: 8),

                    statRow(
                      "Partners",
                      nameB != null ? "$nameA ❤️ $nameB" : nameA,
                    ),

                    if (anniversary != null) ...[
                      const SizedBox(height: 8),
                      statRow(
                        "Anniversary",
                        "${anniversary.day}/${anniversary.month}/${anniversary.year}",
                      ),
                    ],

                    if (nextAnniversaryText.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      statRow("Next Milestone", nextAnniversaryText),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
