import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/helpers/image_elements.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';

class TutorSignIn extends StatefulWidget {
  const TutorSignIn({super.key});

  @override
  State<TutorSignIn> createState() => _TutorSignInState();
}

class _TutorSignInState extends State<TutorSignIn> {
  final tutorAuthController = TutorAuthController.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.purple,
        body: Center(
          child: Obx(()=>Column(
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
                text: "${AppStrings.tutor} sign in",
                size: 18,
                color: AppColors.white,
              ),
              SizedBox(height: 24),

              SizedBox(
                width: 300,
                child: TextField(
                  controller: tutorAuthController.emailTEC,
                  onChanged: (value) async {
                    if (!tutorAuthController.isPvamuEmail(value)) {
                      tutorAuthController.errorText.value =
                          AppStrings.mustBePvamuEmail;
                    } else {
                      tutorAuthController.errorText.value = "";
                    }

                    // tutorAuthController.onTextChanged(value);
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
              if (tutorAuthController.errorText.value.isNotEmpty)
                Text(
                  tutorAuthController.errorText.value,
                  style: TextStyle(color: Colors.red.shade200),
                ),

              SizedBox(height: 24),

              SizedBox(
                width: 250,
                child: CustomButton(
                  onPressed: () => tutorAuthController.signIn(),
                  text: "Sign In",
                  textColor: AppColors.purple,
                ),
              )
            ],
          ),)
        ),
      ),
    );
  }
}
