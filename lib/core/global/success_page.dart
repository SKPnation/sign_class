import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/onboarding/presentation/pages/onboarding.dart';

class SuccessPage extends StatelessWidget {
  SuccessPage({super.key, this.userName, this.timeSpent});

  final String? userName;
  final String? timeSpent;

  final studentController = Get.put(StudentController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageElements.pvamuLogo, height: 200, width: 200),

            const SizedBox(height: 60),
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              '${studentController.authPageTitle.value == AppStrings.signIn ? "Welcome" : "Goodbye"}, $userName!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,),
            ),
            SizedBox(height: 10),
            Text(
              'Signed ${studentController.authPageTitle.value == AppStrings.signIn ? "In" : "Out"} Successfully',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            if(studentController.authPageTitle.value != AppStrings.signIn)
              Column(
                children: [
                  SizedBox(height: 10),
                  CustomText(text: "Time spent: $timeSpent", size: 16,),
                ],
              ),

            SizedBox(height: 40),
            SizedBox(width: displayWidth(context)/1.4, child: CustomButton(onPressed: (){
              studentController.authPageTitle.value = AppStrings.signIn;

              Get.off(OnboardingPage());

            }, text: "Done", textColor: AppColors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
