import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  static final AuthController instance = Get.find();

  var authPageTitle = "".obs;

  final TextEditingController nameTEC = TextEditingController();
  final List<String> allNames = [
    'Alex',
    'Alexa',
    'Alexander',
    'Alice',
    'Alvin',
    'Alicia',
    'Alfred',
  ]; // Replace with backend data in real use

  var filteredNames = [].obs;

  void onTextChanged(String input) {
    filteredNames.value = allNames
        .where((name) => name.toLowerCase().startsWith(input.toLowerCase()))
        .toList();
  }

  void onNameSelected(String name) {
    nameTEC.text = name;
    filteredNames.clear();
  }

  signIn(){}

  signOut(){}
}