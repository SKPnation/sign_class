import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class OnboardingSmall extends StatelessWidget {
  const OnboardingSmall({
    super.key,
    required this.onboardingController,
    required this.onSwitchRecognizer,
    required this.studentController,
  });

  final OnboardingController onboardingController;
  final TapGestureRecognizer onSwitchRecognizer;
  final StudentController studentController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            if(onboardingController.currentUserType.value == AppStrings.tutor)
              const SizedBox(height: 100),

            Image.asset(
              ImageElements.pvamuLogo,
              width: 180,
              height: 160,
              fit: BoxFit.contain, // Ensure image fits
            ),

            const SizedBox(height: 80),

            Obx(
                  () =>
                  CustomText(
                    text:
                    "${onboardingController.currentUserType.value} login",
                    size: 18,
                    color: AppColors.white,
                  ),
            ),

            SizedBox(height: 24),

            SizedBox(
              width: 300,
              child: CustomButton(
                onPressed: () {
                  studentController.authPageTitle.value =
                      AppStrings.signIn;
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
                text:
                "If you are a ${onboardingController.currentUserType
                    .value == AppStrings.tutor ? "STUDENT" : "TUTOR"}, 👉",
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

            SizedBox(height: 60),

            if(onboardingController.currentUserType.value ==
                AppStrings.student)
              FutureBuilder(
                  future: onboardingController.getSignedInStudentsList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: AppColors.gold),
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }

                    if (!snapshot.hasData) {
                      return const SizedBox.shrink();
                    }

                    var students = snapshot.data as List<Student>;
                    students.sort((a, b) => b.timeIn!.compareTo(a.timeIn!));

                    return Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: AppColors.purpleDarker,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          CustomText(text: "Signed-in Students", size: AppFonts.baseSize,
                              color: AppColors.white, weight: FontWeight.bold),
                          SizedBox(height: 10),
                          ...students.map((student) =>
                              Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.2), // light background
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child:  ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.amber, // highlight circle
                                    child: Text(
                                      student.nameLower!.substring(0, 1).toUpperCase(),
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                  title: Text(
                                    student.nameLower ?? '',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    );
                  }
              )

          ],
        ),
      ),
    );
  }
}
