import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/features/home/home_screen.dart';
import 'package:usverse/features/relationship/relationship_setup_screen.dart';
import 'package:usverse/features/relationship/waiting_for_partner_screen.dart';
import 'package:usverse/features/settings/settings_screen.dart';
import 'package:usverse/features/setup/partner_setup_screen.dart';
import 'package:usverse/shared/layout/responsive_scaffold.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    final userDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: userDoc,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          debugPrint('userDoc is loading');
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;

        final relationshipId = data['relationshipId'];

        if (relationshipId == null) {
          return const PartnerSetupScreen();
        }

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('relationships')
              .doc(relationshipId)
              .snapshots(),
          builder: (context, relSnap) {
            if (!relSnap.hasData) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final relData = relSnap.data!.data() as Map<String, dynamic>;

            final status = relData['status'] ?? 'waiting';

            switch (status) {
              case 'creating':
                return const PartnerSetupScreen();
              case 'waiting':
                return const WaitingForPartnerScreen();
              case 'setup':
                return const RelationshipSetupScreen();
              case 'active':
                return ResponsiveScaffold(
                  pages: [const HomeScreen(), SettingsScreen()],
                );
              default:
                return const PartnerSetupScreen();
            }
          },
        );
      },
    );
  }
}
