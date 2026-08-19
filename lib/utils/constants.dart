import 'package:flutter/material.dart';

// Figma-Inspired Finance Palette
class AppColors {
  // Primary brand color from Figma ("Main Green")
  static const Color mainGreen = Color(0xFF0F9D58); // Sharp, trustworthy green
  
  // Dark accents ("Dark Mode Green Black")
  static const Color darkAccent = Color(0xFF132018); 
  
  // Backgrounds ("Light Green" and clean whites)
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color lightGreenSurface = Color(0xFFF1F8F4); // Very soft green for inputs/cards
  static const Color white = Colors.white;
  
  // Text colors ("Letters and Icons")
  static const Color textDark = Color(0xFF1B1B1B);
  static const Color textLight = Color(0xFF8B958E);
  
  // Borders
  static const Color borderGrey = Color(0xFFE5E7EB);
}

// Minimalist Typography from Figma
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );
  
  static const TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
  );
  
  static const TextStyle bodyText = TextStyle(
    fontSize: 14,
    color: AppColors.textDark,
  );
  
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );
}
