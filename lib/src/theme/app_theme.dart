import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF311447);
  static const Color backgroundColor = Color(0xFF281E2E);
  static const Color textColor = Color(0xFFF1F1F1);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF007BFF), Color(0xFFC800FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static ThemeData get themeData {
    final baseTextTheme = GoogleFonts.robotoTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: textColor, displayColor: textColor);

    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        surface: backgroundColor,
        onSurface: textColor,
        onPrimary: textColor,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.96,
          //height: 48 / 48,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          fontSize: 32,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          //height: 40 / 32,
        ),
        headlineSmall: baseTextTheme.headlineSmall?.copyWith(
          fontSize: 28,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          //height: 36 / 28,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          //height: 28 / 22,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          //height: 24 / 16,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          //height: 20 / 14,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          //height: 24 / 16,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          //height: 20 / 14,
        ),
      ),
      useMaterial3: true,
    );
  }
}

extension AppThemeExtension on ThemeData {
  LinearGradient get accentGradient => AppTheme.accentGradient;
  Color get textColor => AppTheme.textColor;
}
