import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class TutorField extends StatefulWidget {
  const TutorField({super.key, required this.detailsController, this.onChanged});

  final DetailsController detailsController;
  final Function()? onChanged;

  @override
  State<TutorField> createState() => _TutorFieldState();
}

class _TutorFieldState extends State<TutorField> {
  String? selectedTutorId;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: selectedTutorId,
      icon: (widget.detailsController.selectedCourse?.value.assignedTutors ?? []).isEmpty ?      const SizedBox.shrink()  // completely removes space
    : Icon(Icons.arrow_drop_down_sharp),
      selectedItemBuilder: (context) {
        return widget.detailsController.options.map((goal) {
          return Text(
            goal,
            style: TextStyle(color: AppColors.white), // selected value
          );
        }).toList();
      },
      items: (widget.detailsController.selectedCourse?.value.assignedTutors ?? []).map((
          tutor,
          ) {
        return DropdownMenuItem<String>(
          value: tutor.id,
          child: Text(tutor.name ?? 'Unknown'),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          if (value != null) {
            final tutor = widget
                .detailsController
                .selectedCourse!
                .value
                .assignedTutors!
                .firstWhere((tutor) => tutor.id == value);
            if (widget.detailsController.selectedTutor == null) {
              widget.detailsController.selectedTutor = Rx<Tutor>(tutor);
            } else {
              widget.detailsController.selectedTutor!.value = tutor;
            }
          }
        });
      },
      hint: Text(
        (widget.detailsController.selectedCourse?.value.assignedTutors ?? []).isEmpty ? AppStrings.noTutors : "Select tutor",
        style: TextStyle(color: AppColors.grey[200]),
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible, // allow wrapping
        maxLines: (widget.detailsController.selectedCourse?.value.assignedTutors ?? []).isEmpty ? 2 : 1, // or null for unlimited
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          vertical: 36, // increase this for more height
          horizontal: 12,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.start,
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
  }
}
