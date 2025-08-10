class Tutor {
  final String? id;
  final String? name;

  Tutor({required this.id, required this.name});

  factory Tutor.fromMap(Map<String, dynamic> map) {
    return Tutor(
      id: map['id'],
      name: map['name']

    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }
}