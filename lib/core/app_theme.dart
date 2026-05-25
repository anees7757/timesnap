import 'package:flutter/material.dart';

class AppTheme {
  // ── Accent Palette ──
  static const Color accentColor = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4F46E5);

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentColor, Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Surface / Card Palette ──
  static const Color backgroundDark = Color(0xFF000000);
  static const Color surfaceDark = Color(0xFF0A0A0A);
  static const Color cardDark = Color(0xFF141414);
  static const Color cardHighDark = Color(0xFF1A1A1A);
  static const Color glassDark = Color(0xFF1E1E1E);

  // ── Text ──
  static const Color primaryTextDark = Color(0xFFFFFFFF);
  static const Color secondaryTextDark = Color(0xFF9CA3AF);
  static const Color tertiaryTextDark = Color(0xFF6B7280);

  // ── Effects ──
  static const Color glowColor = Color(0xFF6366F1);
  static const Color shimmerColor = Color(0x1A818CF8);

  // ── Light mode leftovers (kept for potential future use) ──
  static const Color primaryTextLight = Color(0xFF1E293B);
  static const Color secondaryTextLight = Color(0xFF64748B);
  static const Color backgroundLight = Color(0xFFF8FAFC);

  // ── Theme ──
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accentColor,
      brightness: Brightness.dark,
      surface: backgroundDark,
      onSurface: primaryTextDark,
      surfaceContainerLow: surfaceDark,
      surfaceContainerHighest: cardHighDark,
    ),
    scaffoldBackgroundColor: backgroundDark,

    // ── Typography ──
    textTheme: ThemeData.dark().textTheme.copyWith(
      displayLarge: const TextStyle(
        color: primaryTextDark,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
      ),
      headlineMedium: const TextStyle(
        color: primaryTextDark,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      ),
      headlineSmall: const TextStyle(
        color: primaryTextDark,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: const TextStyle(
        color: primaryTextDark,
        fontWeight: FontWeight.w600,
      ),
      labelSmall: const TextStyle(
        color: secondaryTextDark,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: const TextStyle(
        color: secondaryTextDark,
      ),
      bodySmall: const TextStyle(
        color: tertiaryTextDark,
      ),
    ),

    // ── AppBar ──
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: primaryTextDark,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
      iconTheme: IconThemeData(color: primaryTextDark, size: 22),
    ),

    // ── Inputs ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accentColor, width: 1.5),
      ),
      labelStyle: const TextStyle(color: secondaryTextDark, fontWeight: FontWeight.w500),
      hintStyle: TextStyle(color: tertiaryTextDark.withValues(alpha: 0.5)),
    ),

    // ── Elevated Buttons ──
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),

    // ── Outlined Buttons ──
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: accentLight,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2),
        side: BorderSide(color: accentColor.withValues(alpha: 0.3), width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),

    // ── Bottom Sheet ──
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      modalBarrierColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),

    // ── Snackbar ──
    snackBarTheme: SnackBarThemeData(
      backgroundColor: cardHighDark,
      contentTextStyle: const TextStyle(color: primaryTextDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),

    // ── Divider ──
    dividerTheme: DividerThemeData(
      color: primaryTextDark.withValues(alpha: 0.06),
      thickness: 1,
    ),
  );

  // ── Shared decorations ──
  static BoxDecoration get glassDecoration => BoxDecoration(
    color: glassDark.withValues(alpha: 0.7),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: primaryTextDark.withValues(alpha: 0.06),
      width: 1,
    ),
  );

  static BoxDecoration get cardDecoration => BoxDecoration(
    color: cardDark,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: primaryTextDark.withValues(alpha: 0.04),
      width: 1,
    ),
  );

  static List<BoxShadow> get glowShadow => [
    BoxShadow(
      color: glowColor.withValues(alpha: 0.15),
      blurRadius: 24,
      spreadRadius: -4,
    ),
  ];
}
