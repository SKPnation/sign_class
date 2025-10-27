import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';
import 'package:sign_class/features/tutor/presentation/profile/widgets/availibility_section.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({super.key});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  final tutorAuthController = TutorAuthController.instance;
  var sortedEntries = <MapEntry<String, dynamic>>[];

  final List<String> weekdayOrder = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (tutorAuthController.availability.isNotEmpty) {
            // Sort the map into a list of entries based on weekday order
            sortedEntries =
                tutorAuthController.availability.entries.toList()..sort(
                  (a, b) => weekdayOrder
                      .indexOf(a.key.toLowerCase())
                      .compareTo(weekdayOrder.indexOf(b.key.toLowerCase())),
                );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(text: "Profile", weight: FontWeight.bold),

              SizedBox(height: 30),

              CircleAvatar(
                radius: 50,
                // adjust size
                backgroundColor: Colors.grey[300],
                // backgroundImage: tutorAuthController.tutor.value?.profileImage != null
                //     ? NetworkImage(tutorAuthController.tutor.value?.profileImage!)
                //     : null,
                child: Icon(Icons.person, size: 50, color: Colors.white),

                // tutor?.profileImage == null
                //     ? const Icon(
                //   Icons.person,
                //   size: 50,
                //   color: Colors.white,
                // )
                //     : null,
              ),

              SizedBox(height: 40),

              CustomText(
                text:
                    "Signed in as: ${tutorAuthController.tutor.value?.fName} ${tutorAuthController.tutor.value?.lName}",
                size: 16,
              ),

              SizedBox(height: 24),

              const Text(
                "Booked Students",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),

              tutorAuthController.students.isEmpty
                  ? const CustomText(text: "None")
                  : Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: tutorAuthController.students.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            "${tutorAuthController.students[index].fName!} ${tutorAuthController.students[index].lName!}",
                          ),
                          textColor: Colors.white,
                        );
                      },
                    ),
                  ),

              SizedBox(height: 40),

              //Availability section
              AvailabilitySection(
                tutorAuthController: tutorAuthController,
                sortedEntries: sortedEntries,
              ),

              SizedBox(
                width: 200,
                child: CustomButton(
                  onPressed: () async {
                    print(tutorAuthController.emailTEC.text);
                    await tutorAuthController.signOut();
                  },
                  text: "Sign out",
                  bgColor: AppColors.red,
                  textColor: AppColors.white,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
