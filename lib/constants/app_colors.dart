import 'package:flutter/material.dart';

// Centralized color palette for the entire application
class AppColors {
  // Primary color scheme
  static const Color primaryBlue = Color(0xFF2196F3); // Main blue
  static const Color secondaryBlue = Color(0xFF64B5F6); // Lighter blue
  static const Color darkBlue = Color(0xFF1565C0); // Dark blue for text/accents
  static const Color lightBlue = Color(
    0xFFE3F2FD,
  ); // Very light blue for backgrounds

  // Accent / Status Colors
  static const Color accentOrange = Color(
    0xFFFF9800,
  ); // A bright orange for accents
  static const Color accentTeal = Color(0xFF009688); // A teal for variety
  static const Color accentPurple = Color(
    0xFF9C27B0,
  ); // A purple for highlights
  static const Color danger = Color(0xFFF44336); // A red for errors or warnings
  static const Color success = Color(0xFF4CAF50); // A green for success states

  // Additional colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Opacity variants
  static Color primaryWithOpacity(double opacity) =>
      primaryBlue.withOpacity(opacity);
  static Color darkBlueWithOpacity(double opacity) =>
      darkBlue.withOpacity(opacity);
  static Color whiteWithOpacity(double opacity) => white.withOpacity(opacity);
  static Color blackWithOpacity(double opacity) => black.withOpacity(opacity);
}
