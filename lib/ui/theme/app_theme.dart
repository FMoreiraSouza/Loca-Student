import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFFFFFFF),
      onPrimary: Color(0xFF000000),
      secondary: Color(0xFF4B4B4B),
      onSecondary: Color(0xFFFFFFFF),
      surface: Color(0xFF121212),
      onSurface: Color(0xFFFFFFFF),
      error: Color(0xFFCF6679),
      onError: Color(0xFF000000),
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
      bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
      labelLarge: TextStyle(color: Color(0xFFFFFFFF)),
      labelMedium: TextStyle(color: Color(0xFFFFFFFF)),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF000000),
      foregroundColor: Color(0xFFFFFFFF),
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFFFFFFFF),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF000000),
      selectedItemColor: Color(0xFFFFFFFF),
      unselectedItemColor: Color(0xFF888888),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFFFFF),
        foregroundColor: const Color(0xFF000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF444444))),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF444444))),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFFFFFFF))),
      errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFCF6679))),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFCF6679)),
      ),
      labelStyle: const TextStyle(color: Color(0xFFFFFFFF)),
      hintStyle: const TextStyle(color: Color(0xFFAAAAAA)),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF333333),
      contentTextStyle: TextStyle(color: Color(0xFFFFFFFF)),
      actionTextColor: Color(0xFFFFFFFF),
    ),
  );
}
