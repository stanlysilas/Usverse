import 'package:flutter/material.dart';
import 'package:usverse/features/auth/auth_providers.dart';

class AuthButton extends StatefulWidget {
  final Function() onSubmit;
  final String message;
  final TextStyle? messageTextStyle;
  final AuthProviders authProviders;
  final BoxDecoration? boxDecoration;
  const AuthButton({
    super.key,
    required this.onSubmit,
    required this.message,
    required this.authProviders,
    this.boxDecoration,
    this.messageTextStyle,
  });

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool isLoading = false;

  final String googleProviderIcon = 'assets/auth_providers/google_logo.png';
  final String appleProviderIcon = '';

  Future<void> _handleTap() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    debugPrint('isLoading: $isLoading');

    try {
      await widget.onSubmit();
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
        debugPrint('isLoading: $isLoading');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : _handleTap,
      splashColor: Colors.transparent,
      hoverColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      focusColor: Theme.of(context).colorScheme.surfaceContainer,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: 300,
        height: 52,
        padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        alignment: Alignment.center,
        decoration:
            widget.boxDecoration ??
            BoxDecoration(
              border: Border.all(color: Colors.grey.shade700),
              borderRadius: BorderRadius.circular(100),
            ),
        child: isLoading
            ? SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    widget.authProviders == AuthProviders.google
                        ? googleProviderIcon
                        : appleProviderIcon,
                    scale: 46,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.message,
                    style:
                        widget.messageTextStyle ??
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ],
              ),
      ),
    );
  }
}
