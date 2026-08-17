import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Demo Firebase options for the Firestore emulator (and as a stub until
/// `flutterfire configure` generates a real project).
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'demo-api-key',
    appId: '1:0:web:demo',
    messagingSenderId: '0',
    projectId: 'plugin-pos-demo',
    storageBucket: 'plugin-pos-demo.appspot.com',
  );

  static const FirebaseOptions android = web;
  static const FirebaseOptions ios = web;
  static const FirebaseOptions macos = web;
}