import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1400), _goToDashboard);
  }

  void _goToDashboard() {
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: Dimensions.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.shield_outlined, size: 72, color: AppColors.blueLight),
              const SizedBox(height: Dimensions.space24),
              Text('San1ty Pay', style: AppTextStyles.logoStyle.copyWith(fontSize: 34)),
              const SizedBox(height: Dimensions.space12),
              Text(
                'Bem-vindo ao seu painel financeiro digital',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const SizedBox(height: Dimensions.space24),
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueLight),
                ),
              ),
              const SizedBox(height: Dimensions.space16),
              Text('Carregando o dashboard...', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
