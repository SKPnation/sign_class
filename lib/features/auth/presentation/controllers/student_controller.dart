import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/auth/data/repos/tutor_repo_impl.dart';
import 'package:sign_class/features/details/data/models/course_model.dart';
import 'package:sign_class/features/details/data/models/tutor_model.dart';
import 'package:sign_class/features/details/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/onboarding/presentation/controllers/onboarding_controller.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  final onboardingController = OnboardingController.instance;

  final studentRepo = StudentRepoImpl();

  var authPageTitle = "".obs;

  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController lastNameTEC = TextEditingController();
  final TextEditingController emailTEC = TextEditingController(text: "@pvamu.edu");

  var register = false.obs;

  Rx<Student?>? filteredEmail;

  QuerySnapshot<Object?>? querySnapshot;

  void onTextChanged(String input) async {
    filteredEmail!.value = await studentRepo.getStudentInfo(input);

    if(filteredEmail != null && filteredEmail?.value != null){
      firstNameTEC.text = filteredEmail!.value!.fName!;
      lastNameTEC.text = filteredEmail!.value!.lName!;
    }
  }

  addStudent(Course course, Tutor? tutor) async {
    Student studentModel = Student(
      id: studentRepo.studentsCollection.doc().id,
      fName: firstNameTEC.text,
      lName: lastNameTEC.text,
      email: emailTEC.text,
      createdAt: DateTime.now(),
      timeIn: DateTime.now(),
    );

    await studentRepo.createStudent(studentModel, course, tutor);
    onboardingController.numOfSignedInStudents.value++;

    Get.to(SuccessPage(userName: "${firstNameTEC.text} ${lastNameTEC.text}"));

    firstNameTEC.clear();
    lastNameTEC.clear();
    emailTEC.clear();
    DetailsController.instance.whyTEC.clear();
    DetailsController.instance.selectedCourse.value = null;
  }

  bool isValidPvamuEmail(String email) {
    final regex = RegExp(r'^[^@]+@pvamu\.edu$');
    return regex.hasMatch(email);
  }

  Future signIn(Course course, {Tutor? tutor}) async {
    querySnapshot = await studentRepo.studentsCollection
        .where('email', isEqualTo: emailTEC.text)
        .limit(1)
        .get();

    var data = {
      "id": querySnapshot!.docs.first.id,
      "course": CoursesRepoImpl().coursesCollection.doc(course.id!),
      "tutor": tutor == null ? null : TutorRepoImpl().tutorsCollection.doc(tutor.id!),
      "time_in": DateTime.now(),
      "time_out": null,
    };

    await studentRepo.updateUser(data);
    onboardingController.numOfSignedInStudents.value++;

    var name = "${querySnapshot!.docs.first['f_name']} ${querySnapshot!.docs.first['l_name']}";

    Get.to(SuccessPage(userName: name));

    firstNameTEC.clear();
    lastNameTEC.clear();
    // emailTEC.clear(); //TODO: uNCOMMENT
    DetailsController.instance.whyTEC.clear();

    // Correctly reset selected course and tutor
    DetailsController.instance.selectedCourse.value = null;
    // DetailsController.instance.selectedTutor.value = null;
  }

  Future<bool> doesUserExistByName() async {
    var exists = false;
    querySnapshot =
        await studentRepo.studentsCollection
            .where('name', isEqualTo: firstNameTEC.text)
            .limit(1)
            .get();
    exists = querySnapshot!.docs.isNotEmpty;

    if (exists) {
      register.value = false;
    }
    return exists;
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

  Future signOut() async {
    querySnapshot =
        await studentRepo.studentsCollection
            .where('email', isEqualTo: emailTEC.text)
            .limit(1)
            .get();

    var data = {"id": querySnapshot!.docs.first.id, "time_out": DateTime.now()};

    await studentRepo.updateUser(data);

    final docSnapshot = await studentRepo.studentsCollection.doc(querySnapshot!.docs.first.id).get();
    final output = docSnapshot.data() as Map<String, dynamic>;



    studentRepo.deleteUser(querySnapshot!.docs.first.id);

    onboardingController.numOfSignedInStudents.value--;

    var name = "${querySnapshot!.docs.first['f_name']} ${querySnapshot!.docs.first['l_name']}";
    var timeIn = (output['time_in'] as Timestamp).toDate();
    var timeOut = (output['time_out'] as Timestamp).toDate();

    Duration duration = timeOut.difference(timeIn);


    Get.to(SuccessPage(userName: name, timeSpent: formatDuration(duration)));  }

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }
}
