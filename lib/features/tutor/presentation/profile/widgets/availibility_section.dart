import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:sign_class/core/global/custom_alert_dialog.dart';
import 'package:sign_class/core/global/custom_button.dart';
import 'package:sign_class/core/global/custom_text.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/features/tutor/presentation/auth/controllers/tutor_auth_controller.dart';

class AvailabilitySection extends StatelessWidget {
  const AvailabilitySection({super.key, required this.tutorAuthController, required this.sortedEntries});

  final TutorAuthController tutorAuthController;
  final List<MapEntry<String, dynamic>> sortedEntries;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        tutorAuthController.availability.isNotEmpty
            ? SizedBox(
          width: 200,
          child: CustomButton(
            bgColor: AppColors.gold,
            onPressed: () {
              //open dialog
              Get.dialog(
                CustomAlertDialog(
                  title: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [Text("My availability")],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children:
                    sortedEntries.map((e) {
                      var heading = e.key;
                      var body = e.value;

                      return Column(
                        children: [
                          Text(
                            heading[0].toUpperCase() +
                                heading.substring(1),
                            // Capitalize
                            style: const TextStyle(
                              fontWeight:
                              FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            body.toString(),
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            child: CustomText(
              text: "View availability",
              color: AppColors.white,
            ),
          ),
        )
            : SizedBox(),

        tutorAuthController.availability.isNotEmpty
            ? const SizedBox(height: 8)
            : SizedBox(),

      ],
    );
  }
}
