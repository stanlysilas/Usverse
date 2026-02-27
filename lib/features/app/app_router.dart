import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/features/relationship/relationship_setup_screen.dart';
import 'package:usverse/features/relationship/waiting_for_partner_screen.dart';
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
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(
            body: Center(
              child: Text('Fetching your data', style: TextStyle(fontSize: 18)),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: Text('Loading Usverse', style: TextStyle(fontSize: 18)),
            ),
          );
        }

        final rawData = snapshot.data!.data();

        if (rawData == null) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Initializing your data',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final data = rawData as Map<String, dynamic>;
        final relationshipId = data['relationshipId'];

        if (data.isEmpty) {
          return Scaffold(
            body: Center(
              child: Text('Data is missing', style: TextStyle(fontSize: 18)),
            ),
          );
        }

        if (relationshipId == null) {
          return const PartnerSetupScreen();
        } else {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('relationships')
                .doc(relationshipId)
                .snapshots(),
            builder: (context, relSnap) {
              if (!relSnap.hasData || !relSnap.data!.exists) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Loading your relationship',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              final relRaw = relSnap.data!.data();

              if (relRaw == null) {
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'Preparing your relationship',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                );
              }

              final relData = relRaw as Map<String, dynamic>;
              final status = relData['status'] ?? 'waiting';

              switch (status) {
                case 'creating':
                  return const PartnerSetupScreen();
                case 'waiting':
                  return WaitingForPartnerScreen(
                    relationshipId: relationshipId,
                  );
                case 'setup':
                  return RelationshipSetupScreen(
                    relationshipId: relationshipId,
                  );
                case 'active':
                  return ResponsiveScaffold(relationshipId: relationshipId);
                default:
                  return const PartnerSetupScreen();
              }
            },
          );
        }
      },
    );
  }
}
