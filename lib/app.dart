import 'package:firebase_core/firebase_core.dart';
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
  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyD--sT_bY-9dXT2dgAhymsAEPCEdFYh7BM",
        authDomain: "pvamu-student-sign-in.firebaseapp.com",
        projectId: "pvamu-student-sign-in",
        storageBucket: "pvamu-student-sign-in.firebasestorage.app",
        messagingSenderId: "757260583433",
        appId: "1:757260583433:web:627fe15ebb56e11865eed8",
        measurementId: "G-K99SQFSL9H",
      ),
    );
  }

  @override
  void initState() {
    initializeDefault();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => const Scaffold(body: Center(child: Text("Page Not Found"))),
      ),
      theme: ThemeData(scaffoldBackgroundColor: AppColors.white),
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      initialBinding: AllControllerBinding(),
    );
  }
}
