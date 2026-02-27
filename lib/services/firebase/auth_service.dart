import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/features/app/app_router.dart';
import 'package:usverse/features/auth/screens/login_screen.dart';
import 'package:usverse/services/firebase/firestore_service.dart';

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreService firestoreService = FirestoreService();
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

  bool userInitialized = false;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<void> handleUserDocument(User? user) async {
    if (userInitialized) return;

    userInitialized = true;

    await firestoreService.createOrUpdateUser(user!);
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      googleAuthProvider.addScope('email');
      googleAuthProvider.setCustomParameters({'prompt': 'select_account'});

      userCredential = await FirebaseAuth.instance.signInWithPopup(
        googleAuthProvider,
      );

      handleUserDocument(userCredential.user!);

      return userCredential;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Authenticating with your details',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return LoginScreen(
            onLogin: () async {
              await signInWithGoogle();
            },
          );
        }

        return FutureBuilder(
          future: firestoreService.createOrUpdateUser(user),
          builder: (context, initSnapshot) {
            if (initSnapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(
                  child: Text(
                    'Preparing your account',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              );
            }

            return const AppRouter();
          },
        );
      },
    );
  }
}
