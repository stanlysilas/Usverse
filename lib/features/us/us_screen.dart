import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/features/us/widgets/relationship_details_card.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_confirm_dialog.dart';

class UsScreen extends StatelessWidget {
  UsScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Us')),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(auth.currentUser!.uid)
            .snapshots(),
        builder: (context, userSnap) {
          if (userSnap.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('UserSnap waiting'));
          }

          if (!userSnap.hasData || !userSnap.data!.exists) {
            return const Center(child: Text("User not found"));
          }

          final userData = userSnap.data!.data() as Map<String, dynamic>?;

          if (userData == null) {
            return const Center(child: Text('UserData is null'));
          }

          final relationshipId = userData['relationshipId'];

          if (relationshipId == null) {
            return const Center(child: Text("No relationship"));
          }

          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('relationships')
                .doc(relationshipId)
                .snapshots(),
            builder: (context, relSnap) {
              if (relSnap.connectionState == ConnectionState.waiting) {
                return const Center(child: Text('RelSnap waiting'));
              }

              if (!relSnap.hasData || !relSnap.data!.exists) {
                return const Center(child: Text("Relationship missing"));
              }

              final relData = relSnap.data!.data() as Map<String, dynamic>?;

              if (relData == null) {
                return const Center(child: Text('RelData is null'));
              }

              final partnerA = relData['partnerA'];
              final partnerB = relData['partnerB'];
              final relationshipName =
                  relData['relationshipName'] ?? "Your Relationship";

              return FutureBuilder<List<DocumentSnapshot>>(
                future: Future.wait([
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(partnerA)
                      .get(),
                  if (partnerB != null)
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(partnerB)
                        .get(),
                ]),
                builder: (context, usersSnap) {
                  debugPrint("PartnerA: $partnerA");
                  debugPrint("PartnerB: $partnerB");
                  if (usersSnap.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (usersSnap.hasError) {
                    debugPrint(userSnap.error.toString());
                    return Center(child: Text('Error: ${usersSnap.error}'));
                  }

                  if (!usersSnap.hasData || usersSnap.data!.isEmpty) {
                    return const Center(child: Text('No users found'));
                  }

                  final users = usersSnap.data!;
                  debugPrint("Users: ${(users[0].data() as Map)['photoUrl']}");
                  final photoA = (users[0].data() as Map)['photoUrl'];
                  final photoB = users.length > 1
                      ? (users[1].data() as Map)['photoUrl']
                      : null;

                  debugPrint("PhotoA: $photoA");
                  debugPrint("PhotoB: $photoB");

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            OverlappingAvatars(photoA: photoA, photoB: photoB),
                            const SizedBox(height: 12),

                            Text(
                              relationshipName,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 16),

                            RelationshipDetailsCard(
                              relationshipId: relationshipId,
                            ),

                            const SizedBox(height: 12),
                            const Divider(),
                            const SizedBox(height: 12),

                            ListTile(
                              leading: const Icon(Icons.logout_rounded),
                              title: const Text('Log out of Usverse'),
                              onTap: () => showDialog(
                                context: context,
                                builder: (_) => UsverseConfirmDialog(
                                  title: 'Are you sure you want to log out?',
                                  message:
                                      'Log out of Usverse as ${auth.currentUser!.email}?',
                                  confirmText: 'Log out',
                                  onConfirm: () {
                                    RelationshipKeyProvider.instance.clear();
                                    auth.signOut();
                                  },
                                ),
                              ),
                            ),

                            const Spacer(),
                            Text(
                              "Usverse Beta v0.1.0",
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              "Usverse is best viewed on wide displays",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class OverlappingAvatars extends StatelessWidget {
  final String? photoA;
  final String? photoB;

  const OverlappingAvatars({
    super.key,
    required this.photoA,
    required this.photoB,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(left: 0, child: avatar(photoA)),
          Positioned(right: 0, child: avatar(photoB)),
        ],
      ),
    );
  }

  Widget avatar(String? url) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        color: Colors.grey.shade300,
      ),
      child: ClipOval(
        child: url == null
            ? const Icon(Icons.person, size: 28)
            : CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, _) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, _, _) => const Icon(Icons.person),
              ),
      ),
    );
  }
}
