import 'package:flutter/material.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';

class UserTypesPage extends StatelessWidget {
  UserTypesPage({super.key});

  final onboardingController = OnboardingController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(ImageElements.pvamuLogo, height: 200, width: 200),

                  const SizedBox(height: 15),

                  CustomText(
                    text: AppStrings.slogan,
                    color: AppColors.grey[300],
                    size: 22,
                    fontStyle: FontStyle.italic,
                    weight: FontWeight.bold,
                  ),

                  const SizedBox(height: 20),

                  ShaderMask(
                    shaderCallback:
                        (bounds) => LinearGradient(
                      colors: [
                        AppColors.gold, // Gold
                        AppColors.purple,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(
                      Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                    ),
                    child: CustomText(
                      text: AppStrings.appTitle,
                      color: Colors.white,
                      // Important: must be set, even if overridden
                      size: 28,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 60),

                  SizedBox(
                      width: 300,
                      child: Column(
                        children: [
                          CustomText(text: "Select your role type", size: AppFonts.baseSize),
                          const SizedBox(height: 16),
                          CustomButton(onPressed: ()=>onboardingController.chooseTutor(), text: "Tutor", bgColor: AppColors.purple),
                          SizedBox(height: 8),
                          CustomButton(onPressed: ()=>onboardingController.chooseStudent(), text: "Student", bgColor: AppColors.gold),
                          SizedBox(height: 8),
                        ],
                      )
                  )


                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomLeft,
              child: CustomText(text: "1.0.0+2", color: AppColors.purpleDarker),
            ),
          ],
        )
    );
  }
}
