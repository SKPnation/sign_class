import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';
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
    final map = user.toMap();

    // convert ID strings to references for Firestore
    map["course"] = CoursesRepoImpl().coursesCollection.doc(course.id!);
    map["tutor"]  = tutor == null ? null : tutorsCollection.doc(tutor.id!);

    await studentsCollection.doc(map['id']).set(map);

    // --- LOCAL STORAGE SAFE MAP ---
    Map<String, dynamic> localMap = {
      "id": map["id"],
      "f_name": user.fName,
      "l_name": user.lName,
      "email": user.email,
      "name_lower": "${user.fName?.toLowerCase()} ${user.lName?.toLowerCase()}",
      "created_at": user.createdAt!.toIso8601String(),
      "time_in": user.timeIn!.toIso8601String(),
      "time_out": null,
      "course_id": course.id,
      "tutor_id": tutor?.id,
    };

    List stored = getStore.get(_Keys.students) ?? [];
    stored.add(localMap);
    getStore.set(_Keys.students, stored);

    print("✅ saved locally: $localMap");
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
  Future<void> updateUser(Map<String, dynamic> input) async {
    final map = {...input};

    // convert string -> reference (Firestore only)
    if (map["course"] is String) {
      map["course"] = CoursesRepoImpl().coursesCollection.doc(map["course"]);
    }
    if (map["tutor"] is String) {
      map["tutor"] = tutorsCollection.doc(map["tutor"]);
    }

    // pull id out so we don't write it as a field by accident
    final String? docId = map["id"] as String?;
    if (docId == null || docId.isEmpty) {
      throw Exception("updateUser: missing 'id' for document path.");
    }
    final firestorePayload = {...map}..remove("id");

    await studentsCollection.doc(docId).update(firestorePayload);

    // load from store safely (cast)
    final raw = getStore.get(_Keys.students) ?? [];
    final List<Map<String, dynamic>> students = List<Map<String, dynamic>>.from(
      raw.map((e) => Map<String, dynamic>.from(e)),
    );

    // find index
    final index = students.indexWhere((s) => s["id"] == docId);

    if (index != -1) {
      students[index] = {
        ...students[index],
        ...input, // keep raw input (e.g., time_out as DateTime) in local cache
      };
    }

    getStore.set(_Keys.students, students);
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
    return Student.fromMap(
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
          return Student.fromMap(map, doc.id);
        }
        return null;
      }),
    );

    // Remove nulls (students that had time_out)
    return students.whereType<Student>().toList();
  }
}
