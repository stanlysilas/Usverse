import 'package:flutter/material.dart';
import 'package:usverse/features/memories/widgets/memory_card.dart';
import 'package:usverse/models/memory_model.dart';

class TimelineItem extends StatelessWidget {
  final MemoryModel memory;
  final bool isFirst;
  final bool isLast;

  const TimelineItem({
    super.key,
    required this.memory,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 2,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: _TimelineCardWrapper(memory: memory),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineCardWrapper extends StatelessWidget {
  final MemoryModel memory;

  const _TimelineCardWrapper({required this.memory});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).colorScheme.surfaceContainerHighest;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Transform.translate(
          offset: const Offset(16, 0),
          child: Transform.rotate(
            angle: 0.785398,
            child: Container(width: 18, height: 18, color: cardColor),
          ),
        ),
        Expanded(child: MemoryCard(memory: memory)),
      ],
    );
  }
}
