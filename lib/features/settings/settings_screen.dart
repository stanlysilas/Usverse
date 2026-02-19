import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({super.key});

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.logout_rounded),
                  title: Text('Log out of Usverse'),
                  onTap: () {
                    auth.signOut();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
