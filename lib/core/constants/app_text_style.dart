import 'package:flutter/material.dart';

class AppTextTheme {
  AppTextTheme._();

  static const String _fontFamily = 'SignikaNegative';

  // 🔆 Light Theme
  static TextTheme lightTextTheme = const TextTheme(

    /// Headlines
    headlineLarge: TextStyle(
      fontSize: 34,
      fontWeight: FontWeight.w700,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),

    /// Titles
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),

    /// Body
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),

    /// Labels (Buttons, captions)
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: _fontFamily,
      color: Color(0xff5a3129),
    ),
  );
}
