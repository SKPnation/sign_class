import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';

abstract class CoursesRepo {
  Future<List<Course>> getCoursesWithTutors(); //for new user
}
