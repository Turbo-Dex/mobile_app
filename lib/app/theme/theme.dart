import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class TurboDexTheme {
  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: TdxColors.red,
      onPrimary: Colors.white,
      secondary: TdxColors.black,
      onSecondary: Colors.white,
      error: TdxColors.error,
      onError: Colors.white,
      surface: TdxColors.offWhite, // fond d’app
      onSurface: TdxColors.black,

      // conteneurs / variantes
      primaryContainer: const Color(0xFFEB908F),
      onPrimaryContainer: TdxColors.black,
      secondaryContainer: TdxColors.neutral200,
      onSecondaryContainer: TdxColors.black,
      surfaceContainerHighest: Colors.white,
      surfaceContainerHigh: Colors.white,
      surfaceContainer: Colors.white,
      surfaceContainerLow: TdxColors.offWhite,
      surfaceContainerLowest: TdxColors.offWhite,
      outline: TdxColors.neutral200,
      outlineVariant: TdxColors.neutral300,
      shadow: Colors.black.withOpacity(.12),
      scrim: Colors.black.withOpacity(.24),
      inverseSurface: TdxColors.black,
      onInverseSurface: Colors.white,
      inversePrimary: const Color(0xFFFFC1BF),
      tertiary: TdxColors.success,
      onTertiary: Colors.white,
      tertiaryContainer: TdxColors.neutral100,
      onTertiaryContainer: TdxColors.black,
    );

    final textTheme = GoogleFonts.montserratTextTheme().copyWith(
      displayLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      displayMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      headlineLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w700),
      bodyLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w500),
      labelLarge: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
      labelMedium: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
      labelSmall: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      iconTheme: const IconThemeData(size: 22, color: TdxColors.black),
      dividerColor: TdxColors.neutral200,
    );

    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: TdxColors.red,
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: TdxColors.offWhite,
        indicatorColor: TdxColors.red.withOpacity(.12),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? TdxColors.red : TdxColors.neutral600,
          );
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelMedium!.copyWith(
            color: selected ? TdxColors.red : TdxColors.neutral600,
          );
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TdxColors.red,
          foregroundColor: Colors.white,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          side: const BorderSide(color: TdxColors.neutral300),
          foregroundColor: TdxColors.black,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: TdxColors.red,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: TdxColors.neutral100,
        labelStyle: textTheme.labelMedium!,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: const StadiumBorder(),
        side: const BorderSide(color: TdxColors.neutral300),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: TdxColors.neutral200),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TdxColors.neutral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TdxColors.neutral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: TdxColors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
    );
  }
}
