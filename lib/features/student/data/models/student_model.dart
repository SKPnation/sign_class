import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';

class Student {
  final String? id;
  final String? fName;
  final String? lName;
  final String? nameLower;
  final String? email;
  final Course? course;
  final Tutor? tutor;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;

  Student({
    this.id,
    this.fName,
    this.lName,
    this.nameLower,
    this.email,
    this.course,
    this.tutor,
    this.createdAt,
    this.timeIn,
    this.timeOut,
  });


  static Future<Student> fromMapAsync(Map<String, dynamic> map, String docId) async {
    Course course = await getCourse(map['course'] as DocumentReference);
    Tutor? tutor;
    if(map['tutor'] != null){
     tutor = await getTutor(map['tutor'] as DocumentReference);
    }

    return Student(
      id: docId,
      fName: map['f_name'] ?? '',
      lName: map['l_name'] ?? '',
      email: map['email'] ?? '',
      nameLower: map['name_lower'] ?? '',
      createdAt: (map['created_at'] as Timestamp).toDate(),
      timeIn: map['time_in'] != null ? (map['time_in'] as Timestamp).toDate() : null,
      timeOut: map['time_out'] != null ? (map['time_out'] as Timestamp).toDate() : null,
      course: course,
      tutor: tutor
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'name_lower': "${fName?.toLowerCase()} ${lName?.toLowerCase()}",
      'email': email,
      'created_at': Timestamp.fromDate(createdAt!),
      'time_in': timeIn != null ? Timestamp.fromDate(timeIn!) : null,
      'time_out': timeOut != null ? Timestamp.fromDate(timeOut!) : null,
      'course': CoursesRepoImpl().coursesCollection.doc(course?.id!),
      'tutor': StudentRepoImpl().tutorsCollection.doc(tutor?.id!),
    };
  }
}