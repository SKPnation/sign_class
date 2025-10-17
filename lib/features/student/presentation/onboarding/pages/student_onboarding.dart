import 'package:flutter/material.dart';
import 'package:sign_class/core/helpers/responsiveness.dart';
import 'package:sign_class/features/student/presentation/onboarding/widgets/onboarding_large.dart';
import 'package:sign_class/features/student/presentation/onboarding/widgets/onboarding_small.dart';

class StudentOnboarding extends StatelessWidget {
  const StudentOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    if (ResponsiveWidget.isSmallScreen(context)) {
      return StudentOnboardingSmall();
    } else {
      return StudentOnboardingLarge();
    }
  }
}
