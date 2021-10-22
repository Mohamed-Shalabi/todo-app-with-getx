import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishColor = Color(0xFF4e5ae8);
const Color orangeColor = Color(0xCFFF8746);
const Color pinkColor = Color(0xFFff4667);
const Color white = Colors.white;
const primaryColor = bluishColor;
const Color darkGreyColor = Color(0xFF121212);
const Color darkHeaderColor = Color(0xFF424242);

class Themes {
  static final lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: white,
    appBarTheme: const AppBarTheme(backgroundColor: white),
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryVariant: primaryColor,
      secondary: pinkColor,
      secondaryVariant: pinkColor,
      surface: white,
      background: white,
      error: Colors.red,
      onPrimary: white,
      onSecondary: white,
      onSurface: darkGreyColor,
      onBackground: darkGreyColor,
      onError: white,
      brightness: Brightness.light,
    ),
    brightness: Brightness.light,
  );
  static final darkTheme = ThemeData(
    primaryColor: darkGreyColor,
    scaffoldBackgroundColor: darkGreyColor,
    appBarTheme: const AppBarTheme(backgroundColor: darkGreyColor),
    colorScheme: const ColorScheme(
      primary: primaryColor,
      primaryVariant: primaryColor,
      secondary: pinkColor,
      secondaryVariant: pinkColor,
      surface: darkGreyColor,
      background: darkGreyColor,
      error: Colors.red,
      onPrimary: white,
      onSecondary: white,
      onSurface: white,
      onBackground: white,
      onError: white,
      brightness: Brightness.dark,
    ),
    brightness: Brightness.dark,
  );
}

TextStyle get headingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? white : Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
TextStyle get subHeadingStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? white : Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    );
TextStyle get titleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? white : Colors.black,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
TextStyle get subTitleStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? white : Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    );
TextStyle get bodyStyle => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? white : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
TextStyle get body2Style => GoogleFonts.lato(
      textStyle: TextStyle(
        color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
