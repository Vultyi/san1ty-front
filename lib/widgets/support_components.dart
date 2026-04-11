import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';

class SupportCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool hasBorder;
  final VoidCallback? onTap;

  const SupportCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.hasBorder = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      padding: padding ?? SupportSpacing.paddingBase,
      decoration: BoxDecoration(
        color: backgroundColor ?? SupportColors.bgSecondary,
        borderRadius: SupportBorderRadius.radiusLg,
        border: hasBorder
            ? Border.all(color: SupportColors.borderPrimary, width: 1)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: SupportBorderRadius.radiusLg,
        child: widget,
      );
    }

    return widget;
  }
}

class SupportAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;

  const SupportAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.size = SupportDimensions.avatarBase,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? SupportColors.brandPrimary,
        borderRadius: BorderRadius.circular(size / 2),
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null
          ? Center(
              child: Text(
                initials,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: size * 0.4,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );
  }
}

class SupportInput extends StatelessWidget {
  final String? label;
  final String? placeholder;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final bool multiline;

  const SupportInput({
    super.key,
    this.label,
    this.placeholder,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.multiline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: SupportTypography.labelBase.copyWith(
              color: SupportColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          height: multiline ? null : SupportDimensions.inputHeightBase,
          decoration: BoxDecoration(
            color: SupportColors.bgTertiary,
            borderRadius: SupportBorderRadius.radiusLg,
            border: Border.all(
              color: SupportColors.borderSecondary,
              width: 1,
            ),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText && !multiline,
            keyboardType: keyboardType,
            validator: validator,
            enabled: enabled,
            maxLines: multiline ? null : 1,
            expands: multiline,
            style: SupportTypography.bodyBase.copyWith(
              color: SupportColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: SupportTypography.bodyBase.copyWith(
                color: SupportColors.textQuaternary,
              ),
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: SupportBorderRadius.radiusLg,
                borderSide: const BorderSide(
                  color: SupportColors.borderFocus,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SupportEmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final Color? iconColor;

  const SupportEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: iconColor ?? SupportColors.textDisabled,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: SupportTypography.bodyBase.copyWith(
              color: SupportColors.textDisabled,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class SupportLoadingSpinner extends StatelessWidget {
  final double size;
  final Color? color;

  const SupportLoadingSpinner({
    super.key,
    this.size = 40.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          color: color ?? SupportColors.brandPrimary,
        ),
      ),
    );
  }
}

class SupportSeparator extends StatelessWidget {
  final bool vertical;
  final double? height;
  final double? width;

  const SupportSeparator({
    super.key,
    this.vertical = false,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return Container(
        width: 1,
        height: height,
        color: SupportColors.borderPrimary,
      );
    }

    return Container(
      height: 1,
      width: width,
      color: SupportColors.borderPrimary,
    );
  }
}
