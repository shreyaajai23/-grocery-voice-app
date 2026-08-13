import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// PantryTalk's visual identity: a warm, kitchen-inspired palette (terracotta
/// + sage + cream) paired with an editorial serif for headings and a clean
/// geometric sans for everything else — meant to feel like a well-loved
/// cookbook rather than a generic Material app.
class PantryTalkTheme {
  static const Color terracotta = Color(0xFFB5502F);
  static const Color terracottaDark = Color(0xFF8A3B21);
  static const Color peach = Color(0xFFF3D9C4);
  static const Color sage = Color(0xFF6B8F71);
  static const Color sagePale = Color(0xFFDCE8DA);
  static const Color cream = Color(0xFFFBF3EA);
  static const Color creamCard = Color(0xFFFFFDFA);
  static const Color ink = Color(0xFF3A2E27);

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: terracotta,
      brightness: Brightness.light,
    ).copyWith(
      primary: terracotta,
      onPrimary: Colors.white,
      primaryContainer: peach,
      onPrimaryContainer: terracottaDark,
      secondary: sage,
      onSecondary: Colors.white,
      secondaryContainer: sagePale,
      onSecondaryContainer: const Color(0xFF25381F),
      surface: creamCard,
      onSurface: ink,
      surfaceContainerHighest: sagePale,
      error: const Color(0xFFB3261E),
    );

    final baseText = GoogleFonts.manropeTextTheme();
    final headingFont = GoogleFonts.fraunces;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: cream,
      textTheme: baseText.copyWith(
        headlineLarge: headingFont(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        headlineMedium: headingFont(
          fontSize: 26,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleLarge: headingFont(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
        titleMedium: baseText.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: ink,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: cream,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: headingFont(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: ink,
        ),
      ),
      cardTheme: CardThemeData(
        color: creamCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: terracotta.withValues(alpha: 0.08)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: creamCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: terracotta.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: terracotta.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: terracotta, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: creamCard,
        indicatorColor: peach,
        elevation: 0,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: sagePale,
        labelStyle: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF25381F),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      ),
    );
  }
}
