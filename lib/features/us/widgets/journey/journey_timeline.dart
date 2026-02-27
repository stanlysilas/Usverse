import 'package:flutter/material.dart';
import 'package:usverse/models/memory_model.dart';
import 'journey_node.dart';

class JourneyTimeline extends StatelessWidget {
  final List<MemoryModel> milestones;

  const JourneyTimeline({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 160,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Container(height: 2, color: colors.outlineVariant),
              ),
            ),
            Row(
              children: List.generate(milestones.length, (index) {
                final memory = milestones[index];
                final isTop = index.isEven;

                return SizedBox(
                  width: 140,
                  child: Align(
                    alignment: isTop
                        ? Alignment.topCenter
                        : Alignment.bottomCenter,
                    child: JourneyNode(memory: memory, isTop: isTop),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
