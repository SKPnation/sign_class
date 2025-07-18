import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DetailsController extends GetxController{
  static final DetailsController instance = Get.find();

  TextEditingController whyTEC = TextEditingController();

  var selectedCourse = "".obs;

  final List<Map<String, dynamic>> courses = [
    {"id": 1, "name": "Computer Science"},
    {"id": 2, "name": "Mathematics"},
    {"id": 3, "name": "Biology"},
    {"id": 4, "name": "Physics"},
  ];


}