import 'package:flutter/material.dart';

class UsverseIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final String? message;
  final double iconSize;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;

  const UsverseIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 42,
    this.iconSize = 24,
    this.foregroundColor,
    this.backgroundColor,
    this.hoverColor,
    this.message = '',
    this.mouseCursor = SystemMouseCursors.click,
  });

  @override
  State<UsverseIconButton> createState() => _UsverseIconButtonState();
}

class _UsverseIconButtonState extends State<UsverseIconButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final backgroundColor = _pressed
        ? colors.surfaceContainerHighest
        : _hovered
        ? (widget.hoverColor ?? colors.surfaceContainerHigh)
        : widget.backgroundColor ?? Colors.transparent;

    final foregroundColor = widget.foregroundColor ?? colors.onSurface;

    return MouseRegion(
      cursor: widget.mouseCursor!,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: Tooltip(
        message: widget.message,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                widget.icon,
                size: widget.iconSize,
                color: foregroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
