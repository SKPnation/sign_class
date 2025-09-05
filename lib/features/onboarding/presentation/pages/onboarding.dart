import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

//change to onboarding
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final studentController = Get.put(StudentController());

  final onboardingController = OnboardingController.instance;

  @override
  void initState() {
    if (onboardingController.currentUserType.value != AppStrings.tutor) {
      onboardingController.totalSignedIn();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(24),
        color: AppColors.purple,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                ImageElements.pvamuLogo,
                width: 180,
                height: 160,
                fit: BoxFit.contain, // Ensure image fits
              ),
            ),

            Obx(
              () => CustomText(
                text: onboardingController.currentUserType.value,
                size: 28,
                color: AppColors.white,
              ),
            ),

            SizedBox(height: 16),

            SizedBox(
              width: 300,
              child: CustomButton(
                onPressed: () {
                  studentController.authPageTitle.value = AppStrings.signIn;
                  Get.toNamed(Routes.authenticationPageRoute);
                },
                text: "Sign In",
                textColor: AppColors.purple,
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 300,
              child: CustomButton(
                onPressed: () async {
                  studentController.authPageTitle.value = AppStrings.signOut;
                  Get.toNamed(Routes.authenticationPageRoute);
                },
                text: "Sign Out",
                textColor: AppColors.purple,
              ),
            ),

            SizedBox(height: 16),
            SizedBox(
              width: 300,
              child: CustomButton(
                bgColor: AppColors.white,
                onPressed: () async {
                  //..
                },
                text:
                    onboardingController.currentUserType.value == AppStrings.tutor
                        ? AppStrings.isNotTutor
                        : AppStrings.isTutor,
                textColor: AppColors.purple,
              ),
            ),

            SizedBox(height: 80),

            Obx(() {
              if (onboardingController.currentUserType.value != AppStrings.tutor) {
                return Text(
                  "${onboardingController.numOfSignedInStudents.value}",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
