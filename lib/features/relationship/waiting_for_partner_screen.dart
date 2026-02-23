import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/services/firebase/relationship_service.dart';

class WaitingForPartnerScreen extends StatelessWidget {
  final String relationshipId;
  const WaitingForPartnerScreen({super.key, required this.relationshipId});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final uid = auth.currentUser!.uid;

    final relationshipStream = FirebaseFirestore.instance
        .collection('relationships')
        .doc(relationshipId)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              RelationshipKeyProvider.instance.clear();
              auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: relationshipStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          final partnerA = data['partnerA'];
          final inviteCode = data['inviteCode'];

          final isPartnerA = uid == partnerA;

          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),

                const SizedBox(height: 12),

                const Text(
                  'Waiting for your partner',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                const Text('Ask them to join using your invite code.'),

                const SizedBox(height: 24),

                if (isPartnerA) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Your Invite Code",
                            style: TextStyle(fontSize: 16),
                          ),

                          const SizedBox(height: 8),

                          SelectableText(
                            inviteCode,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextButton.icon(
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: inviteCode),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Code copied')),
                              );
                            },
                            icon: Icon(Icons.copy_rounded),
                            label: const Text('Copy Code'),
                          ),

                          const SizedBox(height: 12),

                          TextButton.icon(
                            onPressed: () {
                              SharePlus.instance.share(
                                ShareParams(
                                  text:
                                      'Join me on Usverse with code: $inviteCode. Login to Usverse: https://usverse-platform.web.app',
                                ),
                              );
                            },
                            icon: Icon(Icons.share_rounded),
                            label: const Text('Share Code'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextButton.icon(
                  onPressed: () {
                    RelationshipService().deleteRelationship(relationshipId);
                  },
                  icon: Icon(Icons.delete_rounded),
                  label: Text('Delete Invite Code'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
