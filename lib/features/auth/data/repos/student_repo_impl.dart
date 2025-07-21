import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/domain/repos/student_repo.dart';

abstract class _Keys {
  static const students = 'students';
}

class StudentRepoImpl implements StudentRepo {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');

  @override
  Future<void> createStudent(Student user) async {
    await studentsCollection.add(user.toMap());
    List<Map<String, dynamic>> students = getStore.get(_Keys.students) ?? [];

    print("CREATE: OLD LIST OF STUDENTS: $students");

    students.add(user.toMap());
    getStore.set(_Keys.students, students);

    print("CREATE: NEW LIST OF STUDENTS: ${getStore.get(_Keys.students)}");
  }

  @override
  void deleteUser(String id) {
    List<Map<String, dynamic>> students = getStore.get(_Keys.students) ?? [];
    if(students.isNotEmpty){
      students.removeWhere((e)=>e['id'] == id);
    }
    getStore.set(_Keys.students, students);

    print("DEL: NEW LIST OF STUDENTS: ${getStore.get(_Keys.students)}");
  }

  @override
  Future<void> updateUser(Map<String, dynamic> fields) async {
    await studentsCollection.doc(fields['id']).update(fields);
  }

  @override
  Future<List<Student>> getStudentsByNamePrefix(String prefix) async {
    final querySnapshot =
        await studentsCollection.orderBy('name').startAt([prefix]).endAt([
          '$prefix\uf8ff',
        ]).get();

    return querySnapshot.docs
        .map((doc) => Student.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }
}
