class Course {
  final String id;
  final String name;
  final List<int> tutors;

  Course({
    required this.id,
    required this.name,
    required this.tutors,
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      name: map['name'] ?? '',
      tutors: List<int>.from(map['tutors'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tutors': tutors,
    };
  }
}
