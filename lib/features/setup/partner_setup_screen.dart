import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/submit_button.dart';

class PartnerSetupScreen extends StatefulWidget {
  const PartnerSetupScreen({super.key});

  @override
  State<PartnerSetupScreen> createState() => _PartnerSetupScreenState();
}

class _PartnerSetupScreenState extends State<PartnerSetupScreen> {
  final auth = FirebaseAuth.instance;
  final TextEditingController inviteCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              auth.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/illustrations/partner_setup.png', scale: 4),

                Icon(
                  Icons.favorite_border_rounded,
                  color: Colors.redAccent,
                  size: 48,
                ),

                const SizedBox(height: 12),

                Text(
                  'Add your partner',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text('Connect with your partner to get started'),

                const SizedBox(height: 24),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.key,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text(
                                    'Enter Invite Code',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 250),
                                    child: TextField(
                                      controller: inviteCodeController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          SubmitButton(
                            color: Colors.deepOrange,
                            onSubmit: () async {
                              final relationshipService = RelationshipService();
                              if (inviteCodeController.text.trim().isNotEmpty) {
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

                                if (context.mounted) {
                                  showDialog(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (_) => AlertDialog(
                                      title: const Text("Unable to connect"),
                                      content: Text(message),
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Enter a valid code')),
                                );
                              }
                            },
                            message: 'Connect',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Row(
                    spacing: 4,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider()),
                      Text('  OR  '),
                      Expanded(child: Divider()),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 800),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 12,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.link,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onPrimary,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 8,
                                children: [
                                  Text(
                                    'Create Invite Code',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Generate and share an invite code with your partner.',
                                    style: TextStyle(fontSize: 16),
                                  ),

                                  const SizedBox(height: 12),
                                ],
                              ),
                            ],
                          ),

                          SubmitButton(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            onSubmit: () async {
                              final relationshipService = RelationshipService();

                              final result = await relationshipService
                                  .createInviteCode();

                              if (!mounted) return;

                              if (result == ('', '') && context.mounted) {
                                showDialog(
                                  context: context,
                                  builder: (_) => const AlertDialog(
                                    title: Text('Invite code already exists'),
                                    content: Text(
                                      'You already created or joined a relationship.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final (code, relationshipId) = result;

                              if (context.mounted) {
                                await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Invite Code'),
                                    content: SelectableText(
                                      code,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Clipboard.setData(
                                            ClipboardData(text: code),
                                          );

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Code copied to clipboard',
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('Copy'),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              await relationshipService
                                  .attachUserToRelationship(relationshipId);
                            },

                            message: 'Create Invite Code',
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
