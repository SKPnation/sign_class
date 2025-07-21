import 'package:get/get.dart';

class HomeController extends GetxController{
  static HomeController get instance => Get.find();

  var numOfSignedInStudents = 0.obs;
}