import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';

enum SupportButtonSize { sm, base, lg }
enum SupportButtonVariant { primary, secondary, outline, ghost, destructive }

class SupportButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final SupportButtonSize size;
  final SupportButtonVariant variant;
  final Widget? icon;
  final bool fullWidth;
  final bool loading;

  const SupportButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = SupportButtonSize.base,
    this.variant = SupportButtonVariant.primary,
    this.icon,
    this.fullWidth = false,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    final double height = _getHeight();
    final EdgeInsets padding = _getPadding();
    final TextStyle textStyle = _getTextStyle();

    final Color bgColor = _getBackgroundColor();
    final Color textColor = _getTextColor();
    final Color? borderColor = _getBorderColor();

    return SizedBox(
      height: height,
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: textColor,
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: SupportBorderRadius.radiusLg,
            side: borderColor != null
                ? BorderSide(color: borderColor, width: 1)
                : BorderSide.none,
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        ),
        child: loading
            ? SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: textColor,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    icon!,
                    SizedBox(width: size == SupportButtonSize.sm ? 4 : 8),
                  ],
                  Text(text, style: textStyle),
                ],
              ),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case SupportButtonSize.sm:
        return SupportDimensions.buttonHeightSm;
      case SupportButtonSize.base:
        return SupportDimensions.buttonHeightBase;
      case SupportButtonSize.lg:
        return SupportDimensions.buttonHeightLg;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case SupportButtonSize.sm:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case SupportButtonSize.base:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case SupportButtonSize.lg:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case SupportButtonSize.sm:
        return SupportTypography.buttonSm;
      case SupportButtonSize.base:
        return SupportTypography.buttonBase;
      case SupportButtonSize.lg:
        return SupportTypography.buttonLg;
    }
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case SupportButtonVariant.primary:
        return SupportColors.brandPrimary;
      case SupportButtonVariant.secondary:
        return SupportColors.bgTertiary;
      case SupportButtonVariant.outline:
        return Colors.transparent;
      case SupportButtonVariant.ghost:
        return Colors.transparent;
      case SupportButtonVariant.destructive:
        return SupportColors.statusError;
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case SupportButtonVariant.primary:
      case SupportButtonVariant.destructive:
        return Colors.white;
      case SupportButtonVariant.secondary:
      case SupportButtonVariant.outline:
      case SupportButtonVariant.ghost:
        return SupportColors.textSecondary;
    }
  }

  Color? _getBorderColor() {
    switch (variant) {
      case SupportButtonVariant.outline:
        return SupportColors.borderPrimary;
      default:
        return null;
    }
  }
}
