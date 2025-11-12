import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/tutor/data/tutor_model.dart';
import 'package:sign_class/features/student/domain/repos/courses_repo.dart';

class CoursesRepoImpl extends CoursesRepo {
  final CollectionReference<Map<String, dynamic>> coursesCollection =
  FirebaseFirestore.instance.collection('courses');

  @override
  Future<List<Course>> getCoursesWithTutors() async {
    List<Course> courses = [];

    final coursesSnapshot = await coursesCollection.get();

    for (var courseDoc in coursesSnapshot.docs) {
      final data = courseDoc.data();

      var course = Course.fromMap(data, courseDoc.id);

      // Resolve assigned tutor references safely
      List<Tutor> tutors = [];

      if (data.containsKey('tutors') && data['tutors'] is List) {
        final assignedRefs = data['tutors'] as List<dynamic>;

        for (var ref in assignedRefs) {
          if (ref is DocumentReference) {
            DocumentReference<Map<String, dynamic>> workScheduleRef(String tutorId) =>
                FirebaseFirestore.instance.doc('/tutor_availability/$tutorId');

            final tutorSnap = await ref.get();

            if (tutorSnap.exists) {
              //Get profile
              Map<String, dynamic> profile =
              tutorSnap.data() as Map<String, dynamic>;
              //Get work schedule
              DocumentSnapshot<Map<String, dynamic>> workScheduleSnap = await workScheduleRef(tutorSnap.id).get();
              Map<String, dynamic>? workSchedule;
              if(workScheduleSnap.exists){
                workSchedule = workScheduleSnap.data() as Map<String, dynamic>;
              }

              profile.addAll({"work_schedule": workSchedule});
              Tutor tutor = Tutor.fromMap(profile);

              tutors.add(
                tutor
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
