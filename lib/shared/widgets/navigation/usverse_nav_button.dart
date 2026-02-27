import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/models/usverse_navigation_items.dart';

class UsverseNavButton extends StatefulWidget {
  final UsverseNavigationItem item;
  final bool selected;
  final VoidCallback onTap;

  const UsverseNavButton({
    super.key,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  State<UsverseNavButton> createState() => _UsverseNavButtonState();
}

class _UsverseNavButtonState extends State<UsverseNavButton> {
  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final color = widget.selected ? colors.primary : colors.onSurfaceVariant;

    final scale = widget.selected ? 1.15 : 1.0;

    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: Tooltip(
            message: widget.item.label,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  scale: scale,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.easeOut,
                  child: HugeIcon(icon: widget.item.icon, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
