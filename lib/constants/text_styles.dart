import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle logoStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.black,
    letterSpacing: 1.5,
    height: 1.2,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    height: 1.4,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.white,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textLabel,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLabel,
    height: 1.3,
  );

  static const TextStyle tiny = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textLabel,
    height: 1.2,
  );
}
