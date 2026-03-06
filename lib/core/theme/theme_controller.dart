import 'package:flutter/material.dart';
import 'package:usverse/core/theme/theme_storage.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  ThemeMode get mode => _mode;

  bool get isLight => _mode == ThemeMode.light;
  bool get isDark => _mode == ThemeMode.dark;
  bool get isSystem => _mode == ThemeMode.system;

  Future<void> load() async {
    final stored = await ThemeStorage.loadThemeMode();
    if (stored != null) {
      _mode = stored;
      notifyListeners();
    }
  }

  void setTheme(ThemeMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    notifyListeners();
    await ThemeStorage.saveThemeMode(mode);
  }

  void toggleTheme() {
    if (_mode == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  Brightness resolveBrightness(BuildContext context) {
    if (_mode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context);
    }
    return _mode == ThemeMode.dark ? Brightness.dark : Brightness.light;
  }
}
