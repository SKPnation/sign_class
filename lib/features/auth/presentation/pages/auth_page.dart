import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  StudentController studentController = Get.put(StudentController());

  var existsByName = true;
  var emailErrorText = "";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
        setState(() {
          studentController.filteredNames.clear(); // hide suggestion box
        });
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
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),

                SizedBox(
                  width: displayWidth(context) / 1.4,
                  child: TextField(
                    controller: studentController.nameTEC,
                    onChanged: studentController.onTextChanged,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Name',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      // aligns to the top-left
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),

                if (existsByName == false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: displayWidth(context) / 1.4,
                        child: TextField(
                          controller: studentController.emailTEC,
                          onChanged: (value) {
                            if (!studentController.isPvamuEmail(value)) {
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
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            // aligns to the top-left
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
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

                Obx(() {
                  if (studentController.filteredNames.isNotEmpty)
                    return Container(
                      margin: EdgeInsets.only(top: 10),
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView.builder(
                        itemCount: studentController.filteredNames.length,
                        itemBuilder: (context, index) {
                          var model = studentController.filteredNames[index];
                          return ListTile(
                            title: Text(model.name!),
                            onTap:
                                () => studentController.onNameSelected(
                                  model.name!,
                                ),
                          );
                        },
                      ),
                    );
                  else {
                    return SizedBox.shrink();
                  }
                }),
                SizedBox(height: 24),

                SizedBox(
                  width: displayWidth(context) / 1.4,
                  child: CustomButton(
                    onPressed: () async {
                      if (studentController.authPageTitle.value ==
                          AppStrings.signOut) {
                        await studentController.signOut();
                      } else {
                        existsByName =
                            await studentController.doesUserExistByName();

                        if (!existsByName &&
                            studentController.emailTEC.text.isNotEmpty &&
                            studentController.isPvamuEmail(
                              studentController.emailTEC.text,
                            )) {
                          await studentController.doesUserExistByEmail();

                          Get.toNamed(Routes.detailsPageRoute);

                        } else if (existsByName) {
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
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: displayWidth(context) / 1.4,
                  child: CustomButton(
                    onPressed: () {
                      Get.offNamed(Routes.homeRoute);
                    },
                    text: "Go back",
                    textColor: AppColors.purple,
                    fontSize: 18,
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
