import 'package:flutter/material.dart';
import 'package:usverse/features/home/home_screen.dart';
import 'package:usverse/features/memories/widgets/create_memory_sheet.dart';
import 'package:usverse/features/messages/create_daily_message_sheet.dart';
import 'package:usverse/features/us/us_screen.dart';
import 'package:usverse/models/create_action_item.dart';
import 'package:usverse/models/usverse_navigation_items.dart';
import 'package:usverse/shared/sheets/create_action_sheet.dart';
import 'package:usverse/shared/widgets/navigation/usverse_sidebar.dart';

class ResponsiveScaffold extends StatefulWidget {
  final List<Widget> pages;
  final String relationshipId;
  const ResponsiveScaffold({
    super.key,
    required this.pages,
    required this.relationshipId,
  });

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int selectedIndex = 0;
  final items = [
    UsverseNavigationItem(
      icon: Icons.home_rounded,
      label: 'Home',
      page: HomeScreen(),
    ),
    UsverseNavigationItem(
      icon: Icons.favorite_rounded,
      label: 'Us',
      page: UsScreen(),
    ),
  ];

  static const double railBreakpoint = 800;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool useRail = width >= railBreakpoint;
    return Scaffold(
      body: Row(
        children: [
          if (useRail)
            UsverseSidebar(
              selectedIndex: selectedIndex,
              onItemSelected: (index) {
                setState(() => selectedIndex = index);
              },
              items: items,
            ),

          Expanded(child: widget.pages[selectedIndex]),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          showDragHandle: true,
          useSafeArea: true,
          builder: (_) => CreateActionSheet(
            items: [
              CreateActionItem(
                leading: Icon(Icons.schedule_send_rounded),
                title: 'Daily Message',
                subtitle: 'Schedule a message for 24 hours',
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    showDragHandle: true,
                    useSafeArea: true,
                    builder: (_) => const CreateDailyMessageSheet(),
                  );
                },
              ),
              CreateActionItem(
                leading: Icon(Icons.collections_rounded),
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
            ],
          ),
        ),
        child: Icon(Icons.add_rounded),
      ),
      bottomNavigationBar: useRail
          ? null
          : NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) {
                setState(() => selectedIndex = index);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_rounded),
                  label: 'Us',
                ),
              ],
            ),
    );
  }
}
