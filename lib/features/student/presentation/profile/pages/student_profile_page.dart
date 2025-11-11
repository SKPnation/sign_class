import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';
import 'package:sign_class/features/student/data/models/my_profile_model.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/user_data_store.dart';
import 'package:sign_class/features/student/presentation/auth/controllers/student_auth_controller.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';

class StudentProfilePage extends StatefulWidget {
  StudentProfilePage({super.key});

  @override
  State<StudentProfilePage> createState() => _StudentProfilePageState();
}

class _StudentProfilePageState extends State<StudentProfilePage> {
  final studentAuthController = StudentAuthController.instance;

  final purposeController = PurposeController.instance;
  MyProfileModel? profileModel;

  getProfileInfo() {
    profileModel = MyProfileModel.fromMap(userDataStore.user);
    // print("JAMI MAP: ${profileModel?.student}");
    // studentModel = Student.fromMap(
    //   profileModel!.student,
    //   profileModel!.id,
    // );

    // studentModel = await Student.fromMapAsync(
    //   profileModel!.student,
    //   profileModel!.id,
    // );

    setState(() {});
  }

  @override
  void initState() {
    getProfileInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(userDataStore.userType);

    return WillPopScope(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(text: "Profile", weight: FontWeight.bold, size: 18),
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

                CustomText(
                  text: "Signed in as",
                  weight: FontWeight.bold,
                  size: AppFonts.baseSize,
                ),

                CustomText(
                  text:
                      "${profileModel?.student['f_name']} ${profileModel?.student['l_name']}",
                  size: 16,
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: 16),

                CustomText(
                  text: "Goal",
                  weight: FontWeight.bold,
                  size: AppFonts.baseSize,
                ),
                CustomText(
                  text: profileModel?.goal ?? "--",
                  textAlign: TextAlign.center,
                  size: 16,
                ),
                SizedBox(height: 16),

                CustomText(
                  text: "Course",
                  weight: FontWeight.bold,
                  size: AppFonts.baseSize,
                ),
                CustomText(
                  text:
                      "${profileModel?.course?['code'] ?? "--"} - ${profileModel?.course?['name'] ?? "--"}",
                  textAlign: TextAlign.center,
                  size: 16,
                ),

                Column(
                  children: [
                    SizedBox(height: 16),

                    CustomText(
                      text: "Tutor",
                      weight: FontWeight.bold,
                      size: AppFonts.baseSize,
                    ),

                    CustomText(
                      text:
                          "${profileModel?.tutor?['f_name'] ?? "--"} ${profileModel?.tutor?['l_name'] ?? "--"}",
                      size: 16,
                    ),
                    //
                    // if (purposeController.selectedTutor.value == null)
                    //   CustomText(text: "--")
                    // else
                    //   CustomText(
                    //     text:
                    //         "${purposeController.selectedTutor.value?.fName} ${purposeController.selectedTutor.value?.lName}",
                    //     size: 16,
                    //   ),
                  ],
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: 200,
                  child: CustomButton(
                    onPressed: () async {
                      await studentAuthController.signOut();
                    },
                    text: "Sign out",
                    bgColor: AppColors.red,
                    textColor: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false, // ← BLOCK BACK
    );
  }
}
