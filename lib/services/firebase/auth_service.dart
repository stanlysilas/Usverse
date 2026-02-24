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

    debugPrint("User not yet initialized");

    userInitialized = true;

    debugPrint("User succesfully initialized");

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

      debugPrint('Completed Google Sign-in: ${userCredential.user!.email}');

      handleUserDocument(userCredential.user!);

      debugPrint('User creation completed');
      return userCredential;
    } catch (e) {
      debugPrint('Encountered an error while Google Sign-in: ${e.toString()}');
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
            body: Center(child: Text('Authenticating with your details')),
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
                body: Center(child: Text('Preparing your account')),
              );
            }

            return const AppRouter();
          },
        );
      },
    );
  }
}
