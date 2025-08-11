import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class CourseField extends StatefulWidget {
  const CourseField({super.key, required this.detailsController, this.onChanged});

  final DetailsController detailsController;
  final Function()? onChanged;

  @override
  State<CourseField> createState() => _CourseFieldState();
}

class _CourseFieldState extends State<CourseField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth(context) / 1.4,
      child: FutureBuilder(
        future: widget.detailsController.getCourses(),
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

          var selectedCourse = widget.detailsController.selectedCourse?.value;
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
                  if (widget.detailsController.selectedCourse == null) {
                    widget.detailsController.selectedCourse = Rx<Course>(
                      course,
                    );
                  } else {
                    widget.detailsController.selectedCourse!.value = course;
                  }
                }
              });

              widget.onChanged!();
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
    );
  }
}
