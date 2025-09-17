import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/responsiveness.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';
import 'package:sign_class/features/onboarding/presentation/widgets/onboarding_large.dart';
import 'package:sign_class/features/onboarding/presentation/widgets/onboarding_small.dart';

//change to onboarding
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final studentController = Get.put(StudentController());

  final onboardingController = OnboardingController.instance;

  late TapGestureRecognizer onSwitchRecognizer;

  @override
  void initState() {
    super.initState();

    // init recognizer
    onSwitchRecognizer =
        TapGestureRecognizer()
          ..onTap = () {
            changeUserType(); // your function
          };

    if (onboardingController.currentUserType.value != AppStrings.tutor) {
      onboardingController.totalSignedIn();
    }
  }

  @override
  void dispose() {
    onSwitchRecognizer.dispose();
    super.dispose();
  }

  void changeUserType() {
    if (onboardingController.currentUserType.value == AppStrings.tutor) {
      onboardingController.currentUserType.value = AppStrings.student;
    } else {
      onboardingController.currentUserType.value = AppStrings.tutor;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        padding: EdgeInsets.all(24),
        color: AppColors.purple,
        child: Stack(
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? OnboardingSmall(
                  onboardingController: onboardingController,
                  onSwitchRecognizer: onSwitchRecognizer,
                  studentController: studentController,
                )
                : OnboardingLarge(
                  onboardingController: onboardingController,
                  onSwitchRecognizer: onSwitchRecognizer,
                  studentController: studentController,
                ),

            Align(
              alignment: Alignment.bottomLeft,
              child: CustomText(text: "2", color: AppColors.purpleDarker),
            ),
          ],
        ),
      ),
    );
  }
}
