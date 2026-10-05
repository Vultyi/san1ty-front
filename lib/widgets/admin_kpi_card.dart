import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import 'admin_card.dart';

class AdminKpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? subtitle;

  const AdminKpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.all(AdminDimensions.spacingBase),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusSM),
            ),
            child: Icon(
              icon,
              size: 16,
              color: iconColor,
            ),
          ),
          SizedBox(height: AdminDimensions.spacingXS),
          Text(
            value,
            style: AdminTextStyles.headingLarge,
          ),
          Text(
            title,
            style: AdminTextStyles.labelBase.copyWith(
              color: AdminColors.textSecondary,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: AdminDimensions.spacingXS),
            Text(
              subtitle!,
              style: AdminTextStyles.bodySmall.copyWith(
                color: AdminColors.textTertiary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}