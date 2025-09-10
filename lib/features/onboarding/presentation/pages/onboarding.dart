import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
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
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Obx(() {
                if (onboardingController.currentUserType.value !=
                    AppStrings.tutor) {
                  return Text(
                    "${onboardingController.numOfSignedInStudents.value} students still signed in",
                    style: TextStyle(
                      fontSize: AppFonts.baseSize,
                      color: AppColors.white,
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    ImageElements.pvamuLogo,
                    width: 180,
                    height: 160,
                    fit: BoxFit.contain, // Ensure image fits
                  ),

                  const SizedBox(height: 80),


                  Obx(
                        () => CustomText(
                      text: "${onboardingController.currentUserType.value} login",
                      size: 18,
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: 24),

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
                        studentController.authPageTitle.value =
                            AppStrings.signOut;
                        Get.toNamed(Routes.authenticationPageRoute);
                      },
                      text: "Sign Out",
                      textColor: AppColors.purple,
                    ),
                  ),

                  SizedBox(height: 24),

                  RichText(
                    text: TextSpan(
                      text: "If you are a ${onboardingController.currentUserType.value == AppStrings.tutor ? "STUDENT" : "TUTOR"}, 👉",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      children: [
                        TextSpan(
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

                  SizedBox(height: 80),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
