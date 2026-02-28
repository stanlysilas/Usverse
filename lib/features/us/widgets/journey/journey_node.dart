import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usverse/features/memories/widgets/encrypted_memory_image.dart';
import 'package:usverse/models/memory_model.dart';
import 'package:usverse/shared/widgets/dialogs/usverse_feature_dialog.dart';

class JourneyNode extends StatefulWidget {
  final MemoryModel memory;
  final bool isTop;

  const JourneyNode({super.key, required this.memory, required this.isTop});

  @override
  State<JourneyNode> createState() => _JourneyNodeState();
}

class _JourneyNodeState extends State<JourneyNode> {
  bool hovered = false;
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final date = widget.memory.memoryDate;

    final title = widget.memory.milestoneTitle?.isNotEmpty == true
        ? widget.memory.milestoneTitle!
        : widget.memory.caption;

    final scale = pressed
        ? 0.94
        : hovered
        ? 1.08
        : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => hovered = true),
      onExit: (_) => setState(() {
        hovered = false;
        pressed = false;
      }),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => pressed = true),
        onTapUp: (_) => setState(() => pressed = false),
        onTapCancel: () => setState(() => pressed = false),
        onTap: () => showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => UsverseFeatureDialog(
            image: EncryptedMemoryImage(
              imageUrl: widget.memory.mediaUrl,
              nonce: widget.memory.nonce,
              mac: widget.memory.mac,
            ),
            title: title,
            description:
                "Milestone from: ${DateFormat('EEE d, yy').format(widget.memory.memoryDate)} at ${DateFormat('h:mm a').format(widget.memory.memoryDate)}",
            cancelText: 'Close',
          ),
        ),
        child: SizedBox(
          width: 140,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: widget.isTop
                    ? Alignment.topCenter
                    : Alignment.bottomCenter,
                child: _TitleBlock(title: title!, date: date),
              ),
              AnimatedScale(
                duration: const Duration(milliseconds: 120),
                curve: Curves.easeOut,
                scale: scale,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOut,
                  width: 32,
                  height: 32,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: hovered
                        ? colors.primaryContainer
                        : colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(widget.memory.icon ?? '❤️'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final DateTime date;

  const _TitleBlock({required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: colors.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "${date.day}/${date.month}/${date.year}",
          style: TextStyle(fontSize: 11, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
