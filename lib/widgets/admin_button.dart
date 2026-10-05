import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

enum AdminButtonVariant {
  primary,
  secondary,
  outline,
  ghost,
}

enum AdminButtonSize {
  sm,
  base,
  lg,
}

class AdminButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AdminButtonSize size;
  final AdminButtonVariant variant;
  final Widget? icon;
  final bool fullWidth;
  final bool loading;

  const AdminButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AdminButtonSize.base,
    this.variant = AdminButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  double _getHeight() {
    switch (size) {
      case AdminButtonSize.sm:
        return AdminDimensions.buttonHeightSM;
      case AdminButtonSize.base:
        return AdminDimensions.buttonHeightBase;
      case AdminButtonSize.lg:
        return AdminDimensions.buttonHeightLG;
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AdminButtonSize.sm:
        return AdminTextStyles.buttonSmall;
      case AdminButtonSize.base:
        return AdminTextStyles.buttonBase;
      case AdminButtonSize.lg:
        return AdminTextStyles.buttonLarge;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final TextStyle textStyle = _getTextStyle();

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading) ...[
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                variant == AdminButtonVariant.primary
                    ? AdminColors.textPrimary
                    : AdminColors.accentCyan,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          icon!,
          const SizedBox(width: 8),
        ],
        Text(text, style: textStyle),
      ],
    );

    Widget button;

    switch (variant) {
      case AdminButtonVariant.primary:
        button = Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          decoration: BoxDecoration(
            gradient: AdminColors.brandGradient,
            borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
          ),
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == AdminButtonSize.sm ? AdminDimensions.spacingBase : AdminDimensions.spacingLG,
              ),
            ),
            child: buttonContent,
          ),
        );
        break;

      case AdminButtonVariant.secondary:
        button = Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: ElevatedButton(
            onPressed: loading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminColors.accentCyan20,
              foregroundColor: AdminColors.accentCyan,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == AdminButtonSize.sm ? AdminDimensions.spacingBase : AdminDimensions.spacingLG,
              ),
            ),
            child: buttonContent,
          ),
        );
        break;

      case AdminButtonVariant.outline:
        button = Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: OutlinedButton(
            onPressed: loading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              side: AdminBorders.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: size == AdminButtonSize.sm ? AdminDimensions.spacingBase : AdminDimensions.spacingLG,
              ),
            ),
            child: buttonContent,
          ),
        );
        break;

      case AdminButtonVariant.ghost:
        button = Container(
          width: fullWidth ? double.infinity : null,
          height: height,
          child: TextButton(
            onPressed: loading ? null : onPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: size == AdminButtonSize.sm ? AdminDimensions.spacingBase : AdminDimensions.spacingLG,
              ),
            ),
            child: buttonContent,
          ),
        );
        break;
    }

    return button;
  }
}