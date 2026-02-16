import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final Function() onSubmit;
  final String message;
  final Color color;
  const SubmitButton({
    super.key,
    required this.onSubmit,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSubmit,
      child: Container(
        padding: EdgeInsets.all(12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(message),
      ),
    );
  }
}
