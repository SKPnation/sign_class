import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/core/helpers/timestamp_helper.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';

// class Student {
//   final String? id;
//   final String? fName;
//   final String? lName;
//   final String? nameLower;
//   final String? email;
//   final Course? course;
//   final Tutor? tutor;
//   final DateTime? createdAt;
//   final DateTime? timeIn;
//   final DateTime? timeOut;
//
//   Student({
//     this.id,
//     this.fName,
//     this.lName,
//     this.nameLower,
//     this.email,
//     this.course,
//     this.tutor,
//     this.createdAt,
//     this.timeIn,
//     this.timeOut,
//   });
//
//   static Future<Student> fromMapAsync(
//       Map<String, dynamic> map,
//       String docId,
//       ) async {
//     Course course = await getCourse(map['course'] as DocumentReference);
//     Tutor? tutor;
//     if (map['tutor'] != null) {
//       tutor = await getTutor(map['tutor'] as DocumentReference);
//     }
//
//     // convert timestamps to date first
//     DateTime createdAt;
//     if (map['created_at'] is Timestamp) {
//       createdAt = (map['created_at'] as Timestamp).toDate();
//     } else {
//       createdAt = DateTime.parse(map['created_at']);
//     }
//
//     DateTime? timeIn;
//     if (map['time_in'] != null) {
//       if (map['time_in'] is Timestamp) {
//         timeIn = (map['time_in'] as Timestamp).toDate();
//       } else {
//         timeIn = DateTime.parse(map['time_in']);
//       }
//     }
//
//     DateTime? timeOut;
//     if (map['time_out'] != null) {
//       if (map['time_out'] is Timestamp) {
//         timeOut = (map['time_out'] as Timestamp).toDate();
//       } else {
//         timeOut = DateTime.parse(map['time_out']);
//       }
//     }
//
//     return Student(
//       id: docId,
//       fName: map['f_name'] ?? '',
//       lName: map['l_name'] ?? '',
//       email: map['email'] ?? '',
//       nameLower: map['name_lower'] ?? '',
//       createdAt: createdAt,
//       timeIn: timeIn,
//       timeOut: timeOut,
//       course: course,
//       tutor: tutor,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'f_name': fName,
//       'l_name': lName,
//       'name_lower': "${fName?.toLowerCase()} ${lName?.toLowerCase()}",
//       'email': email,
//       // store as ISO string so GetStorage can encode it
//       'created_at': createdAt!.toIso8601String(),
//       'time_in': timeIn?.toIso8601String(),
//       'time_out': timeOut?.toIso8601String(),
//       // only references for Firestore
//       'course': course != null
//           ? CoursesRepoImpl().coursesCollection.doc(course!.id!)
//           : null,
//       'tutor': tutor != null
//           ? StudentRepoImpl().tutorsCollection.doc(tutor!.id!)
//           : null,
//     };
//   }
// }

// class Student {
//   final String? id;
//   final String? fName;
//   final String? lName;
//   final String? nameLower;
//   final String? email;
//   final Course? course;
//   final Tutor? tutor;
//   final DateTime? createdAt;
//   final DateTime? timeIn;
//   final DateTime? timeOut;
//
//   Student({
//     this.id,
//     this.fName,
//     this.lName,
//     this.nameLower,
//     this.email,
//     this.course,
//     this.tutor,
//     this.createdAt,
//     this.timeIn,
//     this.timeOut,
//   });
//
//   factory Student.fromMap(Map<String, dynamic> map, String docId) {
//     return Student(
//       id: docId,
//       fName: map['f_name'] ?? '',
//       lName: map['l_name'] ?? '',
//       email: map['email'] ?? '',
//       nameLower: map['name_lower'] ?? '',
//       createdAt: TimestampHelper.toDate(map['created_at']),
//       timeIn: TimestampHelper.toDate(map['time_in']),
//       timeOut: TimestampHelper.toDate(map['time_out']),
//       course: map['course'] == null ? null : Course.fromMap(map['course'], map['course']['id']),
//       tutor: map['tutor'] == null ? null : Tutor.fromMap(map['tutor']),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'f_name': fName,
//       'l_name': lName,
//       'name_lower': "${fName?.toLowerCase()} ${lName?.toLowerCase()}",
//       'email': email,
//       'created_at': createdAt?.toIso8601String(),
//       'time_in': timeIn?.toIso8601String(),
//       'time_out': timeOut?.toIso8601String(),
//       'course': course?.toMap(),
//       'tutor': tutor?.toMap(),
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  final String? id;
  final String? fName;
  final String? lName;
  final String? nameLower;
  final String? email;
  final Course? course; // keep your type
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

  factory Student.fromMap(Map<String, dynamic> map, String docId) {
    return Student(
      id: docId,
      fName: map['f_name'] ?? '',
      lName: map['l_name'] ?? '',
      email: map['email'] ?? '',
      nameLower: map['name_lower'] ?? '',
      createdAt: _toDate(map['created_at']),
      timeIn: _toDate(map['time_in']),
      timeOut: _toDate(map['time_out']),
      course: _toCourse(map['course']),
      tutor: _toTutor(map['tutor']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'f_name': fName,
      'l_name': lName,
      'name_lower': "${fName?.toLowerCase()} ${lName?.toLowerCase()}",
      'email': email,
      'created_at': createdAt?.toIso8601String(),
      'time_in': timeIn?.toIso8601String(),
      'time_out': timeOut?.toIso8601String(),
      // keep whatever your local cache expects:
      'course': course?.toMap(),
      'tutor': tutor?.toMap(),
    };
  }

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static Course? _toCourse(dynamic value) {
    if (value == null) return null;
    if (value is DocumentReference) {
      // lightweight Course with only id; you can lazy-load details later
      return Course(id: value.id, name: '', code: '', category: '', createdAt: null);
    }
    if (value is Map<String, dynamic>) {
      final id = value['id']?.toString() ?? '';
      return Course.fromMap(value, id);
    }
    return null;
  }

  static Tutor? _toTutor(dynamic value) {
    if (value == null) return null;
    if (value is DocumentReference) {
      return Tutor(id: value.id, fName: '', lName: '', email: '', createdAt: null);
    }
    if (value is Map<String, dynamic>) {
      return Tutor.fromMap(value);
    }
    return null;
  }
}
