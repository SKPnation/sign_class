import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/sign_out_success.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/student/presentation/profile/pages/student_profile_page.dart';
import 'package:sign_class/features/student/presentation/purpose/controllers/purpose_controller.dart';
import 'package:sign_class/features/tutor/data/tutor_repo_impl.dart';

class StudentAuthController extends GetxController {
  static StudentAuthController get instance => Get.find();
  final onboardingController = OnboardingController.instance;

  final coursesRepo = CoursesRepoImpl();
  final studentRepo = StudentRepoImpl();
  final tutorRepo = TutorRepoImpl();

  final emailTEC = TextEditingController(text: "@pvamu.edu");
  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController lastNameTEC = TextEditingController();

  final firstName = "".obs;
  final lastName = "".obs;

  var register = false.obs;

  Rx<Student?>? filteredEmail;

  QuerySnapshot<Object?>? querySnapshot;

  void onTextChanged(String input) async {
    filteredEmail?.value = await studentRepo.getStudentInfo(input);

    if(filteredEmail != null && filteredEmail?.value != null){
      firstNameTEC.text = filteredEmail!.value!.fName!;
      lastNameTEC.text = filteredEmail!.value!.lName!;
    }
  }

  bool isValidPvamuEmail(String email) {
    final regex = RegExp(r'^[^@]+@pvamu\.edu$');
    return regex.hasMatch(email);
  }

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }

  Future<bool> doesUserExistByEmail() async {
    var exists = false;
    querySnapshot =
    await studentRepo.studentsCollection
        .where('email', isEqualTo: emailTEC.text)
        .limit(1)
        .get();
    exists = querySnapshot!.docs.isNotEmpty;

    if (exists) {
      register.value = false;
    } else {
      register.value = true;
    }

    return exists;
  }

  addStudent(Course course, Tutor? tutor) async {
    // create id once
    final newId = studentRepo.studentsCollection.doc().id;

    Student student = Student(
      id: newId,
      fName: firstNameTEC.text.trim(),
      lName: lastNameTEC.text.trim(),
      email: emailTEC.text.trim(),
      createdAt: DateTime.now(),
      timeIn: DateTime.now(),
      course: course,
      tutor: tutor,
    );

    await studentRepo.createStudent(student, course, tutor);

    onboardingController.numOfSignedInStudents.value++;

    // set names in controller AFTER successful create
    firstName.value = firstNameTEC.text.trim();
    lastName.value = lastNameTEC.text.trim();

    Get.to(StudentProfilePage());
  }

  Future signIn(Course? course, {Tutor? tutor}) async {
    final snap = await studentRepo.studentsCollection
        .where('email', isEqualTo: emailTEC.text.trim())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      // student not found
      Get.snackbar("Error", "Student not found");
      return;
    }

    final doc = snap.docs.first;

    await studentRepo.updateUser({
      "id": doc.id,
      "course": course?.id,   // use ID not DocumentReference
      "tutor": tutor?.id,
      "time_in": DateTime.now(),
      "time_out": null,
    });

    onboardingController.numOfSignedInStudents.value++;

    firstName.value = doc['f_name'];
    lastName.value  = doc['l_name'];

    Get.to(StudentProfilePage());
  }

  Future signOut() async {
    querySnapshot =
    await studentRepo.studentsCollection
        .where('email', isEqualTo: emailTEC.text)
        .limit(1)
        .get();

    Map<String, dynamic> data =
    querySnapshot!.docs.first.data() as Map<String, dynamic>;

    // FIX
    dynamic rawTimeIn = data['time_in'];
    late DateTime timeIn;

    if (rawTimeIn is Timestamp) {
      timeIn = rawTimeIn.toDate();
    } else if (rawTimeIn is String) {
      timeIn = DateTime.parse(rawTimeIn);
    } else {
      throw Exception("Unknown time_in type");
    }

    var timeOut = DateTime.now();

    Duration duration = timeOut.difference(timeIn);

    var input = {
      "id": querySnapshot!.docs.first.id,
      "time_out": timeOut
    };

    await studentRepo.updateUser(input);

    Get.to(SignOutSuccessPage(
        userName: "${firstName.value} ${lastName.value}",
        timeSpent: formatDuration(duration)
    ));
  }
}