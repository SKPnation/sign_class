import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String? text;
  final double? size;
  final Color? color;
  final FontWeight? weight;
  final FontStyle? fontStyle;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const CustomText({
    this.text,
    this.size,
    this.color,
    this.weight,
    this.fontStyle,
    this.textStyle,
    this.textAlign,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      textAlign: textAlign,
      style:
          textStyle ??
          TextStyle(
            color: color,
            fontSize: size,
            fontWeight: weight,
            fontStyle: fontStyle,
          ),
    );
  }
}
