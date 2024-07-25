import 'package:flutter/material.dart';

class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9f7bf6), // Primary color
      primary: const Color(0xFF9f7bf6), // Primary color
      secondary: const Color(0xFF4ceb8b), // Secondary color
    ),
    useMaterial3: true,
    // Добавляем стиль для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white), // Текст кнопок белый
        ),
      ),
    ),
  );
}
