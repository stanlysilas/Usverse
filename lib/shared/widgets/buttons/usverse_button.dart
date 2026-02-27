import 'dart:async';
import 'package:flutter/material.dart';

class UsverseButton extends StatefulWidget {
  final FutureOr<void> Function() onSubmit;
  final String message;
  final Color color;
  final Size? size;
  final bool? useBorder;

  const UsverseButton({
    super.key,
    required this.onSubmit,
    required this.message,
    required this.color,
    this.size,
    this.useBorder = false,
  });

  @override
  State<UsverseButton> createState() => _UsverseButtonState();
}

class _UsverseButtonState extends State<UsverseButton> {
  bool isLoading = false;
  bool hovered = false;
  bool pressed = false;

  Size get _effectiveSize => widget.size ?? const Size(350, 52);

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
    final baseColor = widget.color;

    final backgroundColor = pressed
        ? baseColor.withAlpha(75)
        : hovered
        ? baseColor.withAlpha(90)
        : baseColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) {
        setState(() {
          hovered = false;
          pressed = false;
        });
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        onTapCancel: () => setState(() => pressed = false),
        onTap: isLoading ? null : _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          constraints: BoxConstraints(
            minWidth: _effectiveSize.width,
            minHeight: _effectiveSize.height,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isLoading ? baseColor.withAlpha(60) : backgroundColor,
            borderRadius: BorderRadius.circular(100),
            border: widget.useBorder!
                ? Border.all(color: Colors.grey.shade700)
                : null,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.message, key: const ValueKey('text')),
          ),
        ),
      ),
    );
  }
}
