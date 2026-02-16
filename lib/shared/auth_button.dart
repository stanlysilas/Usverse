import 'package:flutter/material.dart';
import 'package:usverse/features/auth/auth_providers.dart';

class AuthButton extends StatelessWidget {
  final Function() onSubmit;
  final String message;
  final AuthProviders authProviders;
  final BoxDecoration boxDecoration;
  const AuthButton({
    super.key,
    required this.onSubmit,
    required this.message,
    required this.authProviders,
    required this.boxDecoration,
  });

  final String googleProviderIcon = 'assets/auth_providers/google_logo.png';
  final String appleProviderIcon = '';

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubmit,
      borderRadius: boxDecoration.borderRadius as BorderRadius,
      child: Container(
        width: 200,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        alignment: Alignment.center,
        decoration: boxDecoration,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              authProviders == AuthProviders.google
                  ? googleProviderIcon
                  : appleProviderIcon,
              scale: 20,
            ),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
      ),
    );
  }
}
