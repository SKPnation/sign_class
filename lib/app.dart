import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/theme/colors.dart';

import 'core/helpers/navigation/controllers_binding.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(body: Center(child: Text("Page Not Found"))),
      ),      theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBinding(),
    );
  }
}
