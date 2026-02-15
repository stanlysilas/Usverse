import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final Function(String email) onLogin;
  LoginScreen({super.key, required this.onLogin});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: emailController),
          ElevatedButton(
            onPressed: () {
              onLogin(emailController.text.trim());
            },
            child: const Text('Send Login Link'),
          ),
        ],
      ),
    );
  }
}
