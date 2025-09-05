import 'package:flutter/material.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/features/auth/presentation/widgets/student_view.dart';
import 'package:sign_class/features/auth/presentation/widgets/tutor_view.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final onboardingController = OnboardingController.instance;

  @override
  Widget build(BuildContext context) {
    if(onboardingController.currentUserType.value == AppStrings.tutor){
      return TutorView();
    }else{
      return StudentView();
    }
  }
}
