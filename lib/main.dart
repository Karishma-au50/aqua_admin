import 'package:admin/features/auth/views/login_screen.dart';
import 'package:admin/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // home: LoginScreen(),
      initialRoute: AppRoutes.login,
      getPages: AppPages.routes,
    );
  }
}
