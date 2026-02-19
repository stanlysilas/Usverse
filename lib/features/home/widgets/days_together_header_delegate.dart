import 'package:flutter/material.dart';
import 'package:usverse/features/home/widgets/days_together_card.dart';
import 'package:usverse/models/relationship_model.dart';

class DaysTogetherHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Relationship relationship;

  DaysTogetherHeaderDelegate({required this.relationship});

  @override
  double get maxExtent => 260;

  @override
  double get minExtent => 120;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = shrinkOffset / (maxExtent - minExtent);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Transform.scale(
        scale: 1 - (progress * 0.1),
        alignment: Alignment.topCenter,
        child: DaysTogetherCard(relationship: relationship),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant DaysTogetherHeaderDelegate oldDelegate) {
    return oldDelegate.relationship != relationship;
  }
}
