import 'package:cloud_firestore/cloud_firestore.dart';

// class Tutor {
//   final String? id;
//   final String? fName;
//   final String? lName;
//   final String? email;
//   final Map<String, dynamic>? workSchedule;
//   final DateTime? createdAt;
//   final DateTime? timeIn;
//   final DateTime? timeOut;
//   final DateTime? blockedAt;
//
//   Tutor({
//     this.id,
//     required this.fName,
//     required this.lName,
//     required this.email,
//     this.workSchedule,
//     required this.createdAt,
//     this.blockedAt,
//     this.timeIn,
//     this.timeOut,
//   });
//
//   factory Tutor.fromMap(Map<String, dynamic> map) {
//     return Tutor(
//       id: map['id'],
//       fName: map['f_name'],
//       lName: map['l_name'],
//       email: map['email'],
//       workSchedule: map['work_schedule'],
//       createdAt: (map['created_at'] as Timestamp?)?.toDate(),
//       blockedAt: (map['blocked_at'] as Timestamp?)?.toDate(),
//       timeIn: (map['time_in'] as Timestamp?)?.toDate(),
//       timeOut: (map['time_out'] as Timestamp?)?.toDate(),
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'f_name': fName,
//       'l_name': lName,
//       'email': email,
//       'work_schedule': workSchedule,
//       'created_at': Timestamp.fromDate(createdAt!),
//       'blocked_at': blockedAt == null ? null : Timestamp.fromDate(blockedAt!),
//       'time_in': Timestamp.fromDate(timeIn!),
//       'time_out': timeOut == null ? null : Timestamp.fromDate(timeOut!),
//     };
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  final String? id;
  final String? fName;
  final String? lName;
  final String? email;
  final Map<String, dynamic>? workSchedule;
  final DateTime? createdAt;
  final DateTime? timeIn;
  final DateTime? timeOut;
  final DateTime? blockedAt;

  Tutor({
    this.id,
    this.fName,
    this.lName,
    this.email,
    this.workSchedule,
    this.createdAt,
    this.timeIn,
    this.timeOut,
    this.blockedAt,
  });

  // ---------- FACTORY ----------

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'],
      fName: map['f_name'],
      lName: map['l_name'],
      email: map['email'],
      workSchedule: map['work_schedule'] != null
          ? Map<String, dynamic>.from(map['work_schedule'])
          : null,
      createdAt: _toDate(map['created_at']),
      blockedAt: _toDate(map['blocked_at']),
      timeIn: _toDate(map['time_in']),
      timeOut: _toDate(map['time_out']),
    );
  }

  // ---------- SERIALIZERS ----------

  /// For Firestore writes (safely handles null timestamps)
  Map<String, dynamic> toMap() {
    return {
      'f_name': fName,
      'l_name': lName,
      'email': email,
      'work_schedule': workSchedule,
      if (createdAt != null) 'created_at': Timestamp.fromDate(createdAt!),
      if (blockedAt != null) 'blocked_at': Timestamp.fromDate(blockedAt!),
      if (timeIn != null) 'time_in': Timestamp.fromDate(timeIn!),
      if (timeOut != null) 'time_out': Timestamp.fromDate(timeOut!),
    };
  }

  /// For local caching (GetStorage, JSON-safe)
  Map<String, dynamic> toCacheMap() => {
    'id': id,
    'f_name': fName,
    'l_name': lName,
    'email': email,
    'work_schedule': workSchedule,
    'created_at': createdAt?.toIso8601String(),
    'blocked_at': blockedAt?.toIso8601String(),
    'time_in': timeIn?.toIso8601String(),
    'time_out': timeOut?.toIso8601String(),
  };

  // ---------- STATIC HELPERS ----------

  static DateTime? _toDate(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}

// ---------- OPTIONAL EXTENSION ----------

extension TutorCache on Tutor {
  Map<String, dynamic> toCacheMap() => {
    'id': id,
    'f_name': fName,
    'l_name': lName,
    'email': email,
    'work_schedule': workSchedule,
    'created_at': createdAt?.toIso8601String(),
    'blocked_at': blockedAt?.toIso8601String(),
    'time_in': timeIn?.toIso8601String(),
    'time_out': timeOut?.toIso8601String(),
  };
}
