import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';

TextStyle _inter(double size, FontWeight weight, Color color) =>
    GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color);

/// Central de notificações (estado vazio honesto até o push chegar).
class NotificationsScreen extends StatelessWidget {
  static const String routeName = '/notifications';

  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(Icons.arrow_back_ios_new_outlined,
                        size: 24, color: AppColors.textPrimary),
                  ),
                ),
                const SizedBox(width: 8),
                Text('Notificações',
                    style: _inter(20, FontWeight.w600, AppColors.textPrimary)),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      border: Border.all(color: AppColors.borderDefault),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.notifications_outlined,
                        size: 40, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  Text('Nada por aqui',
                      style: _inter(17, FontWeight.w600, AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Pagamentos e novidades aparecem aqui.',
                      style: _inter(14, FontWeight.w400, AppColors.textSecondary),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
