import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class TutorField extends StatefulWidget {
  final DetailsController detailsController;
  const TutorField({super.key, required this.detailsController});

  @override
  State<TutorField> createState() => _TutorFieldState();
}

class _TutorFieldState extends State<TutorField> {
  double getDynamicHeight(String text) {
    // Similar logic to CourseField: taller when text is longer
    int lines = (text.length / 30).ceil();
    return (lines * 26.0) + 30.0;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tutors = widget.detailsController.selectedCourse.value?.assignedTutors ?? [];
      final selectedTutorId = widget.detailsController.selectedTutor?.value.id;

      final bool hasTutors = tutors.isNotEmpty;
      final hintText = hasTutors
          ? "Select tutor"
          : "No assigned tutors\nCheck Student Success Center (CL WILSON 208)";

      // Calculate height dynamically for longer text
      final fieldHeight = getDynamicHeight(hintText);

      return Container(
        height: fieldHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 1, color: Colors.white),
        ),
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: hasTutors ? selectedTutorId : null,
          icon: hasTutors ? const Icon(Icons.arrow_drop_down_sharp) : const SizedBox.shrink(),
          items: tutors.map((tutor) {
            return DropdownMenuItem<String>(
              value: tutor.id,
              child: Text(tutor.name ?? 'Unknown'),
            );
          }).toList(),
          onChanged: hasTutors
              ? (value) {
            if (value == null) return;
            final tutor = tutors.firstWhere((t) => t.id == value);
            widget.detailsController.selectedTutor?.value = tutor;
          }
              : null,
          hint: Center(
            child: Text(
              hintText,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: null,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppFonts.baseSize + 1,
                height: 1.3,
              ),
            ),
          ),
          alignment: Alignment.center,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    });
  }
}
