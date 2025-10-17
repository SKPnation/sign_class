import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/tutor/presentation/onboarding/pages/tutor_onboarding.dart';

class SignOutSuccessPage extends StatelessWidget {
  const SignOutSuccessPage({super.key, this.userName, this.timeSpent});

  final String? userName;
  final String? timeSpent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                        Image.asset(ImageElements.pvamuLogo, height: 200, width: 200),

            const SizedBox(height: 60),
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            CustomText(
              text: "Goodbye, ${userName!}",
                size: 22,
              weight: FontWeight.bold,
            ),
                        SizedBox(height: 8),
            CustomText(
              text: "Signed out successfully",
              size: 18,
            ),
            SizedBox(height: 8),

            CustomText(text: "Time spent: $timeSpent", size: 16),
            SizedBox(height: 30),

            SizedBox(width: 250,
            child: CustomButton(
              onPressed: () {
                Get.off(TutorOnboarding());
              },
              text: "Done",
              textColor: AppColors.white,
              fontSize: 16,
            ))
          ],
        ),
      ),
    );
  }
}
