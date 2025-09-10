import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/theme/colors.dart';
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
  String? selectedCourseId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

          // initialize selectedCourseId only once
          if (selectedCourseId == null &&
              widget.detailsController.selectedCourse.value != null) {
            selectedCourseId = widget.detailsController.selectedCourse.value!.id;
          }


          // Grouping logic (unchanged)
          final groupOrder = ["CVEG", "MATH", "CHEM", "ELEG", "MCEG", "PHYS"];
          final groupedCourses = <String, List<Course>>{};
          for (var course in courses) {
            final prefix = groupOrder.firstWhere(
                  (p) => course.code!.startsWith(p),
              orElse: () => "OTHER",
            );
            groupedCourses.putIfAbsent(prefix, () => []).add(course);
          }

          // Flatten grouped items into one list
          final dropdownItems = <DropdownMenuItem<String>>[];

          for (var prefix in groupOrder) {
            final group = groupedCourses[prefix] ?? [];
            if (group.isEmpty) continue;

            // Group header (disabled)
            dropdownItems.add(
              DropdownMenuItem<String>(
                enabled: false,
                child: Text(
                  "$prefix COURSES",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.purple,
                  ),
                ),
              ),
            );

            dropdownItems.addAll(group.map((course) {
              return DropdownMenuItem<String>(
                value: course.id,
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "${course.code} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "- ${course.name}",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
          }

          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedCourseId,
            items: dropdownItems.map((item) {
              // Only style non-header items (skip disabled headers)
              if (item.enabled) {
                final isSelected = item.value == selectedCourseId;
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "${courses.firstWhere((c) => c.id == item.value).code} ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "- ${courses.firstWhere((c) => c.id == item.value).name}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: isSelected ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return item; // headers remain unchanged
            }).toList(),
            onChanged: (String? value) {
              if (value == null) return;

              setState(() => selectedCourseId = value);

              // Find the selected course
              final course = courses.firstWhere((c) => c.id == value);

              // Update the reactive variable directly
              widget.detailsController.selectedCourse.value = course;

              print("selected course: $value");
              print("selected course from list: ${course.id}: name:${course.code}");
              print("selected course tutors: ${course.assignedTutors}");

            },

            hint: Text(
              "Select course",
              style: TextStyle(color: AppColors.grey[200]),
            ),
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: AppColors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: AppColors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: AppColors.white),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 1, color: Colors.red),
              ),
            ),
          );

        },
      ),
    );
  }
}

