import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class TutorField extends StatefulWidget {
  const TutorField({super.key, required this.detailsController});

  final DetailsController detailsController;

  @override
  State<TutorField> createState() => _TutorFieldState();
}

class _TutorFieldState extends State<TutorField> {
  String? selectedTutorId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: displayWidth(context) / 1.4,
      child: DropdownButtonFormField<String>(
        value: selectedTutorId,
        items:
        (widget.detailsController.selectedCourse?.value.assignedTutors ?? []).map((
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
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: 'Select tutor',
          floatingLabelBehavior: FloatingLabelBehavior.always,
          floatingLabelAlignment: FloatingLabelAlignment.start,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
