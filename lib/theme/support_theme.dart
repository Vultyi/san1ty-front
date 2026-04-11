import 'package:flutter/material.dart';

class SupportTypography {
  // ===== DISPLAY (Grandes) =====
  static const TextStyle display3xl = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  );

  static const TextStyle display2xl = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.02,
  );

  // ===== HEADING =====
  static const TextStyle heading3xl = TextStyle(
    fontSize: 30.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.01,
  );

  static const TextStyle heading2xl = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.01,
  );

  static const TextStyle headingXl = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle headingLg = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ===== BODY =====
  static const TextStyle bodyLg = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyBase = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const TextStyle bodyXs = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ===== LABEL =====
  static const TextStyle labelLg = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelBase = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  static const TextStyle labelSm = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w500,
    height: 1.4,
  );

  // ===== BUTTON =====
  static const TextStyle buttonLg = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle buttonBase = TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  static const TextStyle buttonSm = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );
}

class SupportDimensions {
  // ===== SIDEBAR =====
  static const double sidebarWidth = 256.0;
  static const double sidebarWidthCollapsed = 64.0;

  // ===== CHAT LIST =====
  static const double chatListWidth = 320.0;

  // ===== BUTTONS =====
  static const double buttonHeightSm = 32.0;
  static const double buttonHeightBase = 40.0;
  static const double buttonHeightLg = 48.0;

  // ===== INPUTS =====
  static const double inputHeightSm = 32.0;
  static const double inputHeightBase = 40.0;
  static const double inputHeightLg = 48.0;

  // ===== AVATAR =====
  static const double avatarSm = 32.0;
  static const double avatarBase = 40.0;
  static const double avatarLg = 48.0;
  static const double avatarXl = 64.0;

  // ===== ICON =====
  static const double iconXs = 12.0;
  static const double iconSm = 16.0;
  static const double iconBase = 20.0;
  static const double iconLg = 24.0;
  static const double iconXl = 32.0;

  // ===== BADGE =====
  static const double badgeHeight = 24.0;

  // ===== CARD =====
  static const double cardMinHeight = 120.0;

  // ===== LOGO =====
  static const double logoSize = 48.0;
  static const double logoSizeSm = 64.0;
}

class SupportSpacing {
  // Base: 4px
  static const double unit = 4.0;

  static const double none = 0.0;
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double base = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xl2 = 32.0;
  static const double xl3 = 40.0;
  static const double xl4 = 48.0;
  static const double xl5 = 64.0;
  static const double xl6 = 80.0;
  static const double xl7 = 96.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(4.0);
  static const EdgeInsets paddingSm = EdgeInsets.all(8.0);
  static const EdgeInsets paddingMd = EdgeInsets.all(12.0);
  static const EdgeInsets paddingBase = EdgeInsets.all(16.0);
  static const EdgeInsets paddingLg = EdgeInsets.all(20.0);
  static const EdgeInsets paddingXl = EdgeInsets.all(24.0);
  static const EdgeInsets padding2xl = EdgeInsets.all(32.0);
}

class SupportBorderRadius {
  static const double none = 0.0;
  static const double sm = 4.0;
  static const double base = 6.0;
  static const double md = 8.0;
  static const double lg = 10.0;
  static const double xl = 12.0;
  static const double xl2 = 16.0;
  static const double xl3 = 24.0;
  static const double full = 9999.0;

  static final BorderRadius radiusSm = BorderRadius.circular(sm);
  static final BorderRadius radiusBase = BorderRadius.circular(base);
  static final BorderRadius radiusMd = BorderRadius.circular(md);
  static final BorderRadius radiusLg = BorderRadius.circular(lg);
  static final BorderRadius radiusXl = BorderRadius.circular(xl);
  static final BorderRadius radius2xl = BorderRadius.circular(xl2);
  static final BorderRadius radiusFull = BorderRadius.circular(full);
}

class SupportShadows {
  static const List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Color.fromARGB(13, 0, 0, 0),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const List<BoxShadow> shadow2 = [
    BoxShadow(
      color: Color.fromARGB(26, 0, 0, 0),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Color.fromARGB(38, 0, 0, 0),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> shadow4 = [
    BoxShadow(
      color: Color.fromARGB(51, 0, 0, 0),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color.fromARGB(26, 0, 0, 0),
      blurRadius: 10,
      offset: Offset(0, 4),
    ),
  ];
}

class SupportBreakpoints {
  static const double mobile = 640;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double wide = 1280;
  static const double ultraWide = 1536;
}

class SupportAnimationDurations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 200);
  static const Duration slow = Duration(milliseconds: 300);
}
