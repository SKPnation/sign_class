import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/domain/repos/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CollectionReference coursesCollection = FirebaseFirestore.instance
      .collection('courses');

  @override
  Future<List<Course>> getCoursesWithTutors() async {
    List<Course> courses = [];

    final coursesSnapshot = await coursesCollection.get();

    for (var courseDoc in coursesSnapshot.docs) {
      var course = Course.fromMap(
        courseDoc.data() as Map<String, dynamic>,
        courseDoc.id,
      );

      // Resolve assigned tutor references
      List<dynamic> assignedRefs = courseDoc['tutors'] ?? [];
      List<Tutor> tutors = [];

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
