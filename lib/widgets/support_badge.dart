import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';

enum SupportBadgeVariant {
  success,
  info,
  warning,
  error,
  purple,
  defaultBadge,
}

class SupportBadge extends StatelessWidget {
  final String text;
  final SupportBadgeVariant variant;

  const SupportBadge({
    super.key,
    required this.text,
    this.variant = SupportBadgeVariant.defaultBadge,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors['bg'],
        borderRadius: SupportBorderRadius.radiusFull,
      ),
      child: Text(
        text,
        style: SupportTypography.labelSm.copyWith(
          color: colors['text'],
        ),
      ),
    );
  }

  Map<String, Color> _getColors() {
    switch (variant) {
      case SupportBadgeVariant.success:
        return {
          'bg': SupportColors.emeraldBg10,
          'text': SupportColors.statusSuccess,
        };
      case SupportBadgeVariant.info:
        return {
          'bg': SupportColors.blueBg10,
          'text': SupportColors.statusInfo,
        };
      case SupportBadgeVariant.warning:
        return {
          'bg': SupportColors.amberBg10,
          'text': SupportColors.statusWarning,
        };
      case SupportBadgeVariant.error:
        return {
          'bg': SupportColors.redBg10,
          'text': SupportColors.statusError,
        };
      case SupportBadgeVariant.purple:
        return {
          'bg': PreLoginColors.bg10,
          'text': PreLoginColors.primary,
        };
      case SupportBadgeVariant.defaultBadge:
        return {
          'bg': SupportColors.bgTertiary,
          'text': SupportColors.textTertiary,
        };
    }
  }
}
