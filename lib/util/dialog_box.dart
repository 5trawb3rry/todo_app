import 'package:flutter/material.dart   ';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/util/my_button.dart';

class DialogBox extends StatelessWidget {
  final controller;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  DialogBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),

            //user input
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: "Enter Task Name",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: AppColors.lightBeige,
              ),
            ),

            SizedBox(height: 20),

            //buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //save button
                MyButton(text: "Save", onPressed: onSave),

                const SafeArea(child: SizedBox(width: 10)),

                //cancel button
                MyButton(
                  text: "Cancel",
                  onPressed: onCancel,
                  buttonColor: Colors.white,
                  textColor: AppColors.darkRed,
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.blurple,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
