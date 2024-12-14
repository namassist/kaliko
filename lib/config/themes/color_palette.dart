import 'package:flutter/material.dart';

class ColorPalette {
  // Primary Colors
  static const Color primaryColor = Color(0xFF3498db);
  static const Color accentColor = Color(0xFF2980b9);

  // Background Colors
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color darkBackgroundColor = Color(0xFF121212);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF333333);
  static const Color textSecondaryColor = Color(0xFF666666);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF1E88E5);
  static const Color darkTextSecondaryColor = Color(0xFFB0B0B0);
  static const Color darkCardColor = Color(0xFF1F1F1F);
  static const Color darkInputBackgroundColor = Color(0xFF2C2C2C);
  static const Color darkBorderColor = Color(0xFF3C3C3C);

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);

  // Utility Colors
  static const Color successColor = Color(0xFF2ecc71);
  static const Color errorColor = Color(0xFFe74c3c);
  static const Color warningColor = Color(0xFFf39c12);

  // Material Color Swatch for Primary Color
  static Map<int, Color> primaryColorSwatch = {
    50: const Color(0xFFE3F2FD),
    100: const Color(0xFFBBDEFB),
    200: const Color(0xFF90CAF9),
    300: const Color(0xFF64B5F6),
    400: const Color(0xFF42A5F5),
    500: primaryColor,
    600: const Color(0xFF1E88E5),
    700: const Color(0xFF1976D2),
    800: const Color(0xFF1565C0),
    900: const Color(0xFF0D47A1),
  };
}
