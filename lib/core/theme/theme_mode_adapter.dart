import 'package:flutter/material.dart';
import 'package:hive_ce/hive_ce.dart';

class ThemeModeAdapter extends TypeAdapter<ThemeMode> {
  @override
  final int typeId = 7;

  @override
  ThemeMode read(BinaryReader reader) {
    switch (reader.readInt()) {
      case 0:
        return ThemeMode.light;
      case 1:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeMode obj) {
    switch (obj) {
      case ThemeMode.light:
        writer.writeInt(0);
        break;
      case ThemeMode.dark:
        writer.writeInt(1);
        break;
      case ThemeMode.system:
        writer.writeInt(2);
        break;
    }
  }
}
