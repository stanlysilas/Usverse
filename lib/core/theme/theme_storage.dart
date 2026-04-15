import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';

class ThemeStorage {
  static const _boxName = 'settings';
  static const _key = 'themeMode';

  static Future<Box> _openBox() async {
    return Hive.openBox(_boxName);
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = await _openBox();
    await box.put(_key, mode);
  }

  static Future<ThemeMode?> loadThemeMode() async {
    final box = await _openBox();
    return box.get(_key) as ThemeMode?;
  }
}
