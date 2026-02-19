import 'package:flutter/material.dart';
import 'package:usverse/features/messages/create_daily_message_sheet.dart';

class ResponsiveScaffold extends StatefulWidget {
  final List<Widget> pages;
  const ResponsiveScaffold({super.key, required this.pages});

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
    return Scaffold(
      body: Row(
        children: [
          if (useRail)
            NavigationRail(
              selectedIndex: selectedIndex,
              trailingAtBottom: true,
              onDestinationSelected: (index) {
                setState(() => selectedIndex = index);
                debugPrint(selectedIndex.toString());
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.home_rounded),
                  label: Text('Home'),
                ),
                // NavigationRailDestination(
                //   icon: Icon(Icons.favorite_rounded),
                //   label: Text('Memories'),
                // ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                ),
              ],
              trailing: FloatingActionButton.extended(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const CreateDailyMessageSheet(),
                ),
                label: Icon(Icons.add_rounded),
              ),
            ),

          Expanded(child: widget.pages[selectedIndex]),
        ],
      ),
      floatingActionButton: useRail
          ? null
          : FloatingActionButton.small(
              onPressed: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CreateDailyMessageSheet(),
              ),
              child: Icon(Icons.add_rounded),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                // NavigationDestination(
                //   icon: Icon(Icons.favorite_rounded),
                //   label: 'Memories',
                // ),
                NavigationDestination(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }
}
