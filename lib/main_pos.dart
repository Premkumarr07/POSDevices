import 'package:flutter/material.dart';

import 'core/services/firebase_service.dart';
import 'modules/pos/pos_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(const PosApp());
}
