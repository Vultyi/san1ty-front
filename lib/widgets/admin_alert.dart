import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

enum AdminAlertType {
  success,
  warning,
  info,
  error,
}

class AdminAlert extends StatelessWidget {
  final String title;
  final String message;
  final AdminAlertType type;
  final Widget? icon;
  final List<String>? details;

  const AdminAlert({
    super.key,
    required this.title,
    required this.message,
    this.type = AdminAlertType.info,
    this.icon,
    this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AdminDimensions.spacingBase),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border.all(
          color: _getBorderColor(),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon ?? _getDefaultIcon(),
          SizedBox(width: AdminDimensions.spacingBase),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AdminTextStyles.bodyBase.copyWith(
                    fontWeight: AdminTypography.fontWeightSemiBold,
                    color: _getTextColor(),
                  ),
                ),
                SizedBox(height: AdminDimensions.spacingXS),
                Text(
                  message,
                  style: AdminTextStyles.bodySmall.copyWith(
                    color: AdminColors.textSecondary,
                  ),
                ),
                if (details != null && details!.isNotEmpty) ...[
                  SizedBox(height: AdminDimensions.spacingSM),
                  ...details!.map((detail) => Padding(
                    padding: EdgeInsets.only(bottom: AdminDimensions.spacingXS),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '• ',
                          style: AdminTextStyles.bodySmall.copyWith(
                            color: AdminColors.textSecondary,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            detail,
                            style: AdminTextStyles.bodySmall.copyWith(
                              color: AdminColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case AdminAlertType.success:
        return AdminColors.statusGreen10;
      case AdminAlertType.warning:
        return AdminColors.statusYellow10;
      case AdminAlertType.info:
        return AdminColors.accentCyan10;
      case AdminAlertType.error:
        return AdminColors.statusRed10;
    }
  }

  Color _getBorderColor() {
    switch (type) {
      case AdminAlertType.success:
        return AdminColors.statusGreen30;
      case AdminAlertType.warning:
        return AdminColors.statusYellow30;
      case AdminAlertType.info:
        return AdminColors.accentCyan30;
      case AdminAlertType.error:
        return AdminColors.statusRed30;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case AdminAlertType.success:
        return AdminColors.statusGreen;
      case AdminAlertType.warning:
        return AdminColors.statusYellow;
      case AdminAlertType.info:
        return AdminColors.accentCyan;
      case AdminAlertType.error:
        return AdminColors.statusRed;
    }
  }

  Widget _getDefaultIcon() {
    switch (type) {
      case AdminAlertType.success:
        return Icon(
          Icons.check_circle,
          color: AdminColors.statusGreen,
          size: 20,
        );
      case AdminAlertType.warning:
        return Icon(
          Icons.warning_amber,
          color: AdminColors.statusYellow,
          size: 20,
        );
      case AdminAlertType.info:
        return Icon(
          Icons.info_outline,
          color: AdminColors.accentCyan,
          size: 20,
        );
      case AdminAlertType.error:
        return Icon(
          Icons.error,
          color: AdminColors.statusRed,
          size: 20,
        );
    }
  }
}