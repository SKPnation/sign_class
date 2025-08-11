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