import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class TutorField extends StatelessWidget {
  final DetailsController detailsController;

  const TutorField({super.key, required this.detailsController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tutors = detailsController.selectedCourse.value?.assignedTutors ?? [];
      final selectedTutorId = detailsController.selectedTutor?.value.id;

      return DropdownButtonFormField<String>(
        isExpanded: true,
        value: selectedTutorId,
        icon: tutors.isEmpty ? const SizedBox.shrink() : const Icon(Icons.arrow_drop_down_sharp),
        items: tutors.map((tutor) {
          return DropdownMenuItem<String>(
            value: tutor.id,
            child: Text(tutor.name ?? 'Unknown'),
          );
        }).toList(),
        onChanged: (value) {
          if (value == null) return;

          final tutor = tutors.firstWhere((tutor) => tutor.id == value);
          detailsController.selectedTutor?.value = tutor;
        },
        hint: Text(
          tutors.isEmpty ? "No Tutors" : "Select tutor",
          style: TextStyle(color: AppColors.grey[200]),
        ),
        style: const TextStyle(color: Colors.white), // Selected text is white
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: tutors.isEmpty ? 36 : 12, horizontal: 12),
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
        ),
      );
    });
  }
}
