import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

bool isTestMode = false;

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.deepPurple,
        primary: Colors.deepPurple,
        secondary: Colors.amber,
        surface: Colors.white,
        background: const Color(0xFFF8F9FA),
      ),
      textTheme: isTestMode ? const TextTheme() : GoogleFonts.outfitTextTheme(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: isTestMode
            ? const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)
            : GoogleFonts.outfit(
                color: Colors.black87,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),
    );
  }
}
