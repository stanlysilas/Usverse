import 'package:flutter/material.dart';
import 'package:usverse/models/usverse_navigation_items.dart';
import 'package:usverse/shared/widgets/navigation/usverse_nav_button.dart';

class UsverseNavigationBar extends StatelessWidget {
  final List<UsverseNavigationItem> items;
  final int currentIndex;
  final ValueChanged<int> onChanged;

  const UsverseNavigationBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          border: Border(
            top: BorderSide(color: colors.outlineVariant, width: 0.5),
          ),
        ),
        child: Row(
          children: List.generate(
            items.length,
            (index) => UsverseNavButton(
              item: items[index],
              selected: index == currentIndex,
              onTap: () => onChanged(index),
            ),
          ),
        ),
      ),
    );
  }
}
