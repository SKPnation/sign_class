import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/domain/repos/student_repo.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/data/repos/courses_repo_impl.dart';

abstract class _Keys {
  static const students = 'students';
}

class StudentRepoImpl extends StudentRepo {
  final CollectionReference studentsCollection = FirebaseFirestore.instance
      .collection('students');
  final CollectionReference tutorsCollection = FirebaseFirestore.instance
      .collection('tutors');

  @override
  Future<void> createStudent(Student user, Course course, Tutor? tutor) async {
    Map<String, dynamic> userMap = user.toMap();

    // Update the course key with the course document ID or path (not DocumentReference itself)
    userMap["course"] = CoursesRepoImpl().coursesCollection.doc(course.id!);
    userMap["tutor"] = tutor == null ? null : tutorsCollection.doc(tutor.id!);

    await studentsCollection.add(userMap);

    List<Map<String, dynamic>> students = getStore.get(_Keys.students) ?? [];

    print("CREATE: OLD LIST OF STUDENTS: $students");

    students.add(userMap);
    getStore.set(_Keys.students, students);

    print("CREATE: NEW LIST OF STUDENTS: ${getStore.get(_Keys.students)}");
  }

  @override
  void deleteUser(String id) {
    List<Map<String, dynamic>> students = getStore.get(_Keys.students) ?? [];
    if (students.isNotEmpty) {
      students.removeWhere((e) => e['id'] == id);
    }
    getStore.set(_Keys.students, students);

    print("DEL: NEW LIST OF STUDENTS: ${getStore.get(_Keys.students)}");
  }

  @override
  Future<void> updateUser(Map<String, dynamic> fields) async {
    final data = Map<String, dynamic>.from(fields)..remove('id');
    await studentsCollection.doc(fields['id']).update(data);
  }

  @override
  Future<List<Student>> getStudentsByNamePrefix(String prefix) async {
    final querySnapshot =
        await studentsCollection
            .orderBy('name_lower')
            .startAt([prefix.toLowerCase()])
            .endAt(['${prefix.toLowerCase()}\uf8ff'])
            .get();

    return await Future.wait(
      querySnapshot.docs.map(
        (doc) =>
            Student.fromMapAsync(doc.data() as Map<String, dynamic>, doc.id),
      ),
    );
  }

  @override
  Future<int> getTotalSignedInStudents() async {
    var docs = await studentsCollection.get();
    int total = 0;

    for (var doc in docs.docs) {
      if ((doc.data() as Map<String, dynamic>)['time_out'] == null) {
        total++;
      }
    }

    // var query =
    //      studentsCollection
    //         .where("time_out", isEqualTo: null)
    //         .count();
    //
    //
    // // Execute the aggregate query
    // var snapshot = await query.get();
    // total = snapshot.count!;
    //
    // print(total);

    return total;
  }
}
