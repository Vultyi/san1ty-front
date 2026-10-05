import 'package:flutter/material.dart';
import 'admin_colors.dart';

class AdminDimensions {
  // Avatar sizes
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarBase = 40.0;
  static const double avatarLG = 48.0;
  static const double avatarXL = 56.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingBase = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacing2XL = 48.0;

  // Border radius
  static const double borderRadiusSM = 8.0;
  static const double borderRadiusBase = 12.0;
  static const double borderRadiusLG = 16.0;
  static const double borderRadiusXL = 24.0;

  // Heights
  static const double headerHeight = 80.0;
  static const double bottomNavHeight = 80.0;
  static const double buttonHeightSM = 40.0;
  static const double buttonHeightBase = 48.0;
  static const double buttonHeightLG = 56.0;

  // Sidebar
  static const double sidebarWidth = 280.0;

  // Card dimensions
  static const double kpiCardHeight = 80.0;
  static const double memberCardHeight = 140.0;
}

class AdminTypography {
  // Font weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemiBold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightBlack = FontWeight.w900;

  // Font sizes
  static const double fontSizeXS = 12.0;
  static const double fontSizeSM = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLG = 18.0;
  static const double fontSizeXL = 20.0;
  static const double fontSize2XL = 24.0;

  // Line heights
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.625;
}

class AdminTextStyles {
  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: AdminTypography.fontSize2XL,
    fontWeight: AdminTypography.fontWeightBlack,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  // Heading styles
  static const TextStyle headingLarge = TextStyle(
    fontSize: AdminTypography.fontSizeXL,
    fontWeight: AdminTypography.fontWeightBlack,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle headingBase = TextStyle(
    fontSize: AdminTypography.fontSizeLG,
    fontWeight: AdminTypography.fontWeightBlack,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: AdminTypography.fontSizeBase,
    fontWeight: AdminTypography.fontWeightBold,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AdminTypography.fontSizeBase,
    fontWeight: AdminTypography.fontWeightRegular,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightRelaxed,
  );

  static const TextStyle bodyBase = TextStyle(
    fontSize: AdminTypography.fontSizeSM,
    fontWeight: AdminTypography.fontWeightRegular,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightRelaxed,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AdminTypography.fontSizeXS,
    fontWeight: AdminTypography.fontWeightRegular,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightRelaxed,
  );

  // Label styles
  static const TextStyle labelLarge = TextStyle(
    fontSize: AdminTypography.fontSizeSM,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.textSecondary,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle labelBase = TextStyle(
    fontSize: AdminTypography.fontSizeXS,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.textSecondary,
    height: AdminTypography.lineHeightNormal,
    letterSpacing: 1.2,
  );

  // Button styles
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AdminTypography.fontSizeLG,
    fontWeight: AdminTypography.fontWeightBlack,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle buttonBase = TextStyle(
    fontSize: AdminTypography.fontSizeBase,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: AdminTypography.fontSizeSM,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.textPrimary,
    height: AdminTypography.lineHeightNormal,
  );

  // Status styles
  static const TextStyle statusOnline = TextStyle(
    fontSize: AdminTypography.fontSizeXS,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.statusGreen,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle statusAway = TextStyle(
    fontSize: AdminTypography.fontSizeXS,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.statusYellow,
    height: AdminTypography.lineHeightNormal,
  );

  static const TextStyle statusOffline = TextStyle(
    fontSize: AdminTypography.fontSizeXS,
    fontWeight: AdminTypography.fontWeightSemiBold,
    color: AdminColors.textSecondary,
    height: AdminTypography.lineHeightNormal,
  );
}

class AdminShadows {
  static const BoxShadow cardShadow = BoxShadow(
    color: Colors.black26,
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const BoxShadow modalShadow = BoxShadow(
    color: Colors.black38,
    blurRadius: 16,
    offset: Offset(0, 4),
  );
}

class AdminBorders {
  static const BorderSide primary = BorderSide(
    color: AdminColors.borderPrimary,
    width: 1,
  );

  static const BorderSide secondary = BorderSide(
    color: AdminColors.borderSecondary,
    width: 1,
  );

  static const BorderSide accent = BorderSide(
    color: AdminColors.accentCyan,
    width: 1,
  );
}