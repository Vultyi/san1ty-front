// lib/constants/colors.dart

/// Central color palette for the San1ty Pay application.
///
/// All colors used across the app should reference this class to ensure
/// visual consistency and simplify future theme changes.
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color backgroundPrimary = Color(0xFF07090D);
  static const Color backgroundSecondary = Color(0xFF0D121A);
  static const Color backgroundTertiary = Color(0xFF131A26);

  static const Color textPrimary = Color(0xFFF5F7FA);
  static const Color textSecondary = Color(0xFF8B98AA);
  static const Color textTertiary = Color(0xFF5B6774);
  static const Color textLabel = Color(0xFF8B98AA);
  static const Color textPlaceholder = Color(0xFF5B6774);

  static const Color borderNormal = Color(0xFF1C2A3D);

  static const Color bluePrimary = Color(0xFF2F80ED);
  static const Color blueDark = Color(0xFF2F80ED);
  static const Color blueDarker = Color(0xFF1E40AF);
  static const Color blueDarkest = Color(0xFF1E3A8A);
  static const Color blueLight = Color(0xFF6EA8F2);
  static const Color blueLighter = Color(0xFF93C5FD);

  static const Color brandPrimary = Color(0xFF2F80ED);
  static const Color actionPrimary = Color(0xFF2F80ED);
  static const Color actionHover = Color(0xFF0066CC);

  static const Color successGreen = Color(0xFF35B86B);
  static const Color warningOrange = Color(0xFFFFA726);
  static const Color errorRed = Color(0xFFEF5350);
  static const Color pixGreen = Color(0xFF32BCAD);

  static const Color borderDefault = Color(0xFF1C2A3D);
  static const Color borderHover = Color(0xFF007AFF);
  static const Color borderActive = Color(0xFF2962FF);

  static const Color overlay10 = Color(0x1A007AFF);
  static const Color overlay20 = Color(0x33007AFF);
  static const Color overlay30 = Color(0x4D1C1C1E);

  static const BoxShadow shadowSmall = BoxShadow(
    color: Color(0x0A000000),
    offset: Offset(0, 2),
    blurRadius: 4,
    spreadRadius: 0,
  );

  static const BoxShadow shadowMedium = BoxShadow(
    color: Color(0x14000000),
    offset: Offset(0, 4),
    blurRadius: 8,
    spreadRadius: 0,
  );

  static const BoxShadow shadowLarge = BoxShadow(
    color: Color(0x1F000000),
    offset: Offset(0, 8),
    blurRadius: 16,
    spreadRadius: 0,
  );

  static const Color blueShadow = Color(0x4D1D4ED8);

  static const BoxShadow shadowBlue = BoxShadow(
    color: Color(0x33007AFF),
    offset: Offset(0, 4),
    blurRadius: 16,
    spreadRadius: 0,
  );
}
