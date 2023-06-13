import 'package:flutter/material.dart';
import 'package:whatsapp_clone/assets/colors.dart';

ThemeData theme(){
  return ThemeData.dark().copyWith(
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      color: appBarColor
    ),
  );
}


TextTheme textTheme() {
  return const TextTheme(
      displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold
      ),
      displayMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold
      ),
      displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
      ),
      headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
      ),
      headlineSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold
      ),
      titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal
      ),
      bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.normal
      ),
      bodyMedium: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.normal
      )
  );
}