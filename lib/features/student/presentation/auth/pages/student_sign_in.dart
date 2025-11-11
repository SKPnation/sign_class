import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/presentation/auth/controllers/student_auth_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/pages/purpose_page.dart';

class StudentSignIn extends StatefulWidget {
  const StudentSignIn({super.key});

  @override
  State<StudentSignIn> createState() => _StudentSignInState();
}

class _StudentSignInState extends State<StudentSignIn> {
  final studentAuthController = StudentAuthController.instance;
  final onboardingController = OnboardingController.instance;

  var existsByEmail = true;
  var emailErrorText = "";
  
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.gold,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                ImageElements.pvamuLogo,
                width: 180,
                height: 160,
                fit: BoxFit.contain, // Ensure image fits
              ),

              SizedBox(height: 80),
              CustomText(
                text: "${AppStrings.student} sign in",
                size: 18,
                color: AppColors.white,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: studentAuthController.emailTEC,
                          onChanged: (value) async {
                            if (!studentAuthController.isPvamuEmail(value)) {
                              emailErrorText = AppStrings.mustBePvamuEmail;
                            } else {
                              emailErrorText = "";
                            }

                            studentAuthController.onTextChanged(value);
                            setState(() {});
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: "abc@pvamu.edu",
                            hintStyle: TextStyle(color: AppColors.grey[200]),
                            labelStyle: TextStyle(color: AppColors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                          ),
                        ),

                        if (emailErrorText.isNotEmpty)
                          Text(
                            emailErrorText,
                            style: TextStyle(color: Colors.red),
                          ),
                      ],
                    ),

                    //first name field
                    if ((studentAuthController.filteredEmail != null &&
                        studentAuthController.filteredEmail?.value != null) ||
                        !existsByEmail &&
                            studentAuthController.isValidPvamuEmail(
                              studentAuthController.emailTEC.text,
                            ))
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        // width: displayWidth(context) / 1.4,
                        child: TextField(
                          controller: studentAuthController.firstNameTEC,
                          onChanged: studentAuthController.onTextChanged,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'First name',
                            labelStyle: TextStyle(color: AppColors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            floatingLabelAlignment:
                            FloatingLabelAlignment.start,
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

                    //laST name field
                    if ((studentAuthController.filteredEmail != null &&
                        studentAuthController.filteredEmail?.value != null) ||
                        !existsByEmail &&
                            studentAuthController.isValidPvamuEmail(
                              studentAuthController.emailTEC.text,
                            ))
                      Container(
                        margin: EdgeInsets.only(top: 12),
                        // width: displayWidth(context) / 1.4,
                        child: TextField(
                          controller: studentAuthController.lastNameTEC,
                          onChanged: studentAuthController.onTextChanged,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Last name',
                            labelStyle: TextStyle(color: AppColors.black),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
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

                    SizedBox(height: 24),

                    SizedBox(
                      width: 250,
                      child: CustomButton(
                        onPressed: () async {
                          existsByEmail =
                          await studentAuthController
                              .doesUserExistByEmail();

                          if (studentAuthController
                              .firstNameTEC
                              .text
                              .isNotEmpty &&
                              studentAuthController
                                  .lastNameTEC
                                  .text
                                  .isNotEmpty &&
                              studentAuthController.emailTEC.text.isNotEmpty &&
                              studentAuthController.isPvamuEmail(
                                studentAuthController.emailTEC.text,
                              )) {
                            Get.to(PurposePage());
                          } else if (existsByEmail) {
                            Get.to(PurposePage());
                          }

                          setState(() {});
                        },
                        text: "Next",
                        textColor:
                        AppColors.white,
                        bgColor: AppColors.purple,
                        fontSize: AppFonts.baseSize,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
