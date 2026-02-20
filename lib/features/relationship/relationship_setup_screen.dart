import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/core/utils/date_functions.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/date_picker.dart';
import 'package:usverse/shared/submit_button.dart';

class RelationshipSetupScreen extends StatefulWidget {
  const RelationshipSetupScreen({super.key});

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
  String formattedDate = 'dd-MM-yyyy';

  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/illustrations/relationship_setup.png',
                  scale: 4,
                ),

                Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),

                Text(
                  'Set up your relationship',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Relationship name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextField(
                            controller: relationshipNameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    'Anniversary date: ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () async {
                                  await pickDate(context, DateTime.now(), (
                                    picked,
                                  ) async {
                                    final String date = await DateFunctions()
                                        .formatDateToString(picked);
                                    setState(() {
                                      formattedDate = date;
                                      anniversaryDate = picked;
                                    });
                                    debugPrint(
                                      'User selected date: $anniversaryDate',
                                    );
                                  });
                                },
                                icon: Icon(Icons.date_range_rounded),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          Text(
                            'Your nickname (Optional)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                              fontWeight: FontWeight.w600,
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

                          SubmitButton(
                            onSubmit: () async {
                              final user = auth.currentUser!;
                              if (relationshipNameController.text.isNotEmpty &&
                                  formattedDate != 'dd-MM-yyyy') {
                                final doc = await db
                                    .collection('users')
                                    .doc(user.uid)
                                    .get();
                                final relationshipId = doc
                                    .data()?['relationshipId'];
                                await RelationshipService()
                                    .saveRelationshipDetails(
                                      relationshipId,
                                      relationshipNameController.text.trim(),
                                      anniversaryDate!,
                                      partnerANicknameController.text.trim(),
                                      partnerBNicknameController.text.trim(),
                                    );
                              } else {
                                debugPrint(
                                  "User did not fill details, show warning dialog.",
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
