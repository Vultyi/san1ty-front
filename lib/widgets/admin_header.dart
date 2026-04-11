// lib/widgets/admin_header.dart
import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

class AdminHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onMenuPressed;

  const AdminHeader({
    super.key,
    required this.title,
    this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AdminDimensions.headerHeight,
      padding: EdgeInsets.symmetric(
        horizontal: AdminDimensions.spacingBase,
        vertical: AdminDimensions.spacingBase,
      ),
      decoration: BoxDecoration(
        color: AdminColors.bgPrimary,
        border: Border(bottom: AdminBorders.primary),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo com gradiente
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: AdminColors.brandGradient,
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
            ),
            child: Center(
              child: Text(
                'S1',
                style: AdminTextStyles.buttonSmall.copyWith(
                  fontWeight: AdminTypography.fontWeightBlack,
                  color: AdminColors.textPrimary,
                ),
              ),
            ),
          ),
          // Título
          Text(
            title,
            style: AdminTextStyles.headingBase,
          ),
          // Botão Menu
          IconButton(
            icon: Icon(
              Icons.menu,
              color: AdminColors.textPrimary,
              size: 24,
            ),
            onPressed: onMenuPressed,
            style: IconButton.styleFrom(
              backgroundColor: AdminColors.bgSecondary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusSM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}