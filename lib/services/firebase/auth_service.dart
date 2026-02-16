import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:usverse/features/app/app_router.dart';
import 'package:usverse/features/auth/login_screen.dart';
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

      return userCredential;
    } catch (e) {
      return null;
    }
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
          final user = snapshot.data;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            handleUserDocument(user);
          });

          return const AppRouter();
        }

        return LoginScreen(onLogin: signInWithGoogle);
      },
    );
  }
}
