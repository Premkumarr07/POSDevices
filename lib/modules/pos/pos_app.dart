import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_theme.dart';
import '../../routes/app_pages.dart';
import '../../routes/app_routes.dart';

class PosApp extends StatelessWidget {
  const PosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plugin POS',
      theme: AppTheme.dark,
      initialRoute: AppRoutes.posActivation,
      getPages: AppPages.pos,
    );
  }
}
