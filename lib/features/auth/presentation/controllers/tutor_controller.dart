import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_alert_dialog.dart';
import 'package:sign_class/core/global/custom_snackbar.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/auth/data/repos/tutor_repo_impl.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class TutorController extends GetxController {
  static TutorController get instance => Get.find();
  final onboardingController = OnboardingController.instance;

  final tutorRepo = TutorRepoImpl();
  final studentRepo = StudentRepoImpl();

  DocumentReference<Map<String, dynamic>> tutorUserRef(String userId) =>
      FirebaseFirestore.instance.doc('/tutors/$userId');
  QuerySnapshot<Object?>? querySnapshot;

  var authPageTitle = "".obs;
  var register = false.obs;
  var students = <Student>[].obs;
  var tutor = Rx<Tutor?>(null);

  RxMap<String, dynamic> availability = <String, dynamic>{}.obs;

  final TextEditingController emailTEC = TextEditingController();

  Future signIn() async {
    QuerySnapshot<Object?>? studentQuerySnapshot;

    querySnapshot =
        await tutorRepo.tutorsCollection
            .where('email', isEqualTo: emailTEC.text)
            .limit(1)
            .get();

    if (querySnapshot?.size == 0) {
      return CustomSnackBar.errorSnackBar("This account doesn't exist");
    } else {
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
            (doc) async => await Student.fromMapAsync(
              doc.data() as Map<String, dynamic>,
              doc.id,
            ),
          ),
        );

        var data = {
          "id": querySnapshot!.docs.first.id,
          "time_in": DateTime.now(),
          "time_out": null,
        };

        await studentRepo.updateUser(data);
      }

      emailTEC.clear();
      students.clear();
    }
  }

  Future signOut() async {
    querySnapshot =
        await tutorRepo.tutorsCollection
            .where('email', isEqualTo: emailTEC.text)
            .limit(1)
            .get();

    var data = {"id": querySnapshot!.docs.first.id, "time_out": DateTime.now()};

    await tutorRepo.updateUser(data);

    tutor.value = null;

    Get.to(
      SuccessPage(
        userName:
            querySnapshot?.docs
                .map((e) => (Tutor.fromMap(e as Map<String, dynamic>)))
                .first
                .name,
      ),
    );
  }

  Future setSchedule(
    String selectedDay,
    TimeOfDay startTime,
    TimeOfDay endTime,
  ) async {
    selectedDay = selectedDay.toLowerCase();
    final start = startTime.format(Get.context!); // e.g. "9:30 AM"
    final end = endTime.format(Get.context!);

    var input = {selectedDay: "$start - $end"};

    if (tutor.value != null) {
      await tutorRepo.setSchedule(input, tutor.value!.id!);
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

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }
}
