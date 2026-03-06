import 'package:flutter/material.dart';

enum AppThemeOption { light, dark, system }

extension AppThemeOptionX on AppThemeOption {
  ThemeMode get toThemeMode {
    switch (this) {
      case AppThemeOption.light:
        return ThemeMode.light;
      case AppThemeOption.dark:
        return ThemeMode.dark;
      case AppThemeOption.system:
        return ThemeMode.system;
    }
  }

  String get label {
    switch (this) {
      case AppThemeOption.light:
        return 'Light';
      case AppThemeOption.dark:
        return 'Dark';
      case AppThemeOption.system:
        return 'System';
    }
  }
}
