import 'package:flutter/material.dart';
import 'package:sign_class/core/helpers/responsiveness.dart';
import 'package:sign_class/core/helpers/size_helpers.dart';
import 'package:sign_class/core/theme/colors.dart';
import 'package:sign_class/core/theme/fonts.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final Widget? child;
  final Color? bgColor;
  final Color? textColor;
  final bool? showBorder;
  final double? fontSize;
  final Function()? onPressed;

  const CustomButton({
    super.key,
    this.text,
    required this.onPressed,
    this.child,
    this.bgColor,
    this.showBorder = false,
    this.textColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? AppColors.gold,
        minimumSize: Size(displayWidth(context), 44),
        shadowColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: showBorder ==true ? BorderSide(width: 1, color: AppColors.gold) : BorderSide.none,
        ),
      ),
      onPressed: onPressed,
      child:
          child ??
          Text(
            text!,
            style: TextStyle(
              fontSize:
                  ResponsiveWidget.isSmallScreen(context) ? fontSize
                      ?? AppFonts.defaultSize
                      : fontSize ?? AppFonts.baseSize,
              color: textColor ?? AppColors.white,
            ),
          ),
    );
  }
}
