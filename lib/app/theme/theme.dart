// App theme class

import 'package:flutter/material.dart';
import 'colors.dart';

class TurboDexTheme {
  static ThemeData light({TextTheme? textTheme}) {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: TdxColors.red,
      onPrimary: Colors.white,
      secondary: const Color(0xFF262626),
      onSecondary: Colors.white,
      error: TdxColors.error,
      onError: Colors.white,
      background: TdxColors.offWhite,
      onBackground: TdxColors.black,
      surface: Colors.white,
      onSurface: TdxColors.black,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      chipTheme: const ChipThemeData(
        shape: StadiumBorder(),
        showCheckmark: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      textTheme: textTheme,
    );
  }
}
