import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';

void main() {
  Get.put(ThemeController());
  Get.put(AuthController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeController().isDarkMode.value
              ? ThemeData.dark()
              : ThemeData.light(),
          initialRoute: '/login',
          getPages: [
            GetPage(name: '/login', page: () => LoginScreen()),
            GetPage(name: '/home', page: () => HomeScreen()),
          ],
        ));
  }
}
