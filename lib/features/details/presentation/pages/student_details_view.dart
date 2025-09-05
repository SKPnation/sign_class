import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/details/presentation/widgets/course_field.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: displayWidth(context) / 1.4,
          child: TextField(
            controller: detailsController.whyTEC,
            maxLines: 3,
            // onChanged: detailsController.onTextChanged,
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              labelText: 'Type your reason...',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              floatingLabelAlignment: FloatingLabelAlignment.start,
              // aligns to the top-left
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        SizedBox(height: 16),

        CourseField(detailsController: detailsController, onChanged: ()=>setState(() {}),),

        SizedBox(height: 16),

        if(detailsController.selectedCourse != null)
          TutorField(detailsController: detailsController),

        SizedBox(height: 24),
        SizedBox(
          width: displayWidth(context) / 1.4,
          child: CustomButton(
            onPressed: () async {

              if (widget.studentController.register.value) {
                widget.studentController.addStudent(
                    detailsController.selectedCourse!.value,
                    detailsController.selectedTutor?.value
                );
              } else {
                await widget.studentController.signIn(
                  detailsController.selectedCourse!.value,
                );
              }
            },
            text: "Sign in",
            textColor: AppColors.purple,
            fontSize: 18,
          ),
        ),

        SizedBox(height: 24),

        SizedBox(
          width: displayWidth(context) / 1.4,
          child: CustomButton(
            onPressed: () {
              Get.back();
            },
            text: "Go back",
            textColor: AppColors.purple,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
