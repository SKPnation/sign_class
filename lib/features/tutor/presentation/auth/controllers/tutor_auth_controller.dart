import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/core/global/sign_out_success.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/tutor/data/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/student/data/repos/user_data_store.dart';
import 'package:sign_class/features/tutor/data/tutor_repo_impl.dart';
import 'package:sign_class/features/tutor/presentation/profile/pages/tutor_profile_page.dart';

class TutorAuthController extends GetxController {
  static TutorAuthController get instance => Get.find();

  final tutorRepo = TutorRepoImpl();
  final studentRepo = StudentRepoImpl();

  final emailTEC = TextEditingController(text: "@pvamu.edu");
  var errorText = "".obs;
  var students = <Student>[].obs;
  final tutor = Rxn<Tutor>();
  RxMap<String, dynamic> availability = <String, dynamic>{}.obs;

  DocumentReference<Map<String, dynamic>> tutorUserRef(String userId) =>
      FirebaseFirestore.instance.doc('/tutors/$userId');
  QuerySnapshot<Object?>? querySnapshot;

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }

  Future<void> signIn() async {
    try {
      // 1) Validate input
      final email = emailTEC.text.trim();
      if (email.isEmpty) {
        errorText.value = "Enter your email.";
        return;
      }

      // 2) Fetch tutor doc
      final qs =
          await tutorRepo.tutorsCollection
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      if (qs.docs.isEmpty) {
        errorText.value = "This account doesn't exist";
        return;
      }

      final tutorDoc = qs.docs.first;
      final docId = tutorDoc.id;
      final tutorMap = Map<String, dynamic>.from(
        tutorDoc.data() as Map<String, dynamic>,
      );

      // 3) Set controller model (ensure id present)
      tutor.value = Tutor.fromMap({...tutorMap, 'id': docId});

      // // 4) Load availability
      // await getAvailability();

      // 5) Fetch students currently signed in (time_out == null)
      final studentsSnap =
          await studentRepo.studentsCollection
              .where('tutor', isEqualTo: tutorUserRef(docId))
              .where('time_out', isEqualTo: null)
              .get();

      final signedInStudents =
          studentsSnap.docs
              .map(
                (d) => Student.fromMap(
                  Map<String, dynamic>.from(d.data() as Map<String, dynamic>),
                  d.id,
                ),
              )
              .toList();

      students.value = signedInStudents;

      // 6) Server-side update
      final now = DateTime.now();
      await tutorRepo.updateUser({
        "id": docId, // for path selection in your repo
        "time_in": now, // Firestore SDK -> Timestamp
        "time_out": null,
      });

      // 7) JSON-safe local cache payload
      final dataToStore = {
        "id": docId,
        "user_type": AppStrings.tutor,
        "time_in": now.toIso8601String(),
        "time_out": null,
        "tutor": tutor.value?.toCacheMap(), // <-- call on the instance
        "students": signedInStudents.map((s) => s.toCacheMap()).toList(),
      };

      // 8) Persist locally (ensures Timestamps/Refs are stringified if any slip through)
      userDataStore.user = Map<String, dynamic>.from(
        encodeFirestoreForJson(dataToStore),
      );

      // 9) Navigate
      Get.offAll(TutorProfilePage());
    } catch (e, st) {
      print("signIn error: $e\n$st");
      errorText.value = "Sign in failed. Please try again.";
    }
  }

  Future signOut() async {
    if (userDataStore.user['user_type'] == AppStrings.tutor) {
      querySnapshot =
          await tutorRepo.tutorsCollection
              .where(
                'id',
                isEqualTo: Tutor.fromMap(userDataStore.user['tutor']).id,
              )
              .get();
    } else {
      querySnapshot =
          await studentRepo.studentsCollection
              .where(
                'id',
                isEqualTo:
                    Student.fromMap(
                      userDataStore.user['student'],
                      userDataStore.user['student']['id'],
                    ).id,
              )
              .get();
    }

    Map<String, dynamic> data =
        querySnapshot!.docs.first.data() as Map<String, dynamic>;

    var userName = data['f_name'];
    var timeIn = (data['time_in'] as Timestamp).toDate();
    var timeOut = DateTime.now();

    Duration duration = timeOut.difference(timeIn);

    var input = {"id": querySnapshot!.docs.first.id, "time_out": timeOut};

    await tutorRepo.updateUser(input);

    tutor.value = null;

    Get.to(
      SignOutSuccessPage(
        userName: userName,
        timeSpent: formatDuration(duration),
      ),
    );

    // clear local cache last
    getStore.clearAllData();
  }

  Future getAvailability() async {
    final tutorId = userDataStore.user['tutor']['id'];

    if (tutorId == null) {
      print("Tutor or tutor ID is null, cannot fetch availability.");
      return;
    }

    final data = await tutorRepo.getMyAvailability(tutorId);

    availability.value = data;
  }

  //TODO: Use this in the admin portal
  // Future setSchedule(
  //     String selectedDay,
  //     TimeOfDay startTime,
  //     TimeOfDay endTime,
  //     ) async {
  //   selectedDay = selectedDay.toLowerCase();
  //   // final start = startTime.format(Get.context!); // e.g. "9:30 AM"
  //   // final end = endTime.format(Get.context!);
  //
  //   // var input = {selectedDay: "$start - $end"};
  //
  //   if (tutor.value != null) {
  //     // await tutorRepo.setSchedule(input, tutor.value!.id!);
  //   }
  // }
}
