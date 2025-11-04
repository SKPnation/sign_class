import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
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

  static Future<Student> fromMapAsync(
      Map<String, dynamic> map,
      String docId,
      ) async {
    Course course = await getCourse(map['course'] as DocumentReference);
    Tutor? tutor;
    if (map['tutor'] != null) {
      tutor = await getTutor(map['tutor'] as DocumentReference);
    }

    // convert timestamps to date first
    DateTime createdAt;
    if (map['created_at'] is Timestamp) {
      createdAt = (map['created_at'] as Timestamp).toDate();
    } else {
      createdAt = DateTime.parse(map['created_at']);
    }

    DateTime? timeIn;
    if (map['time_in'] != null) {
      if (map['time_in'] is Timestamp) {
        timeIn = (map['time_in'] as Timestamp).toDate();
      } else {
        timeIn = DateTime.parse(map['time_in']);
      }
    }

    DateTime? timeOut;
    if (map['time_out'] != null) {
      if (map['time_out'] is Timestamp) {
        timeOut = (map['time_out'] as Timestamp).toDate();
      } else {
        timeOut = DateTime.parse(map['time_out']);
      }
    }

    return Student(
      id: docId,
      fName: map['f_name'] ?? '',
      lName: map['l_name'] ?? '',
      email: map['email'] ?? '',
      nameLower: map['name_lower'] ?? '',
      createdAt: createdAt,
      timeIn: timeIn,
      timeOut: timeOut,
      course: course,
      tutor: tutor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'name_lower': "${fName?.toLowerCase()} ${lName?.toLowerCase()}",
      'email': email,
      // store as ISO string so GetStorage can encode it
      'created_at': createdAt!.toIso8601String(),
      'time_in': timeIn?.toIso8601String(),
      'time_out': timeOut?.toIso8601String(),
      // only references for Firestore
      'course': course != null
          ? CoursesRepoImpl().coursesCollection.doc(course!.id!)
          : null,
      'tutor': tutor != null
          ? StudentRepoImpl().tutorsCollection.doc(tutor!.id!)
          : null,
    };
  }
}
