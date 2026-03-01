import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:usverse/core/theme/mesh_gradient_background.dart';
import 'package:usverse/features/home/home_screen.dart';
import 'package:usverse/features/memories/widgets/create_memory_sheet.dart';
import 'package:usverse/features/letters/create_daily_letter_sheet.dart';
import 'package:usverse/features/letters/letters_screen.dart';
import 'package:usverse/features/us/us_screen.dart';
import 'package:usverse/features/us/widgets/goals/create_shared_goals_dialog.dart';
import 'package:usverse/models/create_action_item.dart';
import 'package:usverse/models/usverse_navigation_items.dart';
import 'package:usverse/shared/sheets/create_action_sheet.dart';
import 'package:usverse/shared/widgets/navigation/usverse_navigation_bar.dart';
import 'package:usverse/shared/widgets/navigation/usverse_sidebar.dart';

class ResponsiveScaffold extends StatefulWidget {
  final String relationshipId;
  const ResponsiveScaffold({super.key, required this.relationshipId});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int selectedIndex = 0;

  static const double railBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool useRail = width >= railBreakpoint;

    final items = [
      UsverseNavigationItem(
        icon: HugeIcons.strokeRoundedHome01,
        label: 'Home',
        page: HomeScreen(),
      ),
      UsverseNavigationItem(
        icon: HugeIcons.strokeRoundedMail01,
        label: 'Letters',
        page: LettersScreen(relationshipId: widget.relationshipId),
      ),
      UsverseNavigationItem(
        icon: HugeIcons.strokeRoundedManWoman,
        label: 'Us',
        page: UsScreen(),
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          const MeshGradientBackground(),

          Row(
            children: [
              if (useRail)
                UsverseSidebar(
                  selectedIndex: selectedIndex,
                  onItemSelected: (index) {
                    setState(() => selectedIndex = index);
                  },
                  items: items,
                ),

              Expanded(child: items[selectedIndex].page),
            ],
          ),
        ],
      ),
      floatingActionButton: selectedIndex != 1
          ? FloatingActionButton(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                useSafeArea: true,
                builder: (_) => CreateActionSheet(
                  items: [
                    CreateActionItem(
                      leading: HugeIcon(icon: HugeIcons.strokeRoundedMail01),
                      title: 'Write Letter',
                      subtitle: 'Schedule a letter for 24 hours',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          useSafeArea: true,
                          builder: (_) => const CreateDailyLetterSheet(),
                        );
                      },
                    ),
                    CreateActionItem(
                      leading: HugeIcon(icon: HugeIcons.strokeRoundedClock01),
                      title: 'Memory',
                      subtitle: 'Save a moment together',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          useSafeArea: true,
                          builder: (_) => CreateMemorySheet(
                            relationshipId: widget.relationshipId,
                          ),
                        );
                      },
                    ),
                    CreateActionItem(
                      leading: HugeIcon(icon: HugeIcons.strokeRoundedTarget01),
                      title: 'Shared Goal',
                      subtitle: 'Create a shared goal together',
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          showDragHandle: true,
                          useSafeArea: true,
                          builder: (_) => CreateSharedGoalSheet(
                            relationshipId: widget.relationshipId,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              child: HugeIcon(icon: HugeIcons.strokeRoundedAdd01),
            )
          : null,
      extendBody: true,
      extendBodyBehindAppBar: true,
      bottomNavigationBar: useRail
          ? null
          : UsverseNavigationBar(
              currentIndex: selectedIndex,
              onChanged: (index) {
                setState(() => selectedIndex = index);
              },
              items: items,
            ),
    );
  }
}
