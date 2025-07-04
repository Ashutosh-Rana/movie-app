import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';

ThemeData lightTheme = ThemeData.dark(useMaterial3: true).copyWith(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
  brightness: Brightness.light,
  primaryColor: AppColors.primary,
  primaryColorDark: AppColors.primary[800],
  primaryColorLight: AppColors.primary[200],
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.secondary[25],
    elevation: 5,
    shadowColor: AppColors.primary.shade50,
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    circularTrackColor: AppColors.primary.shade100,
    color: AppColors.primary,
  ),
  textTheme: GoogleFonts.ibmPlexSansTextTheme(
    TextTheme(
      titleLarge: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
      titleMedium: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary.shade900,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary.shade900,
      ),
      labelSmall: TextStyle(fontSize: 12, color: AppColors.secondary.shade900),
      bodyLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: AppColors.primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.secondary.shade900,
      ),
      bodySmall: TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        color: AppColors.secondary.shade900,
      ),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(AppColors.gray.shade700),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      alignment: Alignment.center,
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    constraints: const BoxConstraints(
      minHeight: 44,
      minWidth: 320,
      maxWidth: 320,
    ),
    fillColor: Colors.white,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
    errorStyle: const TextStyle(
      fontSize: 0,
      fontWeight: FontWeight.bold,
      color: AppColors.error,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray.shade300, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray.shade300, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray.shade300, width: 1),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.gray.shade300, width: 1),
    ),
    hintStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.gray,
    ),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: IconButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.gray.shade700,
      minimumSize: const Size(48, 48),
      maximumSize: const Size(48, 48),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      foregroundColor: Colors.white,
      disabledForegroundColor: AppColors.gray.shade400,
      side: BorderSide.none,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      side: const BorderSide(color: Colors.white, width: 2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  ),
  canvasColor: Colors.white,
);
