import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/student_repo_impl.dart';

class StudentAuthController extends GetxController {
  static StudentAuthController get instance => Get.find();

  final studentRepo = StudentRepoImpl();

  final emailTEC = TextEditingController(text: "@pvamu.edu");
  final TextEditingController firstNameTEC = TextEditingController();
  final TextEditingController lastNameTEC = TextEditingController();

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

}