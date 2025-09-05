import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sign_class/features/onboarding/presentation/pages/onboarding.dart' show OnboardingPage;

class LargeScreen extends StatelessWidget {
  const LargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: OnboardingPage()
        )
      ],
    );
  }
}
