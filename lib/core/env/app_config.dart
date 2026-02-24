import 'environment.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:usverse/firebase_options_dev.dart';
import 'package:usverse/firebase_options_prod.dart';

class AppConfig {
  static final Environment env = _resolveEnvironment();

  static Environment _resolveEnvironment() {
    const value = String.fromEnvironment('ENV', defaultValue: 'dev');

    switch (value) {
      case 'prod':
        return Environment.prod;
      default:
        return Environment.dev;
    }
  }

  static FirebaseOptions get firebaseOptions {
    switch (env) {
      case Environment.dev:
        return DefaultFirebaseOptionsDev.currentPlatform;
      case Environment.prod:
        return DefaultFirebaseOptionsProd.currentPlatform;
    }
  }
}
