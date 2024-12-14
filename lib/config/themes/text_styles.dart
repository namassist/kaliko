import 'package:flutter/material.dart';
import 'color_palette.dart';

class AppTextStyles {
  // Headline Styles
  static TextStyle headline1 = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: ColorPalette.textPrimaryColor,
  );

  static TextStyle headline2 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: ColorPalette.textPrimaryColor,
  );

  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    color: ColorPalette.textSecondaryColor,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    color: ColorPalette.textSecondaryColor,
  );

  // Button Styles
  static TextStyle buttonText = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  // Movie Title Styles
  static TextStyle movieTitle = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ColorPalette.textPrimaryColor,
  );

  static TextStyle movieSubtitle = const TextStyle(
    fontSize: 14,
    color: ColorPalette.textSecondaryColor,
  );
}
