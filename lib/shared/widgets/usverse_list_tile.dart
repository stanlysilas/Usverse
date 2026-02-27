import 'package:flutter/material.dart';

class UsverseListTile extends StatefulWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool selected;
  final bool extended;
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
    this.subtitle,
    required this.selected,
    required this.extended,
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

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final backgroundColor = widget.selected
        ? (widget.selectedColor ?? colors.surfaceContainerHigh)
        : _hovered
        ? (widget.backgroundColor ?? colors.surfaceContainerHighest)
        : Colors.transparent;

    final foregroundColor =
        widget.foregroundColor ??
        (widget.selected ? colors.onPrimaryContainer : colors.onSurface);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Tooltip(
          message: !widget.extended ? widget.title : '',
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeOut,
            margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 4),
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: widget.extended
                ? _extendedLayout(foregroundColor)
                : _collapsedLayout(),
          ),
        ),
      ),
    );
  }

  Widget _extendedLayout(Color foregroundColor) {
    return Row(
      spacing: 12,
      children: [
        if (widget.leading != null) ...[Flexible(child: widget.leading!)],
        if (widget.extended)
          Flexible(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: widget.selected
                        ? FontWeight.w500
                        : FontWeight.w400,
                    color: foregroundColor,
                  ),
                ),
                if (widget.subtitle != null)
                  Text(
                    widget.subtitle!,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
        if (widget.trailing != null) ...[Flexible(child: widget.trailing!)],
      ],
    );
  }

  Widget _collapsedLayout() {
    return Center(child: widget.leading);
  }
}
