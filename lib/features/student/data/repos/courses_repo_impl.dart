import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/domain/repos/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CollectionReference coursesCollection =
  FirebaseFirestore.instance.collection('courses');

  @override
  Future<List<Course>> getCoursesWithTutors() async {
    List<Course> courses = [];

    final coursesSnapshot = await coursesCollection.get();

    for (var courseDoc in coursesSnapshot.docs) {
      final data = courseDoc.data() as Map<String, dynamic>;

      var course = Course.fromMap(data, courseDoc.id);

      // Resolve assigned tutor references safely
      List<Tutor> tutors = [];

      if (data.containsKey('tutors') && data['tutors'] is List) {
        final assignedRefs = data['tutors'] as List<dynamic>;

        for (var ref in assignedRefs) {
          if (ref is DocumentReference) {
            final tutorSnap = await ref.get();
            if (tutorSnap.exists) {
              tutors.add(
                Tutor.fromMap({
                  'id': tutorSnap.id,
                  ...tutorSnap.data() as Map<String, dynamic>,
                }),
              );
            }
          }
        }
      }

      // Update course with tutors
      courses.add(
        Course(
          id: course.id,
          name: course.name,
          assignedTutors: tutors,
          code: course.code,
          category: course.category,
          createdAt: course.createdAt,
        ),
      );
    }

    return courses;
  }
}
