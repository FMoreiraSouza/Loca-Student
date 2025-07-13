import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData themeData = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF000000), // Preto para elementos principais
      onPrimary: const Color(0xFFFFFFFF), // Texto branco sobre preto
      secondary: const Color(0xFF4B4B4B), // Cinza escuro para detalhes
      onSecondary: const Color(0xFFFFFFFF), // Texto branco sobre cinza
      background: const Color(0xFFFFFFFF), // Fundo branco
      onBackground: const Color(0xFF000000), // Texto preto no fundo branco
      surface: const Color(0xFFFFFFFF), // Superfície branca
      onSurface: const Color(0xFF000000), // Texto preto nas superfícies
      error: const Color(0xFFB00020), // Vermelho escuro para erros
      onError: const Color(0xFFFFFFFF), // Texto branco sobre erro
    ),
    scaffoldBackgroundColor: const Color(0xFFFFFFFF), // Fundo branco para Scaffold
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF000000)), // Texto principal preto
      bodyMedium: TextStyle(color: Color(0xFF000000)), // Texto secundário preto
      labelLarge: TextStyle(color: Color(0xFF000000)), // Labels de botões
      labelMedium: TextStyle(color: Color(0xFF4B4B4B)), // Labels de campos (cinza escuro)
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFD3D3D3)), // Borda cinza claro
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFD3D3D3)), // Borda cinza claro
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF4B4B4B)), // Cinza escuro quando focado
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFB00020)), // Vermelho escuro para erro
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFB00020)),
      ),
      labelStyle: const TextStyle(color: Color(0xFF4B4B4B)), // Labels cinza escuro
      hintStyle: const TextStyle(color: Color(0xFF808080)), // Hint cinza médio
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF000000), // Botão preto
        foregroundColor: const Color(0xFFFFFFFF), // Texto branco no botão
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF), // AppBar branca
      foregroundColor: Color(0xFF000000), // Ícones e texto pretos
      elevation: 0,
      titleTextStyle: TextStyle(
        color: Color(0xFF000000),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFFB00020), // Vermelho escuro para erros
      contentTextStyle: const TextStyle(color: Color(0xFFFFFFFF)), // Texto branco
      actionTextColor: const Color(0xFFD3D3D3), // Ações em cinza claro
    ),
  );
}