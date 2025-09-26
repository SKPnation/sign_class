import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';

Future<Course> getCourse(DocumentReference docRef) async {
  final courseSnap = await docRef.get();
  return Course.fromMap(
    courseSnap.data() as Map<String, dynamic>,
    courseSnap.id
  );
}

Future<Tutor> getTutor(DocumentReference docRef) async {
  final tutorSnap = await docRef.get();
  return Tutor.fromMap(
    tutorSnap.data() as Map<String, dynamic>,
  );
}

String formatDuration(Duration d) {
  int hours = d.inHours;
  int minutes = d.inMinutes.remainder(60);
  return "${hours}h ${minutes}m";
}

String capitalizeFirst(String? name) {
  if (name == null || name.isEmpty) return '';
  return name[0].toUpperCase() + name.substring(1);
}
