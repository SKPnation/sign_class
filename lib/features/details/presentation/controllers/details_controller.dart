import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/data/repos/courses_repo_impl.dart';

class DetailsController extends GetxController{
  static final DetailsController instance = Get.find();

  CoursesRepoImpl coursesRepo = CoursesRepoImpl();
  List<String> options = ["Study in CEE COMMONS (CL WILSON 106)", "Receive tutoring services"];

  var selectedGoal = "".obs;

  // final List<Tutor>? assignedTutors = <Tutor>[];

  TextEditingController whyTEC = TextEditingController();
  // var selectedCourse = "".obs;
  Rx<Course?> selectedCourse = Rx<Course?>(null);
  Rx<Tutor>? selectedTutor;

  Future<List<Course>> getCourses() async =>
      await coursesRepo.getCoursesWithTutors();
}