import 'package:flutter/material.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';

class GoalField extends StatefulWidget {
  const GoalField({super.key, required this.detailsController, this.onChanged});

  final DetailsController detailsController;
  final Function()? onChanged;

  @override
  State<GoalField> createState() => _GoalFieldState();
}

class _GoalFieldState extends State<GoalField> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      value: widget.detailsController.selectedGoal.value.isEmpty
          ? null
          : widget.detailsController.selectedGoal.value,
      selectedItemBuilder: (context) {
        return widget.detailsController.options.map((goal) {
          return Text(
            goal,
            style: TextStyle(color: AppColors.white), // selected value
          );
        }).toList();
      },
      items: widget.detailsController.options.map((goal) => DropdownMenuItem<String>(
        value: goal,
        child: Text(
          goal,// dropdown items text color
        ),
      )).toList(),
      onChanged: (value) {
        setState(() {
          if (value != null) {
            widget.detailsController.selectedGoal.value = value;
          }
        });
        widget.onChanged!();
      },
      hint: Text(
        "Select your activity",
        style: TextStyle(color: AppColors.grey[200]),
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
