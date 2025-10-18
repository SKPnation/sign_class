import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/student/presentation/auth/controllers/student_auth_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/widgets/course_field.dart';
import 'package:sign_class/features/student/presentation/purpose/widgets/goal_field.dart';
import 'package:sign_class/features/student/presentation/purpose/widgets/tutor_field.dart';

class PurposePage extends StatefulWidget {
  const PurposePage({super.key});

  @override
  State<PurposePage> createState() => _PurposePageState();
}

class _PurposePageState extends State<PurposePage> {
  final purposeController = Get.put(PurposeController());
  final studentAuthController = Get.put(StudentAuthController());

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

              SizedBox(height: 80),

              //Goal field
              SizedBox(
                width: 340,
                child: GoalField(
                  purposeController: purposeController,
                  onChanged: () => setState(() {}),
                ),
              ),

              SizedBox(height: 8),

              //Course field
              SizedBox(
                width: 340,
                child: CourseField(
                  purposeController: purposeController,
                  onChanged: () => setState(() {}),
                ),
              ),

              SizedBox(height: 8),

              Obx(() {
                if (purposeController.selectedCourse.value != null) {
                  return SizedBox(
                    width: 340,
                    child: TutorField(purposeController: purposeController),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }),

              SizedBox(height: 24),
              SizedBox(
                width: 250,
                child: CustomButton(
                  onPressed: () async {
                    // if (studentAuthController.register.value) {
                    //   studentAuthController.addStudent(
                    //     purposeController.selectedCourse.value!,
                    //     purposeController.selectedTutor?.value,
                    //   );
                    // } else {
                    //   await studentAuthController.signIn(
                    //     purposeController.selectedCourse.value!,
                    //     tutor: purposeController.selectedTutor?.value,
                    //   );
                    // }
                  },
                  text: "Check in",
                  textColor: AppColors.white,
                  bgColor: AppColors.purple,
                  fontSize: AppFonts.baseSize,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
