import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

class FirebaseService {
  static bool isReady = false;
  static bool usingEmulator = false;

  static Future<void> initialize() async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      const useEmulator = bool.fromEnvironment(
        'USE_FIRESTORE_EMULATOR',
        defaultValue: true,
      );

      if (useEmulator) {
        FirebaseFirestore.instance.useFirestoreEmulator('127.0.0.1', 8080);
        FirebaseFirestore.instance.settings = const Settings(
          persistenceEnabled: false,
        );
        usingEmulator = true;
      }

      isReady = true;
    } catch (error) {
      debugPrint('Firebase not initialized: $error');
      isReady = false;
    }
  }
}