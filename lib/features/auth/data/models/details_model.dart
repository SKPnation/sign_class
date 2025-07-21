class Details {
  final String studentID;
  final String why;
  final List<int> courses;

  Details({
    required this.studentID,
    required this.why,
    required this.courses,
  });

  factory Details.fromMap(Map<String, dynamic> map) {
    return Details(
      studentID: map['studentID'] ?? '',
      why: map['why'] ?? '',
      courses: List<int>.from(map['courses'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentID': studentID,
      'why': why,
      'courses': courses,
    };
  }
}
