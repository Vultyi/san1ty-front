import 'package:flutter/material.dart';

class SupportColors {
  // ===== BACKGROUNDS =====
  static const Color bgPrimary = Color(0xFF09090B);
  static const Color bgSecondary = Color(0xFF18181B);
  static const Color bgTertiary = Color(0xFF27272A);
  static const Color bgQuaternary = Color(0xFF3F3F46);

  // ===== TEXT COLORS =====
  static const Color textPrimary = Color(0xFFFAFAFA);
  static const Color textSecondary = Color(0xFFF4F4F5);
  static const Color textTertiary = Color(0xFFA1A1AA);
  static const Color textQuaternary = Color(0xFF71717A);
  static const Color textDisabled = Color(0xFF52525B);
  static const Color textLabel = Color(0xFF71717A);

  // ===== BRAND COLORS =====
  static const Color brandPrimary = Color(0xFF10B981);
  static const Color brandSecondary = Color(0xFF14B8A6);
  static const Color brandDark = Color(0xFF059669);
  static const Color brandLight = Color(0xFF34D399);

  // ===== STATUS COLORS =====
  static const Color statusSuccess = Color(0xFF10B981);
  static const Color statusInfo = Color(0xFF3B82F6);
  static const Color statusWarning = Color(0xFFF59E0B);
  static const Color statusError = Color(0xFFEF4444);
  static const Color statusPurple = Color(0xFF8B5CF6);

  // ===== CHAT STATUS =====
  static const Color chatNew = Color(0xFF3B82F6);
  static const Color chatActive = Color(0xFF10B981);
  static const Color chatClosed = Color(0xFF71717A);
  static const Color chatPreLogin = Color(0xFF8B5CF6);

  // ===== GRADIENTS =====
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF14B8A6)],
  );

  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
  );

  // ===== OPACITY VARIANTS =====
  static final Color emeraldBg10 = brandPrimary.withAlpha((0.10 * 255).round());
  static final Color blueBg10 = statusInfo.withAlpha((0.10 * 255).round());
  static final Color amberBg10 = statusWarning.withAlpha((0.10 * 255).round());
  static final Color redBg10 = statusError.withAlpha((0.10 * 255).round());
  static final Color purpleBg10 = statusPurple.withAlpha((0.10 * 255).round());

  // ===== BORDERS =====
  static const Color borderPrimary = Color(0xFF27272A);
  static const Color borderSecondary = Color(0xFF3F3F46);
  static const Color borderFocus = Color(0xFF10B981);
}

class PreLoginColors {
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryLight = Color(0xFFA78BFA);
  static const Color primaryDark = Color(0xFF7C3AED);
  static final Color bg10 = primary.withAlpha((0.10 * 255).round());
}
