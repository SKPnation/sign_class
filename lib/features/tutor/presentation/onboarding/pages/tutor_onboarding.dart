import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/presentation/onboarding/pages/student_onboarding.dart';
import 'package:sign_class/features/tutor/presentation/auth/pages/tutor_sign_in.dart';

class TutorOnboarding extends StatefulWidget {
  const TutorOnboarding({super.key});

  @override
  State<TutorOnboarding> createState() => _TutorOnboardingState();
}

class _TutorOnboardingState extends State<TutorOnboarding> {
  final onboardingController = OnboardingController.instance;

  late TapGestureRecognizer onSwitchRecognizer;

  @override
  void initState() {
    super.initState();

    // init recognizer
    onSwitchRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            changeUserType();
            Get.to(StudentOnboarding());
          };
  }

  @override
  void dispose() {
    onSwitchRecognizer.dispose();
    super.dispose();
  }

  void changeUserType() =>
    onboardingController.currentUserType.value = AppStrings.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purple,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageElements.pvamuLogo,
              width: 180,
              height: 160,
              fit: BoxFit.contain, // Ensure image fits
            ),

            const SizedBox(height: 80),

            CustomText(
              text: AppStrings.tutor,
              size: 18,
              color: AppColors.white,
              weight: FontWeight.bold,
            ),

            SizedBox(height: 24),

            SizedBox(
              width: 300,
              child: CustomButton(
                onPressed: () {
                  //Go to tutor sign in page
                  Get.to(TutorSignIn());
                },
                text: "Sign In",
                textColor: AppColors.purple,
                bgColor: AppColors.gold,
                fontSize: 16,
              ),
            ),

            SizedBox(height: 24),

            RichText(
              text: TextSpan(
                text: "If you are a STUDENT, 👉",
                style: TextStyle(color: Colors.white, fontSize: 16),
                children: [
                  TextSpan(
                    recognizer: onSwitchRecognizer,
                    text: " click here",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
