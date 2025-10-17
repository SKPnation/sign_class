import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/tutor/presentation/onboarding/pages/tutor_onboarding.dart';

class StudentOnboardingSmall extends StatefulWidget {
  const StudentOnboardingSmall({super.key});

  @override
  State<StudentOnboardingSmall> createState() => _StudentOnboardingSmallState();
}

class _StudentOnboardingSmallState extends State<StudentOnboardingSmall> {
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
        Get.to(TutorOnboarding());
      };

    onboardingController.totalSignedIn();
  }

  @override
  void dispose() {
    onSwitchRecognizer.dispose();
    super.dispose();
  }

  void changeUserType() =>
      onboardingController.currentUserType.value = AppStrings.tutor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gold,
      body: Center(
        child: SingleChildScrollView(
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
                text: AppStrings.student,
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
                    // Get.to(StudentSignIn());
                  },
                  text: "Sign In",
                  textColor: AppColors.white,
                  bgColor: AppColors.purple,
                  fontSize: 16,
                ),
              ),

              SizedBox(height: 24),

              RichText(
                text: TextSpan(
                  text: "If you are a TUTOR, 👉",
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

              SizedBox(height: 40),

              FutureBuilder(
                future: onboardingController.getSignedInStudentsList(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: AppColors.gold),
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
                        CustomText(
                          text: "Signed-in Students",
                          size: AppFonts.baseSize,
                          color: AppColors.white,
                          weight: FontWeight.bold,
                        ),
                        SizedBox(height: 10),
                        ...students.map(
                              (student) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              // light background
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.amber,
                                // highlight circle
                                child: Text(
                                  "${student.fName!.substring(0, 1).toUpperCase()}${student.lName!.substring(0, 1).toUpperCase()}",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              title: Text(
                                '${firstName(student.fName!)} ${lastName(student.lName!)}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String firstName(String fName) {
    if (fName.length > 5) {
      // Uppercase first letter, keep rest except last 3, then mask with ***
      return "${fName[0].toUpperCase()}${fName.substring(1, fName.length - 3)}***";
    } else if (fName.length > 3 && fName.length <= 5) {
      // Uppercase first letter, keep rest except last 2, then mask with **
      return "${fName[0].toUpperCase()}${fName.substring(1, fName.length - 2)}**";
    } else {
      // If short, just uppercase first letter
      return fName[0].toUpperCase() + fName.substring(1);
    }
  }

  String lastName(String lName) {
    if (lName.length > 5) {
      // Uppercase first letter, keep rest except last 3, then mask with ***
      return "${lName[0].toUpperCase()}${lName.substring(1, lName.length - 3)}***";
    } else if (lName.length > 3 && lName.length <= 5) {
      // Uppercase first letter, keep rest except last 2, then mask with **
      return "${lName[0].toUpperCase()}${lName.substring(1, lName.length - 2)}**";
    } else {
      // If short, just uppercase first letter
      return lName[0].toUpperCase() + lName.substring(1);
    }
  }
}
