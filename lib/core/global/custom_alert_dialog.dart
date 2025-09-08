import 'package:flutter/material.dart';
import 'package:sign_class/core/theme/colors.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({super.key, required this.title, required this.content});

  final Widget title;
  final Widget content;

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      title: widget.title,
      content: widget.content,
      actions: actions,
    );
  }
}
