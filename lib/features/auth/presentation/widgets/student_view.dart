import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';

class StudentView extends StatefulWidget {
  const StudentView({super.key});

  @override
  State<StudentView> createState() => _StudentViewState();
}

class _StudentViewState extends State<StudentView> {
  StudentController studentController = Get.put(StudentController());

  var existsByEmail = true;
  var emailErrorText = "";

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
        child: Container(
          padding: EdgeInsets.all(24),
          color: AppColors.purple,
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
                SizedBox(height: 80),
                Text(
                  studentController.authPageTitle.value,
                  style: TextStyle(color: AppColors.white, fontSize: 18),
                ),
                SizedBox(height: 24),

                SizedBox(
                  width: 300,
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            // width: displayWidth(context) / 1.4,
                            child: TextField(
                              controller: studentController.emailTEC,
                              onChanged: (value) async {
                                if (!studentController.isPvamuEmail(value)) {
                                  emailErrorText = AppStrings.mustBePvamuEmail;
                                } else {
                                  emailErrorText = "";
                                }

                                studentController.onTextChanged(value);
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

                      if ((studentController.filteredEmail != null &&
                              studentController.filteredEmail?.value != null) ||
                          !existsByEmail &&
                              studentController.isValidPvamuEmail(
                                studentController.emailTEC.text,
                              ))
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          // width: displayWidth(context) / 1.4,
                          child: TextField(
                            controller: studentController.firstNameTEC,
                            onChanged: studentController.onTextChanged,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'First name',
                              labelStyle: TextStyle(color: AppColors.grey[200]),
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

                      if ((studentController.filteredEmail != null &&
                              studentController.filteredEmail?.value != null) ||
                          !existsByEmail &&
                              studentController.isValidPvamuEmail(
                                studentController.emailTEC.text,
                              ))
                        Container(
                          margin: EdgeInsets.only(top: 12),
                          // width: displayWidth(context) / 1.4,
                          child: TextField(
                            controller: studentController.lastNameTEC,
                            onChanged: studentController.onTextChanged,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              labelText: 'Last name',
                              labelStyle: TextStyle(color: AppColors.grey[200]),
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

                      // Obx(() {
                      //   if (studentController.filteredEmails.isNotEmpty) {
                      //     return Container(
                      //       margin: EdgeInsets.only(top: 10),
                      //       height: 120,
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //       child: ListView.builder(
                      //         itemCount: studentController.filteredEmails.length,
                      //         itemBuilder: (context, index) {
                      //           var model = studentController.filteredEmails[index];
                      //           return ListTile(
                      //             title: Text(model.name!),
                      //             onTap:
                      //                 () => studentController.onEmailSelected(
                      //                   model.name!,
                      //                 ),
                      //           );
                      //         },
                      //       ),
                      //     );
                      //   } else {
                      //     return SizedBox.shrink();
                      //   }
                      // }),
                      SizedBox(height: 24),

                      SizedBox(
                        // width: displayWidth(context) / 1.4,
                        child: CustomButton(
                          onPressed: () async {
                            if (studentController.authPageTitle.value ==
                                AppStrings.signOut) {
                              await studentController.signOut();
                            } else {
                              // existsByName =
                              //     await studentController.doesUserExistByName();
                              //
                              // if (!existsByName &&
                              //     studentController.emailTEC.text.isNotEmpty &&
                              //     studentController.isPvamuEmail(
                              //       studentController.emailTEC.text,
                              //     )) {
                              //   await studentController.doesUserExistByEmail();
                              //
                              //   Get.toNamed(Routes.detailsPageRoute);
                              // } else if (existsByName) {
                              //   Get.toNamed(Routes.detailsPageRoute);
                              // }

                              existsByEmail =
                                  await studentController
                                      .doesUserExistByEmail();

                              if (studentController
                                      .firstNameTEC
                                      .text
                                      .isNotEmpty &&
                                  studentController
                                      .lastNameTEC
                                      .text
                                      .isNotEmpty &&
                                  studentController.emailTEC.text.isNotEmpty &&
                                  studentController.isPvamuEmail(
                                    studentController.emailTEC.text,
                                  )) {
                                Get.toNamed(Routes.detailsPageRoute);
                              } else if (existsByEmail) {
                                Get.toNamed(Routes.detailsPageRoute);
                              }

                              setState(() {});
                            }
                          },
                          text:
                              studentController.authPageTitle.value ==
                                      AppStrings.signOut
                                  ? "Sign out"
                                  : "Next",
                          textColor:
                              studentController.authPageTitle.value !=
                                      AppStrings.signOut
                                  ? AppColors.purple
                                  : AppColors.white,
                          bgColor:
                              studentController.authPageTitle.value ==
                                      AppStrings.signOut
                                  ? Colors.red
                                  : AppColors.gold,
                          fontSize: AppFonts.baseSize,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        // width: displayWidth(context) / 1.4,
                        child: CustomButton(
                          onPressed: () {
                            Get.offNamed(Routes.onboardingRoute);
                          },
                          text: "Go back",
                          textColor: AppColors.purple,
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
      ),
    );
  }
}
