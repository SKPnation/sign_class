import 'package:get/get.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';

class PurposeController extends GetxController{
  static PurposeController get instance => Get.find();

  CoursesRepoImpl coursesRepo = CoursesRepoImpl();
  List<String> options = ["Study in CEE COMMONS (CL WILSON 106)", "Receive tutoring services"];

  var selectedGoal = "".obs;

  Rx<Course?> selectedCourse = Rx<Course?>(null);
  final selectedTutor  = Rxn<Tutor>(); // <-- initialize, not nullable Rx?

  Future<List<Course>> getCourses() async =>
      await coursesRepo.getCoursesWithTutors();

}