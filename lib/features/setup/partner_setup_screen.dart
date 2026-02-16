import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usverse/features/relationship/waiting_for_partner_screen.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/submit_button.dart';

class PartnerSetupScreen extends StatefulWidget {
  const PartnerSetupScreen({super.key});

  @override
  State<PartnerSetupScreen> createState() => _PartnerSetupScreenState();
}

class _PartnerSetupScreenState extends State<PartnerSetupScreen> {
  final TextEditingController inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/illustrations/partner_setup.png', scale: 4),

              Icon(Icons.favorite_border_rounded, color: Colors.redAccent),

              const SizedBox(height: 12),

              Text(
                'Add your partner',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Connect with your partner to get started'),

              const SizedBox(height: 24),

              SizedBox(
                width: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.key),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Enter invite code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: TextField(
                                controller: inviteCodeController,
                              ),
                            ),
                          ],
                        ),

                        Flexible(
                          child: SubmitButton(
                            color: Colors.deepOrange,
                            onSubmit: () async {
                              final relationshipService = RelationshipService();
                              final result = await relationshipService
                                  .joinWithInviteCode(
                                    inviteCodeController.text.trim(),
                                  );

                              if (result == null) {
                                debugPrint('Joined succesfully');
                                return;
                              }

                              String message = switch (result) {
                                "INVALID_CODE" => "Invalid invite code.",
                                "SELF_JOIN" =>
                                  "You cannot join your own invite.",
                                "ALREADY_CONNECTED" =>
                                  "This relationship already has two partners.",
                                "ALREADY_IN_RELATIONSHIP" =>
                                  "You are already connected.",
                                _ => "Something went wrong.",
                              };

                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text("Unable to connect"),
                                  content: Text(message),
                                ),
                              );
                            },
                            message: 'Connect',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Container(
                width: 350,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  spacing: 4,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: Divider()),
                    Text('OR'),
                    Expanded(child: Divider()),
                  ],
                ),
              ),

              SizedBox(
                width: 400,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Row(
                      spacing: 4,
                      children: [
                        Icon(Icons.link),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Create invite code',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Generate and share an invite code with your partner.',
                            ),

                            const SizedBox(height: 8),
                            SubmitButton(
                              color: Colors.deepPurple,
                              onSubmit: () async {
                                final relationshipService =
                                    RelationshipService();
                                final code = await relationshipService
                                    .createInviteCode();

                                if (code == null) {
                                  showDialog(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text('Invite code already exists'),
                                      content: Text(
                                        'You already created or joined a relationship.',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Close'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Invite Code'),
                                    content: SelectableText(
                                      code,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          await Clipboard.setData(
                                            ClipboardData(text: code),
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Code copied to clipboard',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text('Copy'),
                                      ),
                                    ],
                                  ),
                                );

                                debugPrint('Invite code created: $code');
                              },
                              message: 'Create invite code',
                            ),
                          ],
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
    );
  }
}
