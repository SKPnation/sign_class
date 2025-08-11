import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/details/presentation/widgets/course_field.dart';
import 'package:sign_class/features/details/presentation/widgets/tutor_field.dart';
import 'package:sign_class/features/home/presentation/controllers/home_controller.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final detailsController = Get.put(DetailsController());
  final studentController = Get.put(StudentController());
  final homeController = Get.put(HomeController());

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
            SizedBox(height: 24),
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

                  if (studentController.register.value) {
                    studentController.addStudent(
                      detailsController.selectedCourse!.value,
                      detailsController.selectedTutor?.value
                    );
                  } else {
                    await studentController.signIn(
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
        ),
      ),
    );
  }
}
