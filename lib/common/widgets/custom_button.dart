import 'package:flutter/material.dart';
import 'package:whatsapp_clone/assets/colors.dart';
import 'package:whatsapp_clone/widgets/appText.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key? key, required this.text, required this.onPressed}) : super(key: key);
  final String text;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: tabColor,
          minimumSize: const Size(double.infinity,50)

        ),
        child: AppText(text: text,color:Colors.black),
    );
  }
}