import 'package:flutter/material.dart';
import 'package:sign_class/core/helpers/responsiveness.dart';
import 'package:sign_class/features/site_layout/presentation/widgets/large_screen.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: const LargeScreen(),
        // smallScreen: Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16),
        //   child: localNavigator(),
        // )
    );
  }
}
