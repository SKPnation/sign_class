import 'package:flutter/material.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';

class GoalField extends StatefulWidget {
  const GoalField({super.key, required this.purposeController, this.onChanged});

  final PurposeController purposeController;
  final Function()? onChanged;

  @override
  State<GoalField> createState() => _GoalFieldState();
}

class _GoalFieldState extends State<GoalField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: widget.purposeController.selectedGoal.value.isEmpty
          ? null
          : widget.purposeController.selectedGoal.value,
      selectedItemBuilder: (context) {
        return widget.purposeController.options.map((goal) {
          return Text(
            goal,
            style: TextStyle(color: AppColors.white), // selected value
          );
        }).toList();
      },
      items: widget.purposeController.options.map((goal) => DropdownMenuItem<String>(
        value: goal,
        child: Text(
          goal,// dropdown items text color
        ),
      )).toList(),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            widget.purposeController.selectedGoal.value = value;
          }
        });
        widget.onChanged!();
      },
      hint: Text(
        "Select your activity",
        style: TextStyle(color: AppColors.black),
      ),
      decoration: InputDecoration(
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
