import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/crypto/relationship_key_provider.dart';
import 'package:usverse/core/theme/mesh_gradient_background.dart';
import 'package:usverse/services/firebase/relationship_service.dart';
import 'package:usverse/shared/widgets/buttons/usverse_button.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';

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

          Center(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;

                final content = Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),
                  child: isWide
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _LeftColumn(
                                inviteCodeController: inviteCodeController,
                              ),
                            ),

                            const SizedBox(width: 24),

                            Expanded(child: _RightColumn()),
                          ],
                        )
                      : Column(
                          children: [
                            _LeftColumn(
                              inviteCodeController: inviteCodeController,
                            ),
                            const SizedBox(height: 20),
                            _RightColumn(),
                          ],
                        ),
                );

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1920),
                    child: SingleChildScrollView(child: content),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  final TextEditingController inviteCodeController;
  const _LeftColumn({required this.inviteCodeController});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedKey01,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'Enter Invite Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                'Connect with your partner to get started.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              TextField(
                controller: inviteCodeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              UsverseButton(
                color: Colors.deepOrange,
                onSubmit: () async {
                  final relationshipService = RelationshipService();
                  if (inviteCodeController.text.trim().isNotEmpty) {
                    final result = await relationshipService.joinWithInviteCode(
                      inviteCodeController.text.trim(),
                    );

                    if (result == null) {
                      return;
                    }

                    String message = switch (result) {
                      "INVALID_CODE" => "Invalid invite code.",
                      "SELF_JOIN" => "You cannot join your own invite.",
                      "ALREADY_CONNECTED" =>
                        "This relationship already has two partners.",
                      "ALREADY_IN_RELATIONSHIP" => "You are already connected.",
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
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(24),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedLink01,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  Text(
                    'Create Invite Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Text(
                'Generate and share an invite code with your partner.',
                style: TextStyle(fontSize: 16),
              ),

              const SizedBox(height: 24),

              UsverseButton(
                color: Theme.of(context).colorScheme.primaryContainer,
                onSubmit: () async {
                  final relationshipService = RelationshipService();

                  final result = await relationshipService.createInviteCode();

                  if (!context.mounted) return;

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
                              Clipboard.setData(ClipboardData(text: code));

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Code copied to clipboard'),
                                ),
                              );
                            },
                            child: const Text('Copy'),
                          ),
                        ],
                      ),
                    );
                  }

                  await relationshipService.attachUserToRelationship(
                    relationshipId,
                  );
                },

                message: 'Create Invite Code',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
