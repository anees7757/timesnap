import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color accentColor = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color primaryTextLight = Color(0xFF1E293B);
  static const Color secondaryTextLight = Color(0xFF64748B);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  
  static const Color primaryTextDark = Color(0xFFFFFFFF);
  static const Color secondaryTextDark = Color(0xFF9CA3AF);
  static const Color backgroundDark = Color(0xFF000000);

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
      surface: backgroundDark,
      onSurface: primaryTextDark,
      surfaceContainerLow: const Color(0xFF0A0A0A),
      surfaceContainerHighest: const Color(0xFF1A1A1A),
    ),
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
      displayLarge: GoogleFonts.outfit(
        color: primaryTextDark,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: GoogleFonts.outfit(
        color: primaryTextDark,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: GoogleFonts.outfit(
        color: secondaryTextDark,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: GoogleFonts.outfit(
        color: secondaryTextDark,
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundDark,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
