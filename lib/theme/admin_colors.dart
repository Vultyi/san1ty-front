// lib/theme/admin_colors.dart
import 'package:flutter/material.dart';

class AdminColors {
  // Background Colors
  static const Color bgPrimary = Color(0xFF0A0A0A);    // #0a0a0a
  static const Color bgSecondary = Color(0xFF111111);  // #111111
  static const Color bgTertiary = Color(0xFF1A1A1A);   // #1a1a1a

  // Border Colors
  static const Color borderPrimary = Color(0xFF222222);    // #222222
  static const Color borderSecondary = Color(0xFF333333);  // #333333

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);      // #ffffff
  static const Color textSecondary = Color(0xFF9CA3AF);    // #9ca3af
  static const Color textTertiary = Color(0xFF6B7280);     // #6b7280

  // Accent Colors - Cyan/Blue (Primary)
  static const Color accentCyan = Color(0xFF06B6D4);       // #06b6d4 (cyan-500)
  static const Color accentCyanDark = Color(0xFF0891B2);   // #0891b2 (cyan-600)
  static const Color accentBlue = Color(0xFF2563EB);       // #2563eb (blue-600)
  static const Color accentBlueDark = Color(0xFF1D4ED8);   // #1d4ed8 (blue-700)

  // Status Colors
  static const Color statusGreen = Color(0xFF4ADE80);      // #4ade80 (green-400)
  static const Color statusYellow = Color(0xFFFBBF24);     // #fbbf24 (yellow-400)
  static const Color statusRed = Color(0xFFEF4444);        // #ef4444 (red-500)
  static const Color statusPurple = Color(0xFFA855F7);     // #a855f7 (purple-500)
  static const Color statusOrange = Color(0xFFF97316);     // #f97316 (orange-500)
  static const Color statusPink = Color(0xFFEC4899);       // #ec4899 (pink-500)

  // Gradients
  static const LinearGradient brandGradient = LinearGradient(
    colors: [accentCyan, accentBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Opacity variants
  static Color accentCyan10 = accentCyan.withOpacity(0.1);
  static Color accentCyan20 = accentCyan.withOpacity(0.2);
  static Color accentCyan30 = accentCyan.withOpacity(0.3);

  static Color statusGreen10 = statusGreen.withOpacity(0.1);
  static Color statusGreen30 = statusGreen.withOpacity(0.3);

  static Color statusYellow10 = statusYellow.withOpacity(0.1);
  static Color statusYellow30 = statusYellow.withOpacity(0.3);

  static Color statusRed10 = statusRed.withOpacity(0.1);
  static Color statusRed30 = statusRed.withOpacity(0.3);
}