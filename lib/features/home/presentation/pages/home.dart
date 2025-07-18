import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/helpers/navigation/navigation_controller.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sign_class/features/home/presentation/controllers/home_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final navigationController = Get.put(NavigationController());
  final authController = Get.put(AuthController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
            SizedBox(
              width: displayWidth(context) / 1.4,
              child: CustomButton(
                onPressed: () {
                  authController.authPageTitle.value = AppStrings.signIn;
                  navigationController.navigateTo(
                    Routes.authenticationPageRoute,
                  );
                },
                text: "Sign In",
                textColor: AppColors.purple,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: displayWidth(context) / 1.4,
              child: CustomButton(
                onPressed: () {
                  authController.authPageTitle.value = AppStrings.signOut;
                  navigationController.navigateTo(
                    Routes.authenticationPageRoute,
                  );
                },
                text: "Sign Out",
                textColor: AppColors.purple,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 80),

            Obx(
              () => Text(
                "${homeController.numOfSignedInStudents.value}",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
