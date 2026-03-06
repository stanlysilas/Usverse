import 'package:flutter/material.dart';
import 'package:usverse/core/theme/theme_controller.dart';
import 'package:usverse/core/theme/theme_scope.dart';

extension ThemeX on BuildContext {
  ThemeController get themeController => ThemeScope.of(this);

  ColorScheme get colors => Theme.of(this).colorScheme;

  TextTheme get text => Theme.of(this).textTheme;
}
