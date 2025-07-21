import 'package:sign_class/features/auth/data/models/student_model.dart';

abstract class StudentRepo {
  Future<void> createStudent(Student user); //for new user
  Future<List<Student>> getStudentsByNamePrefix(String prefix); //for name search query
  Future<void> updateUser(Map<String, dynamic> user); //to update time_in and time_out
  void deleteUser(String id); //To delete from the local storage
}