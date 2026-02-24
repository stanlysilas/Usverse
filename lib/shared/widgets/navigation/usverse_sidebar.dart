import 'package:flutter/material.dart';
import 'package:usverse/models/usverse_navigation_items.dart';
import 'package:usverse/shared/widgets/buttons/usverse_icon_button.dart';
import 'package:usverse/shared/widgets/usverse_list_tile.dart';

class UsverseSidebar extends StatefulWidget {
  final int selectedIndex;
  final List<UsverseNavigationItem> items;
  final ValueChanged<int> onItemSelected;

  const UsverseSidebar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<UsverseSidebar> createState() => _UsverseSidebarState();
}

class _UsverseSidebarState extends State<UsverseSidebar> {
  bool extended = true;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOutCubic,
      width: extended ? 260 : 72,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border(
          right: BorderSide(color: colors.outlineVariant, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 2.0,
              ),
              child: Row(
                mainAxisAlignment: extended
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  if (extended)
                    Flexible(
                      child: UsverseIconButton(
                        onTap: () {
                          debugPrint(
                            'This is a button for the app icon, placeholder for now.',
                          );
                        },
                        icon: Icons.logo_dev_rounded,
                      ),
                    ),

                  if (extended) Flexible(child: Text('Usverse')),

                  if (extended) const Spacer(),

                  Flexible(
                    child: UsverseIconButton(
                      onTap: () {
                        setState(() => extended = !extended);
                      },
                      icon: Icons.view_sidebar_rounded,
                      message: extended ? 'Close sidebar' : 'Open sidebar',
                      mouseCursor: extended
                          ? SystemMouseCursors.resizeLeft
                          : SystemMouseCursors.resizeRight,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            ...List.generate(widget.items.length, (index) {
              final item = widget.items[index];

              return UsverseListTile(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                leading: Icon(item.icon, size: 20),
                title: extended ? item.label : '',
                selected: widget.selectedIndex == index,
                onTap: () => widget.onItemSelected(index),
                extended: extended,
              );
            }),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
