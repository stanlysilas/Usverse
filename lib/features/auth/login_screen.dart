import 'package:flutter/material.dart';
import 'package:usverse/features/auth/auth_providers.dart';
import 'package:usverse/shared/auth_button.dart';

class LoginScreen extends StatelessWidget {
  final Function() onLogin;
  LoginScreen({super.key, required this.onLogin});

  final emailController = TextEditingController();

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
              Icon(Icons.favorite_border_rounded, color: Colors.redAccent),

              const SizedBox(height: 12),

              Text(
                'Welcome to Usverse',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text('Sign in to continue'),

              const SizedBox(height: 52),

              AuthButton(
                onSubmit: onLogin,
                message: 'Sign in with Google',
                authProviders: AuthProviders.google,
                boxDecoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),

              const SizedBox(height: 52),

              Wrap(
                children: [
                  Text('By signing in, you agree to our '),

                  InkWell(
                    onTap: () {
                      debugPrint('Show the Terms of Service to user.');
                    },
                    child: Text(
                      'Terms of Service',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),

                  Text(' and '),

                  InkWell(
                    onTap: () {
                      debugPrint('Show the Privacy Policy to the user.');
                    },
                    child: Text(
                      'Privacy Policy.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
