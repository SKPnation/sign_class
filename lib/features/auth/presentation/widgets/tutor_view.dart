import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_alert_dialog.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_snackbar.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/tutor_controller.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class TutorView extends StatefulWidget {
  const TutorView({super.key});

  @override
  State<TutorView> createState() => _TutorViewState();
}

class _TutorViewState extends State<TutorView> {
  final tutorController = Get.put(TutorController());
  final onboardingController = Get.put(OnboardingController());

  var existsByEmail = true;
  var emailErrorText = "";

  var sortedEntries = <MapEntry<String, dynamic>>[];

  // Correct weekday order
  final List<String> weekdayOrder = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
        // setState(() {
        //   studentController.filteredEmails.clear(); // hide suggestion box
        // });
      },
      child: Material(
        child: Obx((){
          if (tutorController.availability.isNotEmpty) {
            // Sort the map into a list of entries based on weekday order
            sortedEntries = tutorController.availability.entries.toList()
              ..sort((a, b) =>
                  weekdayOrder.indexOf(a.key.toLowerCase())
                      .compareTo(weekdayOrder.indexOf(b.key.toLowerCase())));
          }

          return Container(
            padding: EdgeInsets.all(24),
            color: AppColors.purple,
            child: Column(
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
                SizedBox(height: 80),
                Text(
                  "${AppStrings.tutor} ${AppStrings.signIn}",
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      //tutor is not "signed in" state
                      if (tutorController.tutor.value == null) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              // width: displayWidth(context) / 1.4,
                              child: TextField(
                                controller: tutorController.emailTEC,
                                onChanged: (value) async {
                                  if (!tutorController.isPvamuEmail(value)) {
                                    emailErrorText = AppStrings.mustBePvamuEmail;
                                  } else {
                                    emailErrorText = "";
                                  }

                                  // tutorController.onTextChanged(value);
                                  setState(() {});
                                },
                                style: TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintText: "abc@pvamu.edu",
                                  hintStyle: TextStyle(
                                    color: AppColors.grey[200],
                                  ),
                                  labelStyle: TextStyle(
                                    color: AppColors.grey[200],
                                  ),
                                  floatingLabelBehavior:
                                  FloatingLabelBehavior.auto,
                                  floatingLabelAlignment:
                                  FloatingLabelAlignment.start,

                                  // define a single border style to reuse
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: AppColors.white,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (emailErrorText.isNotEmpty)
                              Text(
                                emailErrorText,
                                style: TextStyle(color: Colors.red),
                              ),
                          ],
                        ),
                        SizedBox(height: 24),

                        CustomButton(onPressed: () =>tutorController.signIn(), text: "Sign In"),
                      ],

                      //tutor is "signed in" state
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

                        tutorController.availability.isNotEmpty ?
                        SizedBox(
                          width: 200,
                          child: CustomButton(
                            bgColor: AppColors.gold,
                            onPressed: () {
                              Get.dialog(CustomAlertDialog(
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("My availability")],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: sortedEntries.map((e) {
                                      var heading = e.key;
                                      var body = e.value;

                                      return Column(
                                        children: [
                                          Text(
                                            heading[0].toUpperCase() + heading.substring(1), // Capitalize
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                          Text(
                                            body.toString(),
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  )));
                            },
                            child: CustomText(text: "View", color: AppColors.white),
                          ),
                        ) : SizedBox()
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
