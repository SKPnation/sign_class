import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';

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

Map<String, dynamic> encodeFirestoreForJson(Map<String, dynamic> input) {
  dynamic encode(dynamic v) {
    if (v == null) return null;

    if (v is Timestamp) {
      // pick one: ISO string or millisecondsSinceEpoch
      return v.toDate().toIso8601String();
      // return v.millisecondsSinceEpoch;  // alternative
    }
    if (v is DateTime) return v.toIso8601String();
    if (v is GeoPoint) return {'_geo': {'lat': v.latitude, 'lng': v.longitude}};
    if (v is DocumentReference) return {'_ref': v.path};

    if (v is List) return v.map(encode).toList();
    if (v is Map) {
      return v.map((k, val) => MapEntry(k.toString(), encode(val)));
    }
    return v;
  }

  return input.map((k, v) => MapEntry(k, encode(v)));
}

