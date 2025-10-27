import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/responsiveness.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/widgets/work_schedule.dart';

class TutorField extends StatefulWidget {
  final PurposeController purposeController;

  const TutorField({super.key, required this.purposeController});

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
      final tutors =
          widget.purposeController.selectedCourse.value?.assignedTutors ?? [];
      final selectedTutorId = widget.purposeController.selectedTutor.value?.id;

      final bool hasTutors = tutors.isNotEmpty;
      final hintText =
          hasTutors
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
          initialValue: hasTutors ? selectedTutorId : null,
          icon:
              hasTutors
                  ? const Icon(Icons.arrow_drop_down_sharp)
                  : const SizedBox.shrink(),
          items:
              tutors.map((tutor) {
                // 1) Known weekday order
                const weekdayOrder = <String>[
                  'monday',
                  'tuesday',
                  'wednesday',
                  'thursday',
                  'friday',
                  'saturday',
                  'sunday',
                ];

                // 2) Get a non-null schedule map (string->dynamic)
                final Map<String, dynamic> schedule =
                    (tutor.workSchedule as Map?)?.map(
                      (k, v) => MapEntry(k.toString(), v),
                    ) ??
                    <String, dynamic>{};

                // 3) Build & sort safely
                final List<MapEntry<String, dynamic>> entries =
                    schedule.entries.toList()..sort((a, b) {
                      final ak = (a.key).toString().toLowerCase();
                      final bk = (b.key).toString().toLowerCase();

                      // -1 means "not found" -> push to bottom by using a large index
                      int ai = weekdayOrder.indexOf(ak);
                      int bi = weekdayOrder.indexOf(bk);
                      if (ai == -1) ai = 999;
                      if (bi == -1) bi = 999;

                      return ai.compareTo(bi);
                    });

                return DropdownMenuItem<String>(
                  value: tutor.id,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.white,
                          ),
                        ),

                        SizedBox(width: 8),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "${tutor.fName} ${tutor.lName}",
                              weight: FontWeight.bold,
                              size:
                                  ResponsiveWidget.isSmallScreen(context)
                                      ? AppFonts.defaultSize
                                      : AppFonts.baseSize,
                              color: AppColors.black,
                            ),
                            SizedBox(height: 2),
                            CustomText(
                              text: tutor.email!,
                              color: AppColors.black,
                            ),
                            SizedBox(height: 8),

                            WorkScheduleSection(sortedEntries: entries),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
          onChanged:
              hasTutors
                  ? (value) {
                    ///update the tutor rx variable with selected tutor model

                    if (value == null) return;
                    final tutor = tutors.firstWhere((t) => t.id == value);
                    widget.purposeController.selectedTutor.value = tutor;
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

          selectedItemBuilder: (context) {
            return tutors.map((tutor) {
              return Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${tutor.fName} ${tutor.lName}",
                  style: const TextStyle(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: AppFonts.baseSize,
                  ),
                ),
              );
            }).toList();
          },
        ),
      );
    });
  }
}
