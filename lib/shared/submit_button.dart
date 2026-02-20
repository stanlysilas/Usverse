import 'package:flutter/material.dart';

class SubmitButton extends StatefulWidget {
  final Future<void> Function() onSubmit;
  final String message;
  final Color color;

  const SubmitButton({
    super.key,
    required this.onSubmit,
    required this.message,
    required this.color,
  });

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool isLoading = false;

  Future<void> _handleTap() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      await widget.onSubmit();
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: isLoading ? null : _handleTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isLoading ? widget.color.withAlpha(120) : widget.color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: isLoading
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(widget.message),
      ),
    );
  }
}
