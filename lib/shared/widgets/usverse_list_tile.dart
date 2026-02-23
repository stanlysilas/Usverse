import 'package:flutter/material.dart';

class UsverseListTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final TextStyle? titleTextStyle;
  final String? subtitle;
  final TextStyle? subtitleTextStyle;
  final bool initiallySelected;
  final VoidCallback? onTap;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const UsverseListTile({
    super.key,
    this.leading,
    required this.title,
    this.titleTextStyle,
    this.subtitle,
    this.subtitleTextStyle,
    this.initiallySelected = false,
    this.onTap,
    this.foregroundColor,
    this.backgroundColor,
    this.selectedColor,
    this.trailing,
    this.padding,
    this.margin,
  });

  @override
  State<UsverseListTile> createState() => _UsverseListTileState();
}

class _UsverseListTileState extends State<UsverseListTile> {
  bool _hovered = false;
  late bool _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected;
  }

  void _handleTap() {
    setState(() {
      _selected = !_selected;
    });

    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final Color backgroundColor = _selected
        ? (widget.selectedColor ?? colors.surfaceContainerHigh)
        : _hovered
        ? (widget.backgroundColor ?? colors.surfaceContainerHighest)
        : Colors.transparent;

    final Color foregroundColor =
        widget.foregroundColor ??
        (_selected ? colors.onPrimaryContainer : colors.onSurface);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (widget.leading != null) ...[
                widget.leading!,
                const SizedBox(width: 12),
              ],

              Expanded(
                child: Text(
                  widget.title,
                  style:
                      widget.titleTextStyle ??
                      TextStyle(
                        fontWeight: _selected
                            ? FontWeight.w500
                            : FontWeight.w400,
                        color: foregroundColor,
                      ),
                ),
              ),

              if (widget.trailing != null) ...[
                const SizedBox(width: 12),
                widget.trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
