import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    const primaryGreen = Color(0xFF768C4A);
    const accentYellow = Color(0xFFDBB86A);
    const earthyBrown = Color(0xFF8C6239);

    return ThemeData(
      scaffoldBackgroundColor: accentYellow,
      colorScheme: const ColorScheme.light(
        primary: primaryGreen,
        secondary: earthyBrown,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: earthyBrown,
        centerTitle: true,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
