import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/constants/app_strings.dart';
import 'package:sign_class/core/data/local/get_store.dart';
import 'package:sign_class/core/global/sign_out_success.dart';
import 'package:sign_class/core/utils/functions.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/data/models/course_model.dart';
import 'package:sign_class/features/student/data/models/my_profile_model.dart';
import 'package:sign_class/features/student/data/models/tutor_model.dart';
import 'package:sign_class/features/student/data/repos/courses_repo_impl.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/student/data/repos/user_data_store.dart';
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

    if (filteredEmail != null && filteredEmail?.value != null) {
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
    final purposeController = PurposeController.instance;

    final snap = await studentRepo.studentsCollection
        .where('email', isEqualTo: emailTEC.text.trim())
        .limit(1)
        .get();

    if (snap.docs.isEmpty) {
      Get.snackbar("Error", "Student not found");
      return;
    }

    final doc = snap.docs.first;
    final docId = doc.id;

    // Write to Firestore with Timestamp (correct for Firestore)
    await studentRepo.updateUser({
      "id": docId,
      "course": course?.id,
      "tutor": tutor?.id,
      "time_in": Timestamp.fromDate(DateTime.now()),
      "time_out": null,
    });

    onboardingController.numOfSignedInStudents.value++;
    firstName.value = doc['f_name'];
    lastName.value = doc['l_name'];

    // Build local cache payload (can contain Firestore data -> sanitize)
    final Map<String, dynamic> dataToStore = {
      "id": docId,
      "student": doc.data(), // may contain Timestamps/refs
      "goal": purposeController.selectedGoal.value,
      "time_in": DateTime.now(), // will be converted by jsonSafe
      "tutor": null,
      "course": null,
      "time_out": null,
      "user_type": AppStrings.student,
    };

    if (course != null) {
      final courseMap =
      (await CoursesRepoImpl().coursesCollection.doc(course.id).get()).data();
      dataToStore["course"] = courseMap;
    }

    if (tutor != null) {
      final tutorMap =
      (await tutorRepo.tutorsCollection.doc(tutor.id).get()).data();
      dataToStore["tutor"] = tutorMap;
    }

    // ✅ Make everything JSON-encodable before writing to GetStorage
    userDataStore.user = Map<String, dynamic>.from(encodeFirestoreForJson(dataToStore));

    print("SIGN IN: PROFILE: ${userDataStore.user}");

    Get.offAll(StudentProfilePage());
  }

  Future<void> signOut() async {
    MyProfileModel profileModel = MyProfileModel.fromMap(userDataStore.user);
    final email = profileModel.student['email'];
    if (email.isEmpty) {
      // show a toast/snackbar if you have one
      Get.snackbar("Sign out failed", "Email is empty.");
      return;
    }

    // query by email (case-sensitive); if you store emails normalized, also normalize here
    final qs = await studentRepo.studentsCollection
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (qs.docs.isEmpty) {
      Get.snackbar("Sign out failed", "No student found for $email.");
      return;
    }

    final doc = qs.docs.first;
    final data = Map<String, dynamic>.from(doc.data() as Map);

    // parse time_in safely
    DateTime? timeIn;
    final rawTimeIn = data['time_in'];
    if (rawTimeIn is Timestamp) {
      timeIn = rawTimeIn.toDate();
    } else if (rawTimeIn is String) {
      timeIn = DateTime.tryParse(rawTimeIn);
    }

    final timeOut = DateTime.now();

    // compute duration only if time_in is available/valid
    final Duration duration = (timeIn != null)
        ? timeOut.difference(timeIn)
        : Duration.zero;

    // update Firestore + local store
    await studentRepo.updateUser({
      "id": doc.id,
      "time_out": timeOut, // Firestore SDK will store as Timestamp
    });

    // navigate
    Get.to(
      SignOutSuccessPage(
        userName: "${firstName.value} ${lastName.value}",
        timeSpent: formatDuration(duration), // handle Duration.zero nicely inside
      ),
    );

    // clear local cache last
    getStore.clearAllData();
  }
}
