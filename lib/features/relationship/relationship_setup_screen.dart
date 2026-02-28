import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/core/theme/mesh_gradient_background.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/pickers/date_time_pickers.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class RelationshipSetupScreen extends StatefulWidget {
  final String relationshipId;
  const RelationshipSetupScreen({super.key, required this.relationshipId});

  @override
  State<RelationshipSetupScreen> createState() =>
      _RelationshipSetupScreenState();
}

class _RelationshipSetupScreenState extends State<RelationshipSetupScreen> {
  final TextEditingController relationshipNameController =
      TextEditingController();
  final TextEditingController partnerANicknameController =
      TextEditingController();
  final TextEditingController partnerBNicknameController =
      TextEditingController();
  DateTime? anniversaryDate;

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final relationshipStream = FirebaseFirestore.instance
        .collection('relationships')
        .doc(widget.relationshipId)
        .snapshots();

    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          const MeshGradientBackground(),

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

              final isPartnerA = auth.currentUser!.uid == partnerA;

              if (isPartnerA) {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 420, maxHeight: 420),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(24),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32.0,
                            vertical: 24.0,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HugeIcon(
                                icon: HugeIcons.strokeRoundedFavourite,
                                color: Colors.redAccent,
                                size: 42,
                              ),

                              const SizedBox(height: 12),

                              Text(
                                'Set up your relationship',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 24),

                              Column(
                                spacing: 8,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Relationship name *',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  TextField(
                                    controller: relationshipNameController,
                                    decoration: InputDecoration(
                                      hintText: 'Eg. Alex and Mary',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    'Anniversary Date *',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),

                                  UsverseListTile(
                                    leading: const HugeIcon(
                                      icon:
                                          HugeIcons.strokeRoundedCalendarAdd01,
                                    ),
                                    extended: true,
                                    title: anniversaryDate == null
                                        ? "Select date"
                                        : DateFormat.yMMMMd().format(
                                            anniversaryDate!,
                                          ),
                                    selected: false,
                                    onTap: () async {
                                      anniversaryDate = await pickDate(
                                        context,
                                        anniversaryDate ?? DateTime.now(),
                                      );

                                      setState(() {});
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    'Your nickname (Optional)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextField(
                                    controller: partnerANicknameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    "Partner's nickname (Optional)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  TextField(
                                    controller: partnerBNicknameController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  UsverseButton(
                                    onSubmit: () async {
                                      final user = auth.currentUser!;
                                      if (relationshipNameController
                                              .text
                                              .isNotEmpty &&
                                          anniversaryDate != null) {
                                        final doc = await db
                                            .collection('users')
                                            .doc(user.uid)
                                            .get();
                                        final relationshipId = doc
                                            .data()?['relationshipId'];
                                        await RelationshipService()
                                            .saveRelationshipDetails(
                                              relationshipId,
                                              relationshipNameController.text
                                                  .trim(),
                                              anniversaryDate!,
                                              partnerANicknameController.text
                                                  .trim(),
                                              partnerBNicknameController.text
                                                  .trim(),
                                            );
                                      } else {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Please fill the details to finish setup',
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    message: 'Finish setup',
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 420, maxHeight: 420),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadiusGeometry.circular(24),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 32.0,
                          vertical: 24.0,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedHourglass,
                              color: Colors.redAccent,
                              size: 42,
                            ),

                            const SizedBox(height: 12),

                            Text(
                              'Set up your relationship',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 24),

                            SizedBox(
                              width: 250,
                              child: Text(
                                'Please wait while your partner sets up your relationship',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
