import 'package:get/get.dart';
import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  var numOfSignedInStudents = 0.obs;

  StudentRepoImpl studentRepo = StudentRepoImpl();

  // totalSignedIn() async => numOfSignedInStudents.value = await studentRepo.getTotalSignedInStudents();

  totalSignedIn() async{
    numOfSignedInStudents.value = await studentRepo.getTotalSignedInStudents();
  }

}
