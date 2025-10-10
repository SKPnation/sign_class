import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/details/presentation/widgets/course_field.dart';
import 'package:sign_class/features/details/presentation/widgets/goal_field.dart';
import 'package:sign_class/features/details/presentation/widgets/tutor_field.dart';

class StudentDetailsView extends StatefulWidget {
  const StudentDetailsView({super.key, required this.studentController});

  final StudentController studentController;

  @override
  State<StudentDetailsView> createState() => _StudentDetailsViewState();
}

class _StudentDetailsViewState extends State<StudentDetailsView> {
  final detailsController = Get.put(DetailsController());

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Goal field
          GoalField(
            detailsController: detailsController,
            onChanged: () => setState(() {}),
          ),

          SizedBox(height: 8),

          //Course field
          CourseField(
            detailsController: detailsController,
            onChanged: () => setState(() {}),
          ),

          SizedBox(height: 8),

          Obx((){
            if (detailsController.selectedCourse.value != null){
              return TutorField(detailsController: detailsController);
            }
            else{
              return SizedBox.shrink();
            }

          }),

          SizedBox(height: 24),
          SizedBox(
            child: CustomButton(
              onPressed: () async {
                if (widget.studentController.register.value) {
                  widget.studentController.addStudent(
                    detailsController.selectedCourse.value!,
                    detailsController.selectedTutor?.value,
                  );
                } else {
                  await widget.studentController.signIn(
                    detailsController.selectedCourse.value!,
                    tutor: detailsController.selectedTutor?.value,
                  );
                }
              },
              text: "Sign in",
              textColor: AppColors.white,
              bgColor: AppColors.purple,
              fontSize: AppFonts.baseSize,
            ),
          ),

          SizedBox(height: 8),

          SizedBox(
            child: CustomButton(
              onPressed: () {
                Get.back();
              },
              text: "Go back",
              textColor: AppColors.white,
              bgColor: AppColors.purple,
              fontSize: AppFonts.baseSize,
            ),
          ),
        ],
      ),
    );
  }
}
