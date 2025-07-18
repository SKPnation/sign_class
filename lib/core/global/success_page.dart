import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/helpers/navigation/navigation_controller.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/auth_controller.dart';
import 'package:sign_class/features/home/presentation/pages/home.dart';

class SuccessPage extends StatelessWidget {
  SuccessPage({super.key, this.userName});

  final String? userName;

  final navigationController = Get.put(NavigationController());
  final authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            SizedBox(height: 20),
            Text(
              '${authController.authPageTitle.value == AppStrings.signIn ? "Welcome" : "Goodbye"}, $userName!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,),
            ),
            SizedBox(height: 10),
            Text(
              'Signed ${authController.authPageTitle.value == AppStrings.signIn ? "In" : "Out"} Successfully',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(height: 40),
            SizedBox(width: displayWidth(context)/1.4, child: CustomButton(onPressed: (){
              authController.authPageTitle.value = AppStrings.signIn;
              navigationController.navigatorKey.currentState!.pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => Home()),
                    (route) => false,
              );

              // navigationController.navigateTo(Routes.authenticationPageRoute);


            }, text: "Done", textColor: AppColors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
