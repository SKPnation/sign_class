import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/auth/presentation/controllers/tutor_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/details/presentation/pages/student_details_view.dart';
import 'package:sign_class/features/details/presentation/pages/tutor_details_view.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final detailsController = Get.put(DetailsController());
  final studentController = Get.put(StudentController());
  final tutorController = Get.put(TutorController());
  final onboardingController = Get.put(OnboardingController());

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
            SizedBox(height: 80),

            SizedBox(width: 360,
            child: onboardingController.currentUserType.value == AppStrings.tutor
                ? TutorDetailsView()
                : StudentDetailsView(studentController: studentController)),


          ],
        ),
      ),
    );
  }
}
