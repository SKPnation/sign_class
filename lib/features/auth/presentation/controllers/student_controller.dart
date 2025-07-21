import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/success_page.dart';
import 'package:sign_class/features/auth/data/models/student_model.dart';
import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';
import 'package:sign_class/features/home/presentation/controllers/home_controller.dart';

class StudentController extends GetxController {
  static StudentController get instance => Get.find();

  final homeController = HomeController.instance;

  final studentRepo = StudentRepoImpl();

  var authPageTitle = "".obs;

  final TextEditingController nameTEC = TextEditingController();
  final TextEditingController emailTEC = TextEditingController();

  var register = false.obs;

  var filteredNames = <Student>[].obs;

  QuerySnapshot<Object?>? querySnapshot;

  void onTextChanged(String input) async {
    filteredNames.value = await studentRepo.getStudentsByNamePrefix(input);

    // filteredNames.value =
    //     allNames
    //         .where((name) => name.toLowerCase().startsWith(input.toLowerCase()))
    //         .toList();
  }

  void onNameSelected(String name) {
    nameTEC.text = name;
    filteredNames.clear();
  }

  addStudent() async {
    Student studentModel = Student(
      id: studentRepo.studentsCollection.doc().id,
      name: nameTEC.text,
      email: emailTEC.text,
      createdAt: DateTime.now(),
      timeIn: DateTime.now(),
    );

    await studentRepo.createStudent(studentModel);
    homeController.numOfSignedInStudents.value++;

    Get.to(SuccessPage(userName: nameTEC.text));
  }

  Future signIn() async {
    var data = {
      "id": querySnapshot!.docs.first.id,
      "time_in": DateTime.now(),
    };

    await studentRepo.updateUser(data);
    homeController.numOfSignedInStudents.value++;

    Get.to(SuccessPage(userName: nameTEC.text));

  }

  Future<bool> doesUserExistByName() async {
    var exists = false;
    querySnapshot =
        await studentRepo.studentsCollection
            .where('name', isEqualTo: nameTEC.text)
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

    if (querySnapshot!.docs.isNotEmpty) {
      var data = {
        "time_in": DateTime.now(),
      };

      await studentRepo.updateUser(data);
      studentRepo.deleteUser(querySnapshot!.docs.first.id);

      homeController.numOfSignedInStudents.value--;

      Get.to(SuccessPage(userName: nameTEC.text));
    }
  }

  bool isPvamuEmail(String email) {
    return email.contains('@pvamu.edu');
  }
}
