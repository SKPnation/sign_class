import 'package:get/get.dart';

class HomeController extends GetxController{
  static final HomeController instance = Get.find();

  var numOfSignedInStudents = 0.obs;
}