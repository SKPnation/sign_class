import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/student/presentation/auth/controllers/student_auth_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';

class StudentProfilePage extends StatelessWidget {
  StudentProfilePage({super.key});

  final studentAuthController = StudentAuthController.instance;
  final purposeController = PurposeController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(text: "Profile", weight: FontWeight.bold, size: 18,),
              SizedBox(height: 30),

              CircleAvatar(
                radius: 50,
                // adjust size
                backgroundColor: Colors.grey[300],
                // backgroundImage: tutorAuthController.tutor.value?.profileImage != null
                //     ? NetworkImage(tutorAuthController.tutor.value?.profileImage!)
                //     : null,
                child: Icon(Icons.person, size: 50, color: Colors.white),

                // tutor?.profileImage == null
                //     ? const Icon(
                //   Icons.person,
                //   size: 50,
                //   color: Colors.white,
                // )
                //     : null,
              ),

              SizedBox(height: 40),

              CustomText(text: "Signed in as", weight: FontWeight.bold, size: AppFonts.baseSize,),

              Obx(()=>CustomText(
                text: "${studentAuthController.firstName.value} ${studentAuthController.lastName.value}",
                size: 16,
                textAlign: TextAlign.center,
              ),),

              SizedBox(height: 16),


              CustomText(text: "Goal", weight: FontWeight.bold, size: AppFonts.baseSize,),
              Obx(()=>CustomText(
                text: purposeController.selectedGoal.value,
                textAlign: TextAlign.center,
                size: 16,
              ),),
              SizedBox(height: 16),

              CustomText(text: "Course", weight: FontWeight.bold, size: AppFonts.baseSize,),
              Obx(()=>CustomText(
                text: "${purposeController.selectedCourse.value?.name}",
                textAlign: TextAlign.center,
                size: 16,
              ),),

              if(purposeController.selectedTutor != null)
                Obx((){
                  return CustomText(
                    text: "Tutor: ${purposeController.selectedTutor?.value.name}",
                    size: 16,
                  );
                }),

              SizedBox(height: 16),

              SizedBox(
                  width: 200,
                  child: CustomButton(
                    onPressed: () async{
                      await studentAuthController.signOut();
                    },
                    text: "Sign out",
                    bgColor: AppColors.red,
                    textColor: AppColors.white,
                  )
              ),
            ],
          ),
        )
      ),
    );
  }
}
