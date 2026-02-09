import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';

class MyButton extends StatelessWidget {
  final String text;
  VoidCallback onPressed;
  final Color buttonColor;
  final Color textColor;

  MyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.buttonColor = Colors.white,
    this.textColor = AppColors.blurple,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      color: buttonColor,
      child: Text(text, style: TextStyle(color: textColor)),
    );
  }
}
