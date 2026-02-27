import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AvatarButton extends StatefulWidget {
  final String? photo;
  final String? message;
  final int size;
  final VoidCallback onTap;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? hoverColor;

  const AvatarButton({
    super.key,
    required this.photo,
    required this.size,
    required this.onTap,
    this.foregroundColor,
    this.backgroundColor,
    this.hoverColor,
    this.message,
  });

  @override
  State<AvatarButton> createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return avatar(widget.photo);
  }

  Widget avatar(String? url) {
    final colors = Theme.of(context).colorScheme;

    final backgroundColor = _pressed
        ? colors.surfaceContainerHighest
        : _hovered
        ? (widget.hoverColor ?? colors.surfaceContainerHigh)
        : widget.backgroundColor ?? Colors.transparent;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) {
        setState(() {
          _hovered = false;
          _pressed = false;
        });
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onTap,
        child: Tooltip(
          message: widget.message ?? '',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipOval(
              child: url == null
                  ? const HugeIcon(icon: HugeIcons.strokeRoundedUser)
                  : CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, _, _) =>
                          const HugeIcon(icon: HugeIcons.strokeRoundedUser),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
