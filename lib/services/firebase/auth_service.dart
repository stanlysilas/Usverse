import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:usverse/features/auth/login_screen.dart';
import 'package:usverse/features/setup/partner_setup_screen.dart';

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  final ActionCodeSettings actionCodeSettings = ActionCodeSettings(
    url: 'https://usverse-dev.web.app/login',
    handleCodeInApp: true,
  );

  @override
  void initState() {
    super.initState();
    completeEmailLinkSignIn();
  }

  Stream<User?> get authStateChanges => auth.authStateChanges();

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> signIn(String email) async {
    await auth.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emailForSignIn', email);
  }

  Future<void> completeEmailLinkSignIn() async {
    final link = Uri.base.toString();

    if (!auth.isSignInWithEmailLink(link)) return;

    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('emailForSignIn');

    if (email == null) return;

    await auth.signInWithEmailLink(email: email, emailLink: link);

    await prefs.remove('emailForSignIn');
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: const CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const PartnerSetupScreen();
        }

        return LoginScreen(onLogin: signIn);
      },
    );
  }
}
