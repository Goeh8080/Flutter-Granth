import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppThemeMode { light, dark, liquid }

class AppColors {
  static const saffron = Color(0xFFE8821A);
  static const saffronDark = Color(0xFFC06A10);
  static const maroon = Color(0xFF7B1F2E);
  static const gold = Color(0xFFC9A84C);
  static const goldLight = Color(0xFFE2C97E);
  static const cream = Color(0xFFFDF6E3);
  static const creamDark = Color(0xFFF5E6C8);
  static const brown = Color(0xFF4A2C0A);
  static const text = Color(0xFF3D1F00);
  static const muted = Color(0xFF8B6A4A);
  static const white = Color(0xFFFFFDF7);

  // Liquid (frosted-glass) palette — deep gradient behind translucent cards
  static const liquidBgTop = Color(0xFF1B0E2E);
  static const liquidBgBottom = Color(0xFF3A123B);
  static const liquidAccent = Color(0xFFE8821A);
}

class AppGradients {
  static const header = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.maroon, AppColors.brown],
  );

  static const liquidBackground = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.liquidBgTop, AppColors.liquidBgBottom],
  );
}

class AppTheme {
  static TextStyle display({double size = 20, Color? color, FontWeight? weight}) =>
      GoogleFonts.yatraOne(fontSize: size, color: color, fontWeight: weight);

  static TextStyle body({double size = 14, Color? color, FontWeight? weight}) =>
      GoogleFonts.dmSans(fontSize: size, color: color, fontWeight: weight);

  static ThemeData light() {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.cream,
      colorScheme: base.colorScheme.copyWith(primary: AppColors.saffron, secondary: AppColors.gold),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.brown,
        foregroundColor: AppColors.goldLight,
        titleTextStyle: GoogleFonts.yatraOne(fontSize: 20, color: AppColors.goldLight),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.dark);
    return base.copyWith(
      scaffoldBackgroundColor: const Color(0xFF161018),
      colorScheme: base.colorScheme.copyWith(primary: AppColors.saffron, secondary: AppColors.gold),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).apply(bodyColor: Colors.white70),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF221626),
        foregroundColor: AppColors.goldLight,
        titleTextStyle: GoogleFonts.yatraOne(fontSize: 20, color: AppColors.goldLight),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF241A28),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A1E2F),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// "Liquid glass" — same structure as dark mode (so all normal widgets
  /// still work), but screens should wrap content in [LiquidBackdrop] +
  /// [GlassCard] to get the frosted look on top of it.
  static ThemeData liquid() {
    final d = dark();
    return d.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      cardTheme: d.cardTheme.copyWith(color: Colors.white.withValues(alpha: 0.08)),
    );
  }

  static ThemeData of(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return light();
      case AppThemeMode.dark:
        return dark();
      case AppThemeMode.liquid:
        return liquid();
    }
  }
}
