import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_snackbar.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/tutor_controller.dart';

class TutorView extends StatefulWidget {
  const TutorView({super.key});

  @override
  State<TutorView> createState() => _TutorViewState();
}

class _TutorViewState extends State<TutorView> {
  final tutorController = Get.put(TutorController());

  var existsByName = true;
  var emailErrorText = "";

  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> pickStartTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => startTime = picked);
  }

  Future<void> pickEndTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) setState(() => endTime = picked);
  }

  void setAvailability() async{
    if (selectedDay != null && startTime != null && endTime != null) {
      await tutorController.setSchedule(selectedDay!, startTime!, endTime!);
      CustomSnackBar.successSnackBar(
        body:
            "Availability set for $selectedDay from ${startTime!.format(context)} to ${endTime!.format(context)}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  ImageElements.pvamuLogo,
                  width: 180,
                  height: 160,
                  fit: BoxFit.contain, // Ensure image fits
                ),
              ),

              SizedBox(height: 40),
              if (tutorController.tutor.value == null) ...[
                SizedBox(
                  width: displayWidth(context) / 1.4,
                  child: TextField(
                    controller: tutorController.emailTEC,
                    onChanged: (value) {
                      if (!tutorController.isPvamuEmail(value)) {
                        emailErrorText = AppStrings.mustBePvamuEmail;
                      } else {
                        emailErrorText = "";
                      }

                      setState(() {});
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      // aligns to the top-left
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                if (emailErrorText.isNotEmpty)
                  Text(emailErrorText, style: TextStyle(color: Colors.red)),

                SizedBox(height: 16),

                SizedBox(
                  width: 200,
                  child: CustomButton(
                    onPressed: () => tutorController.signIn(),
                    text: "Sign In",
                  ),
                ),
              ],

              if (tutorController.tutor.value != null) ...[
                Text(
                  "Signed in as: ${tutorController.tutor.value?.name}",
                  style: const TextStyle(color: AppColors.black, fontSize: 16),
                ),

                // Student List
                const SizedBox(height: 20),
                const Text(
                  "Booked Students",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                tutorController.students.isEmpty
                    ? CustomText(text: "None")
                    : ListView.builder(
                      shrinkWrap: true,
                      itemCount: tutorController.students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(tutorController.students[index].name!),
                          textColor: Colors.white,
                        );
                      },
                    ),

                const SizedBox(height: 20),
                const Text(
                  "Set Availability",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                DropdownButton<String>(
                  dropdownColor: AppColors.white,
                  hint: const Text("Select Day"),
                  value: selectedDay,
                  items:
                      ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
                          .map(
                            (day) =>
                                DropdownMenuItem(value: day, child: Text(day)),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => selectedDay = value),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 200,
                  child: CustomButton(
                    bgColor: AppColors.white,
                    showBorder: false,
                    onPressed: () => pickStartTime(context),
                    child: CustomText(
                      text:
                          startTime == null
                              ? "Pick Start Time"
                              : "Start: ${startTime!.format(context)}",
                      color: AppColors.purple,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                SizedBox(
                  width: 200,
                  child: CustomButton(
                    bgColor: AppColors.white,
                    showBorder: false,
                    onPressed: () => pickEndTime(context),
                    child: CustomText(
                      text:
                          endTime == null
                              ? "Pick End Time"
                              : "End: ${endTime!.format(context)}",
                      color: AppColors.purple,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: 200,
                  child: CustomButton(
                    bgColor: AppColors.gold,
                    onPressed: setAvailability,
                    child: CustomText(text: "Set", color: AppColors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
