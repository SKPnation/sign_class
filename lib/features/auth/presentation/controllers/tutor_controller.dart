// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:sign_class/core/global/success_page.dart';
// import 'package:sign_class/core/utils/functions.dart';
// import 'package:sign_class/features/auth/data/models/student_model.dart';
// import 'package:sign_class/features/auth/data/repos/student_repo_impl.dart';
// import 'package:sign_class/features/tutor/data/tutor_repo_impl.dart';
// import 'package:sign_class/features/details/data/models/tutor_model.dart';
// import 'package:sign_class/features/controllers/onboarding_controller.dart';
//
// class TutorController extends GetxController {
//   static TutorController get instance => Get.find();
//
//   final tutorRepo = TutorRepoImpl();
//
//   DocumentReference<Map<String, dynamic>> tutorUserRef(String userId) =>
//       FirebaseFirestore.instance.doc('/tutors/$userId');
//   QuerySnapshot<Object?>? querySnapshot;
//
//   var authPageTitle = "".obs;
//   var register = false.obs;
//   var students = <Student>[].obs;
//   var tutor = Rx<Tutor?>(null);
//   Rx<Student?>? filteredEmail;
//   var errorText = "".obs;
//
//   RxMap<String, dynamic> availability = <String, dynamic>{}.obs;
//
//   final emailTEC = TextEditingController(text: "@pvamu.edu");
//
//   Future signIn() async {
//     QuerySnapshot<Object?>? studentQuerySnapshot;
//
//     querySnapshot =
//         await tutorRepo.tutorsCollection
//             .where('email', isEqualTo: emailTEC.text)
//             .limit(1)
//             .get();
//
//     var data = {
//       "id": querySnapshot!.docs.first.id,
//       "time_in": DateTime.now(),
//       "time_out": null,
//     };
//
//     await tutorRepo.updateUser(data);
//
//     if (querySnapshot?.size == 0) {
//       errorText.value = "This account doesn't exist";
//     }
//     else {
//       tutor.value =
//           await querySnapshot?.docs
//               .map(
//                 (doc) async =>
//                     Tutor.fromMap(doc.data() as Map<String, dynamic>),
//               )
//               .first;
//
//       await getAvailability();
//
//       studentQuerySnapshot =
//           await studentRepo.studentsCollection
//               .where(
//                 'tutor',
//                 isEqualTo: tutorUserRef(querySnapshot!.docs.first.id),
//               )
//               .where('time_out', isEqualTo: null)
//               .get();
//
//       if (studentQuerySnapshot.docs.isNotEmpty) {
//         students.value = await Future.wait(
//           studentQuerySnapshot.docs.map(
//             (doc) async => await Student.fromMapAsync(
//               doc.data() as Map<String, dynamic>,
//               doc.id,
//             ),
//           ),
//         );
//       }
//
//       // emailTEC.clear();
//       students.clear();
//     }
//   }
//
//   signOut() async {
//     querySnapshot =
//         await tutorRepo.tutorsCollection
//             .where('email', isEqualTo: emailTEC.text)
//             .limit(1)
//             .get();
//
//     Map<String, dynamic> data = querySnapshot!.docs.first.data() as Map<String, dynamic>;
//
//     var userName = data['name'];
//     var timeIn = (data['time_in'] as Timestamp).toDate();
//     var timeOut = DateTime.now();
//
//     Duration duration = timeOut.difference(timeIn);
//
//     var input = {
//       "id": querySnapshot!.docs.first.id,
//       "time_out": timeOut
//     };
//
//     await tutorRepo.updateUser(input);
//
//     tutor.value = null;
//
//     // Navigator.push(
//     //   Get.context!,
//     //   MaterialPageRoute(builder: (context)
//     //   => SuccessPage(userName: userName, timeSpent: formatDuration(duration))),
//     // );
//   }
//
//   Future setSchedule(
//     String selectedDay,
//     TimeOfDay startTime,
//     TimeOfDay endTime,
//   ) async {
//     selectedDay = selectedDay.toLowerCase();
//     // final start = startTime.format(Get.context!); // e.g. "9:30 AM"
//     // final end = endTime.format(Get.context!);
//
//     // var input = {selectedDay: "$start - $end"};
//
//     if (tutor.value != null) {
//       // await tutorRepo.setSchedule(input, tutor.value!.id!);
//     }
//   }
//
//   Future getAvailability() async {
//     final tutorId = tutor.value?.id;
//
//     if (tutorId == null) {
//       print("Tutor or tutor ID is null, cannot fetch availability.");
//       return;
//     }
//
//     final data = await tutorRepo.getMyAvailability(tutorId);
//
//     availability.value = data;
//   }
//
//   bool isPvamuEmail(String email) {
//     return email.contains('@pvamu.edu');
//   }
// }
