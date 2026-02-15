import 'environment.dart';
import 'package:usverse/firebase_options_dev.dart';
import 'package:usverse/firebase_options_prod.dart';
import 'package:firebase_core/firebase_core.dart';

class AppConfig {
  static late Environment env;

  static FirebaseOptions get firebaseOptions {
    switch (env) {
      case Environment.dev:
        return DefaultFirebaseOptionsDev.currentPlatform;
      case Environment.prod:
        return DefaultFirebaseOptionsProd.currentPlatform;
    }
  }
}
