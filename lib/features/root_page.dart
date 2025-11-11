import 'package:flutter/material.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/features/student/data/repos/user_data_store.dart';
import 'package:sign_class/features/student/presentation/profile/pages/student_profile_page.dart';
import 'package:sign_class/features/tutor/presentation/profile/pages/tutor_profile_page.dart';
import 'package:sign_class/features/user_types.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    print("TYPE: ${userDataStore.userType}");
    if (userDataStore.user.isNotEmpty) {
      if (getStore.get(userDataStore.userType) == AppStrings.student) {
        return StudentProfilePage();
      } else {
        return TutorProfilePage();
      }
    }else{
      return UserTypesPage();
    }
  }
}
