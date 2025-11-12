class MyProfileModel {
  final String id;
  final Map<String, dynamic> student;
  final String? goal;
  final DateTime timeIn;
  final DateTime? timeOut;
  final Map<String, dynamic>? tutor;
  final Map<String, dynamic>? course;
  final String userType;

  MyProfileModel({
    required this.id,
    required this.student,
    this.goal,
    required this.timeIn,
    this.timeOut,
    this.tutor,
    this.course,
    required this.userType,
  });

  factory MyProfileModel.fromMap(Map<String, dynamic> map) {
    return MyProfileModel(
      id: map['id'],
      student: Map<String, dynamic>.from(map['student']),
      goal: map['goal'],
      timeIn: DateTime.parse(map['time_in']),
      timeOut: map['time_out'] == null ? null : DateTime.parse(map['time_out']),
      tutor: map['tutor'] == null ? null : Map<String, dynamic>.from(map['tutor']),
      course: map['course'] == null ? null : Map<String, dynamic>.from(map['course']),
      userType: map['user_type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "student": student,
      "goal": goal,
      "time_in": timeIn.toIso8601String(),
      "time_out": timeOut?.toIso8601String(),
      "tutor": tutor,
      "course": course,
      "user_type": userType,
    };
  }
}
