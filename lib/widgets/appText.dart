import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  const AppText({Key? key, required this.text, this.size,this.color,this.weight,this.align}) : super(key: key);
  final String text;
  final double? size;
  final Color? color;
  final TextAlign? align;
  final FontWeight? weight;
  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(fontSize: size,color: color,fontWeight: weight),textAlign: align  ,);
  }
}