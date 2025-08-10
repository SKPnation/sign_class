import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
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
            SizedBox(height: 24),

            SizedBox(
              width: displayWidth(context) / 1.4,
              child: FutureBuilder(
                future: detailsController.getCourses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Color(0xFF43A95D),
                        ),
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

                  var courses = snapshot.data as List<Course>;

                  var selectedCourse = detailsController.selectedCourse?.value;
                  String? selectedCourseId;

                  if (selectedCourse != null &&
                      selectedCourse.name != null &&
                      selectedCourse.name!.isNotEmpty) {
                    // Find course by name in the fetched list
                    try {
                      selectedCourseId =
                          courses
                              .firstWhere((c) => c.name == selectedCourse.name)
                              .id;
                    } catch (e) {
                      // If no course matches, leave selectedCourseId null
                      selectedCourseId = null;
                    }
                  } else {
                    selectedCourseId = null;
                  }

                  return DropdownButtonFormField<String>(
                    value: selectedCourseId,
                    items:
                        courses.map((course) {
                          return DropdownMenuItem<String>(
                            value: course.id,
                            child: Text("${course.category} - ${course.name}"),
                          );
                        }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value != null) {
                          final course = courses.firstWhere(
                            (course) => course.id == value,
                          );
                          if (detailsController.selectedCourse == null) {
                            detailsController.selectedCourse = Rx<Course>(
                              course,
                            );
                          } else {
                            detailsController.selectedCourse!.value = course;
                          }
                        }
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Select course',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 24),
            SizedBox(
              width: displayWidth(context) / 1.4,
              child: CustomButton(
                onPressed: () async {
                  if (studentController.register.value) {
                    studentController.addStudent(
                      detailsController.selectedCourse!.value,
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
