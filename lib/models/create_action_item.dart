import 'package:flutter/widgets.dart';

class CreateActionItem {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const CreateActionItem({
    this.leading,
    required this.title,
    this.subtitle,
    required this.onTap,
  });
}
