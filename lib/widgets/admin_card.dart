import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';

class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? backgroundColor;
  final bool hasBorder;
  final VoidCallback? onTap;
  final double? borderRadius;

  const AdminCard({
    super.key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.hasBorder = true,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? EdgeInsets.all(AdminDimensions.spacingBase),
        decoration: BoxDecoration(
          color: backgroundColor ?? AdminColors.bgSecondary,
          border: hasBorder ? Border.all(
            color: AdminColors.borderPrimary,
            width: 1,
          ) : null,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AdminDimensions.borderRadiusBase,
          ),
        ),
        child: child,
      ),
    );
  }
}