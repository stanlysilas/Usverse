import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:usverse/core/theme/app_theme_host.dart';
import 'package:usverse/core/theme/theme_mode_adapter.dart';
import 'package:usverse/services/firebase/auth_service.dart';
import 'core/env/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: AppConfig.firebaseOptions);

  await Hive.initFlutter();
  Hive.registerAdapter(ThemeModeAdapter());

  runApp(const AppThemeHost(child: AuthService()));
}
