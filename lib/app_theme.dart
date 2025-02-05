import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static Color get primaryLight => const Color(0xff3EC1AF);

  static Color get primaryDark => const Color(0xff3EC1AF);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryLight,
      dividerColor: Colors.black,
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      cardColor: Colors.grey.shade200,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryLight,
        brightness: Brightness.light,
        primary: primaryLight,
        secondary: primaryLight,
        surface: const Color(0XFFF5F5F5),
      ),
      fontFamily: 'inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 19,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
