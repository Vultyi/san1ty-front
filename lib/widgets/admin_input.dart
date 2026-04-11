// lib/widgets/admin_input.dart
import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

class AdminInput extends StatelessWidget {
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
  final int? maxLines;

  const AdminInput({
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
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: AdminTextStyles.labelLarge,
          ),
          SizedBox(height: AdminDimensions.spacingXS),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          enabled: enabled,
          maxLines: multiline ? (maxLines ?? 3) : 1,
          style: AdminTextStyles.bodyBase.copyWith(
            color: AdminColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: AdminTextStyles.bodyBase.copyWith(
              color: AdminColors.textTertiary,
            ),
            filled: true,
            fillColor: AdminColors.bgSecondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              borderSide: AdminBorders.primary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              borderSide: AdminBorders.primary,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              borderSide: AdminBorders.accent,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              borderSide: BorderSide(color: AdminColors.statusRed, width: 1),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
              borderSide: BorderSide(color: AdminColors.statusRed, width: 1),
            ),
            contentPadding: EdgeInsets.all(AdminDimensions.spacingBase),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}