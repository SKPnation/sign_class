import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/sign_out_success.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/tutor/data/tutor_repo_impl.dart';
import 'package:sign_class/features/tutor/presentation/profile/pages/tutor_profile_page.dart';

class TutorAuthController extends GetxController {
  static TutorAuthController get instance => Get.find();

  final tutorRepo = TutorRepoImpl();
  final studentRepo = StudentRepoImpl();

  final emailTEC = TextEditingController(text: "@pvamu.edu");
  var errorText = "".obs;
  var students = <Student>[].obs;
  var tutor = Rx<Tutor?>(null);
  RxMap<String, dynamic> availability = <String, dynamic>{}.obs;

  DocumentReference<Map<String, dynamic>> tutorUserRef(String userId) =>
      FirebaseFirestore.instance.doc('/tutors/$userId');
  QuerySnapshot<Object?>? querySnapshot;

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }

  Future signIn() async {
    QuerySnapshot<Object?>? studentQuerySnapshot;

    querySnapshot =
    await tutorRepo.tutorsCollection
        .where('email', isEqualTo: emailTEC.text)
        .limit(1)
        .get();

    if (querySnapshot?.size == 0) {
      errorText.value = "This account doesn't exist";
    }
    else {
      tutor.value =
      await querySnapshot?.docs
          .map(
            (doc) async =>
            Tutor.fromMap(doc.data() as Map<String, dynamic>),
      )
          .first;

      await getAvailability();

      studentQuerySnapshot =
      await studentRepo.studentsCollection
          .where(
        'tutor',
        isEqualTo: tutorUserRef(querySnapshot!.docs.first.id),
      )
          .where('time_out', isEqualTo: null)
          .get();

      if (studentQuerySnapshot.docs.isNotEmpty) {
        students.value = await Future.wait(
          studentQuerySnapshot.docs.map(
                (doc) async =>
            await Student.fromMapAsync(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          ),
        );
      }

      var data = {
        "id": querySnapshot!.docs.first.id,
        "time_in": DateTime.now(),
        "time_out": null,
      };

      await tutorRepo.updateUser(data);


      // emailTEC.clear();
      students.clear();

      //Goto profile page
      Get.offAll(TutorProfilePage());
    }


  }

  Future getAvailability() async {
    final tutorId = tutor.value?.id;

    if (tutorId == null) {
      print("Tutor or tutor ID is null, cannot fetch availability.");
      return;
    }

    final data = await tutorRepo.getMyAvailability(tutorId);

    availability.value = data;
  }

  Future signOut() async {
    querySnapshot =
    await tutorRepo.tutorsCollection
        .where('email', isEqualTo: emailTEC.text)
        .limit(1)
        .get();

    Map<String, dynamic> data = querySnapshot!.docs.first.data() as Map<String, dynamic>;

    var userName = data['name'];
    var timeIn = (data['time_in'] as Timestamp).toDate();
    var timeOut = DateTime.now();

    Duration duration = timeOut.difference(timeIn);

    var input = {
      "id": querySnapshot!.docs.first.id,
      "time_out": timeOut
    };

    await tutorRepo.updateUser(input);

    tutor.value = null;

    Get.off(SignOutSuccessPage(userName: userName, timeSpent: formatDuration(duration)));
  }}