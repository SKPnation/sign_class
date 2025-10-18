import 'package:sign_class/features/student/data/models/course_model.dart';

abstract class CoursesRepo {
  Future<List<Course>> getCoursesWithTutors(); //for new user
}
