import 'package:flutter/material.dart';
import 'package:usverse/core/theme/color_schemes.dart';

class AppTheme {
  static const String fontFamily = 'Plus Jakarta Sans';

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: crimsonLightColorScheme,
      fontFamily: fontFamily,
      brightness: Brightness.light,
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: crimsonDarkColorScheme,
      fontFamily: fontFamily,
      brightness: Brightness.dark,
    );
  }
}
