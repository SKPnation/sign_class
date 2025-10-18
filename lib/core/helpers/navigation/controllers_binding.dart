import 'package:get/get.dart';
import 'package:sign_class/features/controllers/onboarding_controller.dart';
import 'package:sign_class/features/student/presentation/auth/controllers/student_auth_controller.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';

class AllControllerBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
    Get.lazyPut(() => TutorAuthController());
    Get.lazyPut(() => StudentAuthController());
    // Get.lazyPut(() => DetailsController());
    // Get.lazyPut(() => TutorController());
  }
}

