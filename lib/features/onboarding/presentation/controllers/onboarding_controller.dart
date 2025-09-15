import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/helpers/navigation/app_routes.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  var numOfSignedInStudents = 0.obs;

  StudentRepoImpl studentRepo = StudentRepoImpl();

  var currentUserType = AppStrings.student.obs;

  totalSignedIn() async{
    numOfSignedInStudents.value = await studentRepo.getTotalSignedInStudents();
  }

  void chooseTutor() {
    currentUserType.value = AppStrings.tutor;
    Get.toNamed(Routes.onboardingRoute);
  }

  void chooseStudent() {
    currentUserType.value = AppStrings.student;
    Get.toNamed(Routes.onboardingRoute);
  }

  Future<List<Student>> getSignedInStudentsList() async =>
      await studentRepo.getSignedInStudentsList();

}
