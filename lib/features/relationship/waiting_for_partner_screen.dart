import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:share_plus/share_plus.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_confirm_dialog.dart';

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
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(
                'assets/logos/usverse_logo.svg',
                width: 180,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),

              UsverseIconButton(
                onTap: () {
                  RelationshipKeyProvider.instance.clear();
                  auth.signOut();
                },
                message: 'Log out',
                icon: HugeIcons.strokeRoundedLogout01,
              ),
            ],
          ),

          StreamBuilder<DocumentSnapshot>(
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 420),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 24,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HugeIcon(
                            icon: HugeIcons.strokeRoundedFavourite,
                            color: Colors.redAccent,
                            size: 42,
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Waiting for your partner',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 24),

                          const Text(
                            'Ask them to join using your invite code.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),

                          const SizedBox(height: 32),

                          if (isPartnerA) ...[
                            Column(
                              children: [
                                const Text(
                                  "Your Invite Code",
                                  style: TextStyle(fontSize: 16),
                                ),

                                const SizedBox(height: 12),

                                SelectableText(
                                  inviteCode,
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),

                                const SizedBox(height: 24),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    UsverseIconButton(
                                      icon: HugeIcons.strokeRoundedCopy01,
                                      message: 'Copy Code',
                                      onTap: () {
                                        Clipboard.setData(
                                          ClipboardData(text: inviteCode),
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Code copied'),
                                          ),
                                        );
                                      },
                                    ),

                                    UsverseIconButton(
                                      icon: HugeIcons.strokeRoundedShare01,
                                      message: 'Share Code',
                                      onTap: () {
                                        SharePlus.instance.share(
                                          ShareParams(
                                            text:
                                                'Join me on Usverse with code: $inviteCode. Login to Usverse: https://usverse-platform.web.app',
                                          ),
                                        );
                                      },
                                    ),

                                    UsverseIconButton(
                                      icon: HugeIcons.strokeRoundedDelete01,
                                      foregroundColor: Theme.of(
                                        context,
                                      ).colorScheme.errorContainer,
                                      message: 'Delete Code',
                                      onTap: () => showDialog(
                                        context: context,
                                        builder: (_) => UsverseConfirmDialog(
                                          title:
                                              'Are you sure you want to delete this code?',
                                          message:
                                              'This code will become invalid once deleted and anyone connected will be logged out.',
                                          onConfirm: () {
                                            RelationshipService()
                                                .deleteRelationship(
                                                  relationshipId,
                                                );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
