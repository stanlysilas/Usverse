import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:usverse/features/auth/auth_providers.dart';
import 'package:usverse/shared/widgets/buttons/auth_button.dart';

class LoginScreen extends StatelessWidget {
  final Function() onLogin;
  LoginScreen({super.key, required this.onLogin});

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.topLeft,
        children: [
          SvgPicture.asset(
            'assets/logos/usverse_logo.svg',
            width: 180,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.onSurface,
              BlendMode.srcIn,
            ),
          ),

          Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 420, maxHeight: 420),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(24),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.favorite_rounded,
                        color: Colors.redAccent,
                        size: 42,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Log in or sign up',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: 250,
                        child: Text(
                          'Create a shared space for your relationship.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),

                      const SizedBox(height: 32),

                      AuthButton(
                        onSubmit: onLogin,
                        message: 'Continue with Google',
                        authProviders: AuthProviders.google,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Wrap(
          alignment: WrapAlignment.center,
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
      ),
    );
  }
}
