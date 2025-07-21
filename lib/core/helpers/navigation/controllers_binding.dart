import 'package:get/get.dart';
import 'package:sign_class/features/auth/presentation/controllers/student_controller.dart';
import 'package:sign_class/features/details/presentation/controllers/details_controller.dart';
import 'package:sign_class/features/home/presentation/controllers/home_controller.dart';

class AllControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => StudentController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => DetailsController());
  }
}

