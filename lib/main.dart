import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/app.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';
import 'package:sign_class/core/utils/firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use options so web is happy; works for all platforms
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Option A: register controller after Firebase is ready
  Get.put<OnboardingController>(OnboardingController());
  Get.put<TutorAuthController>(TutorAuthController());

  runApp(const App());
}