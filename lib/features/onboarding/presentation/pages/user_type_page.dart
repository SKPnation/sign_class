import 'package:flutter/material.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class UserTypePage extends StatelessWidget {
  UserTypePage({super.key});

  final onboardingController = OnboardingController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(onPressed: ()=>onboardingController.chooseTutor(), text: "I am a tutor", bgColor: AppColors.purple),
              SizedBox(height: 8),
              CustomButton(onPressed: ()=>onboardingController.chooseStudent(), text: "I am a student", bgColor: AppColors.gold),
              SizedBox(height: 8),
            ],
          ),
        )
      )
    );
  }
}
