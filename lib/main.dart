import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:usverse/services/firebase/auth_service.dart';
import 'core/env/app_config.dart';
import 'core/env/environment.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.env = Environment.dev;

  await Firebase.initializeApp(options: AppConfig.firebaseOptions);

  runApp(const UsverseApp());
}

class UsverseApp extends StatelessWidget {
  const UsverseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      title: 'Usverse',
      home: AuthService(),
    );
  }
}
