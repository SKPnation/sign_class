import 'package:flutter/material.dart';

class UnFocusWidget extends StatelessWidget {
  const UnFocusWidget({super.key, this.child, this.onTap});
  final Widget? child;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap,
      child: child,
    );
  }
}