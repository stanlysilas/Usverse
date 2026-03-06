import 'package:flutter/material.dart';
import 'package:usverse/features/settings/widgets/theme_preferences_card.dart';
import 'package:usverse/features/settings/widgets/user_preferences_card.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;

            final content = Padding(
              padding: const EdgeInsets.all(16),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _LeftColumn()),
                        const SizedBox(width: 24),
                        Expanded(child: _RightColumn()),
                      ],
                    )
                  : Column(
                      children: [
                        _LeftColumn(),
                        const SizedBox(height: 20),
                        _RightColumn(),
                      ],
                    ),
            );

            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1920),
                child: SingleChildScrollView(child: content),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LeftColumn extends StatelessWidget {
  const _LeftColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [ThemePreferencesCard()],
    );
  }
}

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [UserPreferencesCard()],
    );
  }
}
