import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/domain/repos/student_repo.dart';

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

    await studentsCollection.doc(userMap['id']).set(userMap);

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

  // @override
  // Future<List<Student>> getStudentsByNamePrefix(String prefix) async {
  //   final querySnapshot =
  //       await studentsCollection
  //           .orderBy('name_lower')
  //           .startAt([prefix.toLowerCase()])
  //           .endAt(['${prefix.toLowerCase()}\uf8ff'])
  //           .get();
  //
  //   return await Future.wait(
  //     querySnapshot.docs.map(
  //       (doc) =>
  //           Student.fromMapAsync(doc.data() as Map<String, dynamic>, doc.id),
  //     ),
  //   );
  // }

  @override
  Future<int> getTotalSignedInStudents() async {
    var docs = await studentsCollection.get();
    int total = 0;

    for (var doc in docs.docs) {
      if ((doc.data() as Map<String, dynamic>)['time_out'] == null) {
        total++;
      }
    }

    return total;
  }

  @override
  Future<Student?> getStudentInfo(String email) async{
    // Query FireStore for the document where email matches exactly
    final querySnapshot = await studentsCollection
        .where("email", isEqualTo: email)
        .limit(1) // stop after the first match
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null; // No match found yet
    }

    final doc = querySnapshot.docs.first;

    // Convert FireStore data to Student model
    return await Student.fromMapAsync(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );

  }

  @override
  Future<List<Student>> getSignedInStudentsList() async{
    final querySnapshot = await studentsCollection.get();

    final students = await Future.wait(
      querySnapshot.docs.map((doc) async {
        var map = doc.data() as Map<String, dynamic>;

        if(map['time_out'] == null){
          return await Student.fromMapAsync(map, doc.id);
        }
        return null;
      }),
    );

    // Remove nulls (students that had time_out)
    return students.whereType<Student>().toList();
  }
}
