import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/core/helpers/navigation/local_navigator.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/auth/presentation/controllers/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus(); // dismiss keyboard
        setState(() {
          authController.filteredNames.clear(); // hide suggestion box
        });
      },
      child: Material(
        child: Container(
          padding: EdgeInsets.all(24),
          color: AppColors.purple,
          child: Obx(()=>Column(
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
                authController.authPageTitle.value,
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
                  controller: authController.nameTEC,
                  onChanged: authController.onTextChanged,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Name',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    floatingLabelAlignment: FloatingLabelAlignment.start, // aligns to the top-left
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              if (authController.filteredNames.isNotEmpty)
                Container(
                  margin: EdgeInsets.only(top: 10),
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: authController.filteredNames.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(authController.filteredNames[index]),
                        onTap:
                            () => authController.onNameSelected(
                          authController.filteredNames[index],
                        ),
                      );
                    },
                  ),
                ),
              SizedBox(height: 24),

              SizedBox(
                width: displayWidth(context) / 1.4,
                child: CustomButton(
                  onPressed: () {
                    if(authController.authPageTitle.value == AppStrings.signOut){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => SuccessPage(
                            userName: authController.nameTEC.text,
                          ),
                        ),
                      );
                    }else{
                      navigationController.navigateTo(Routes.detailsPageRoute);
                    }

                  },
                  text: authController.authPageTitle.value == AppStrings.signOut ? "Sign out" : "Next",
                  textColor: authController.authPageTitle.value != AppStrings.signOut ? AppColors.purple : AppColors.white,
                  bgColor:  authController.authPageTitle.value == AppStrings.signOut ? Colors.red : AppColors.gold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 16),
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
          )),
        ),
      ),
    );
  }
}
