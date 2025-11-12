import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/student/data/models/student_model.dart';
import 'package:sign_class/features/student/data/repos/user_data_store.dart';
import 'package:sign_class/features/tutor/data/tutor_model.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';
import 'package:sign_class/features/tutor/presentation/profile/widgets/availibility_section.dart';

class TutorProfilePage extends StatefulWidget {
  const TutorProfilePage({super.key});

  @override
  State<TutorProfilePage> createState() => _TutorProfilePageState();
}

class _TutorProfilePageState extends State<TutorProfilePage> {
  final tutorAuthController = TutorAuthController.instance;
  final List<String> weekdayOrder = const [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];

  @override
  void initState() {
    tutorAuthController.getAvailability();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // block back
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              // keep content narrow & centered
              child: Obx(() {
                List<Student> students = <Student>[];
                final raw = userDataStore.user['students'];
                if (raw is List && raw.isNotEmpty) {
                  students = raw.map((e) {
                    final m = Map<String, dynamic>.from(e as Map);
                    return Student.fromMap(m, m['id']);
                  }).toList();
                }

                // sort availability when present
                final availability = tutorAuthController.availability;
                final sortedEntries =
                    availability.isEmpty
                        ? const <MapEntry<String, dynamic>>[]
                        : (availability.entries.toList()..sort(
                          (a, b) => weekdayOrder
                              .indexOf(a.key.toLowerCase())
                              .compareTo(
                                weekdayOrder.indexOf(b.key.toLowerCase()),
                              ),
                        ));

                final t = Tutor.fromMap(userDataStore.user['tutor']);
                // final students = tutorAuthController.students;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const CustomText(
                        text: "Profile",
                        weight: FontWeight.bold,
                      ),

                      const SizedBox(height: 30),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 24),
                      CustomText(
                        text:
                            "Signed in as: ${t.fName ?? ''} ${t.lName ?? ''}"
                                .trim(),
                        size: 16,
                      ),

                      const SizedBox(height: 24),
                      const Text(
                        "Booked Students",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      if (students.isEmpty)
                        const CustomText(text: "None")
                      else
                        Center(
                          child: SizedBox(
                            width: 260,
                            // tighter width so list text appears centered
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (final s in students) ...[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      "${s.fName ?? ''} ${s.lName ?? ''}"
                                          .trim(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),

                      const SizedBox(height: 32),

                      // Availability section
                      AvailabilitySection(
                        tutorAuthController: tutorAuthController,
                        sortedEntries: sortedEntries,
                      ),

                      const SizedBox(height: 8),
                      SizedBox(
                        width: 200,
                        child: CustomButton(
                          onPressed: () async {
                            await tutorAuthController.signOut();
                          },
                          text: "Sign out",
                          bgColor: AppColors.red,
                          textColor: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
