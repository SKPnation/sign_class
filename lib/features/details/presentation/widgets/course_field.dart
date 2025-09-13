import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class CourseField extends StatefulWidget {
  const CourseField({
    super.key,
    required this.detailsController,
    this.onChanged,
  });

  final DetailsController detailsController;
  final Function()? onChanged;

  @override
  State<CourseField> createState() => _CourseFieldState();
}

class _CourseFieldState extends State<CourseField> {
  String? selectedCourseId;

  double getDynamicHeight(String text) {
    // Example: 20 px per line, with ~40 chars per line
    int lines = (text.length / 30).ceil();
    return (lines * 26.0) + 30.0;
    // return lines * 20.0 + 70; // base padding
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      height: widget.detailsController.selectedCourse.value == null ? null : getDynamicHeight(widget.detailsController.selectedCourse.value!.name!),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: FutureBuilder(
        future: widget.detailsController.getCourses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Color(0xFF43A95D)),
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
            selectedCourseId =
                widget.detailsController.selectedCourse.value!.id;
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

            dropdownItems.addAll(
              group.map((course) {
                return DropdownMenuItem<String>(
                  value: course.id,
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    direction: Axis.horizontal,
                    children: [
                      Text(
                        "${course.code} ",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text("- ${course.name}"),
                    ],
                  ),
                );
              }),
            );
          }

          return DropdownButtonFormField<String>(
            isExpanded: true,
            value: selectedCourseId,
            items:
            dropdownItems.map((item) {
              // Only style non-header items (skip disabled headers)
              if (item.enabled) {
                final isSelected = item.value == selectedCourseId;
                return DropdownMenuItem<String>(
                  value: item.value,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${courses.firstWhere((c) => c.id == item.value).code}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded( // allows wrapping
                        child: Text(
                          " - ${courses.firstWhere((c) => c.id == item.value).name}",
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: isSelected ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
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
              print(
                "selected course from list: ${course.id}: name:${course.code}",
              );
              print("selected course tutors: ${course.assignedTutors}");
            },

            hint: Text(
              "Select course",
              style: TextStyle(color: AppColors.grey[200]),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 12,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              // enabledBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(width: 1, color: AppColors.white),
              // ),
              // focusedBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(width: 1, color: AppColors.white),
              // ),
              // errorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(width: 1, color: Colors.red),
              // ),
              // focusedErrorBorder: OutlineInputBorder(
              //   borderRadius: BorderRadius.circular(10),
              //   borderSide: BorderSide(width: 1, color: Colors.red),
              // ),
            ),
          );
        },
      ),
    );
  }
}
