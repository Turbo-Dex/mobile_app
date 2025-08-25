import 'package:flutter/material.dart';
import 'colors.dart';

class TurboDexTheme {
  static ThemeData light({TextTheme? textTheme}) {
    final base = ThemeData.light(useMaterial3: true);
    final colorScheme = base.colorScheme.copyWith(
      primary: TdxColors.red,
      onPrimary: Colors.white,
      surface: TdxColors.offWhite,
      onSurface: TdxColors.black,
      error: TdxColors.error,
      onError: Colors.white,
      // pas de background/onBackground
    );

    return base.copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
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
