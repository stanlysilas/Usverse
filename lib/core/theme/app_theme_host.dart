import 'package:flutter/material.dart';
import 'theme_controller.dart';
import 'theme_scope.dart';
import 'app_theme.dart';

class AppThemeHost extends StatefulWidget {
  final Widget child;

  const AppThemeHost({super.key, required this.child});

  @override
  State<AppThemeHost> createState() => _AppThemeHostState();
}

class _AppThemeHostState extends State<AppThemeHost> {
  final ThemeController controller = ThemeController();
  bool ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await controller.load();
    setState(() => ready = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!ready) {
      return const SizedBox.shrink();
    }

    return ThemeScope(
      controller: controller,
      child: AnimatedBuilder(
        animation: controller,
        builder: (_, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: controller.mode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: widget.child,
          );
        },
      ),
    );
  }
}
