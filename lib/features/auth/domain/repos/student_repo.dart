import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';

abstract class StudentRepo {
  Future<void> createStudent(Student user, Course course, Tutor? tutor); //for new user
  // Future<List<Student>> getStudentsByNamePrefix(String prefix); //for name search query
  Future<Student?> getStudentInfo(String email);
  Future<void> updateUser(Map<String, dynamic> fields); //to update time_in and time_out
  void deleteUser(String id); //To delete from the local storage
  Future<int> getTotalSignedInStudents();
}