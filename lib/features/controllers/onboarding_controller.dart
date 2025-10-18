import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/student/presentation/onboarding/pages/student_onboarding.dart';
import 'package:sign_class/features/tutor/presentation/onboarding/pages/tutor_onboarding.dart';

import '../student/data/models/student_model.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  var numOfSignedInStudents = 0.obs;

  StudentRepoImpl studentRepo = StudentRepoImpl();

  var currentUserType = AppStrings.student.obs;

  totalSignedIn() async {
    numOfSignedInStudents.value = await studentRepo.getTotalSignedInStudents();
  }

  void chooseTutor() {
    currentUserType.value = AppStrings.tutor;
    Get.to(TutorOnboarding());
  }

  void chooseStudent() {
    currentUserType.value = AppStrings.student;
    Get.to(StudentOnboarding());
  }

  Future<List<Student>> getSignedInStudentsList() async =>
      await studentRepo.getSignedInStudentsList();
}
