import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/navigation_controller.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/home/presentation/controllers/home_controller.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final detailsController = Get.put(DetailsController());
  final authController = Get.put(AuthController());
  final navigationController = Get.put(NavigationController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Material(
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
              SizedBox(height: 24),
              SizedBox(
                width: displayWidth(context) / 1.4,
                child: TextField(
                  controller: detailsController.whyTEC,
                  maxLines: 3,
                  // onChanged: detailsController.onTextChanged,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Type your reason...',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    // aligns to the top-left
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),

              SizedBox(
                child: DropdownButtonFormField<int>(
                  value:
                      detailsController.selectedCourse.value.isNotEmpty
                          ? detailsController.courses.firstWhere(
                            (c) =>
                                c['name'] ==
                                detailsController.selectedCourse.value,
                          )['id']
                          : null,
                  items:
                      detailsController.courses.map((course) {
                        return DropdownMenuItem<int>(
                          value: course['id'],
                          child: Text(course['name']),
                        );
                      }).toList(),
                  onChanged: (int? value) {
                    setState(() {
                      detailsController.selectedCourse.value =
                          detailsController.courses.firstWhere(
                            (course) => course['id'] == value,
                          )['name'];
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Select course',
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                width: displayWidth(context) / 1.4,
              ),

              SizedBox(height: 24),
              SizedBox(
                width: displayWidth(context) / 1.4,
                child: CustomButton(
                  onPressed: () {
                    homeController.numOfSignedInStudents.value++;

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => SuccessPage(
                              userName: authController.nameTEC.text,
                            ),
                      ),
                    );

                    // Navigator.pushAndRemoveUntil(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => SuccessPage(userName: 'Alex'),
                    //   ),
                    //       (Route<dynamic> route) => false, // Remove all previous routes
                    // );
                  },
                  text: "Sign in",
                  textColor: AppColors.purple,
                  fontSize: 18,
                ),
              ),

              SizedBox(height: 24),

              SizedBox(
                width: displayWidth(context) / 1.4,
                child: CustomButton(
                  onPressed: () {
                    navigationController.goBack();
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
    );
  }
}
