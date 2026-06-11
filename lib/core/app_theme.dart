import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.midnightBlue,
        colorScheme: const ColorScheme.light(
          primary: AppColors.midnightBlue,
          secondary: AppColors.champagneGold,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: AppColors.midnightBlue,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.champagneGold,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: AppColors.borderGray),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide:
                const BorderSide(color: AppColors.champagneGold, width: 2),
          ),
        ),
      );
}

// ── Text style helpers ──────────────────────────────────────────────────────

TextStyle headline(double size,
        {Color color = AppColors.midnightBlue}) =>
    GoogleFonts.playfairDisplay(
        fontSize: size, fontWeight: FontWeight.bold, color: color);

TextStyle body(double size,
        {Color color = AppColors.textPrimary,
        FontWeight fw = FontWeight.normal}) =>
    GoogleFonts.inter(fontSize: size, fontWeight: fw, color: color);

TextStyle label(double size, {Color color = AppColors.textGray}) =>
    GoogleFonts.inter(
        fontSize: size,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: color);

List<BoxShadow> get cardShadow => [
      BoxShadow(
          color: const Color(0xFF031636).withOpacity(0.06),
          blurRadius: 20,
          offset: const Offset(0, 4))
    ];
