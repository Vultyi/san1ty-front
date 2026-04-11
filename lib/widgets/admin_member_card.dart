// lib/widgets/admin_member_card.dart
import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import '../models/admin_models.dart';
import 'admin_card.dart';

class AdminMemberCard extends StatelessWidget {
  final SupportMember member;
  final VoidCallback? onTap;

  const AdminMemberCard({
    super.key,
    required this.member,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      padding: EdgeInsets.all(AdminDimensions.spacingBase),
      onTap: onTap,
      child: Column(
        children: [
          // Header do Card
          Row(
            children: [
              // Avatar com status
              Stack(
                children: [
                  Container(
                    width: AdminDimensions.avatarLG,
                    height: AdminDimensions.avatarLG,
                    decoration: BoxDecoration(
                      gradient: AdminColors.brandGradient,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        member.avatar,
                        style: AdminTextStyles.buttonBase.copyWith(
                          color: AdminColors.textPrimary,
                          fontWeight: AdminTypography.fontWeightBlack,
                        ),
                      ),
                    ),
                  ),
                  // Status indicator
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: member.statusColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AdminColors.bgSecondary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: AdminDimensions.spacingBase),
              // Nome e Cargo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: AdminTextStyles.bodyBase.copyWith(
                        fontWeight: AdminTypography.fontWeightSemiBold,
                        color: AdminColors.textPrimary,
                      ),
                    ),
                    Text(
                      member.roleDisplay,
                      style: AdminTextStyles.labelBase.copyWith(
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Status e Botão
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _getStatusText(),
                    style: _getStatusStyle(),
                  ),
                  SizedBox(height: AdminDimensions.spacingXS),
                  TextButton(
                    onPressed: onTap,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.visibility,
                          size: 12,
                          color: AdminColors.accentCyan,
                        ),
                        SizedBox(width: AdminDimensions.spacingXS),
                        Text(
                          'Detalhes',
                          style: AdminTextStyles.labelBase.copyWith(
                            color: AdminColors.accentCyan,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AdminDimensions.spacingBase),
          // Divider
          Container(
            height: 1,
            color: AdminColors.borderPrimary,
          ),
          SizedBox(height: AdminDimensions.spacingBase),
          // Métricas Grid
          Row(
            children: [
              Expanded(
                child: _MetricItem(
                  label: 'Logado',
                  value: member.stats.loggedTime,
                  color: AdminColors.accentCyan,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Ativos',
                  value: member.stats.chatsActive.toString(),
                  color: AdminColors.statusYellow,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Resolvidos',
                  value: member.stats.chatsResolved.toString(),
                  color: AdminColors.statusGreen,
                ),
              ),
              Expanded(
                child: _MetricItem(
                  label: 'Satisfação',
                  value: '⭐ ${member.stats.satisfaction.toStringAsFixed(1)}',
                  color: AdminColors.statusPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (member.status) {
      case SupportStatus.online:
        return 'Online';
      case SupportStatus.away:
        return 'Ausente';
      case SupportStatus.offline:
        return 'Offline';
    }
  }

  TextStyle _getStatusStyle() {
    switch (member.status) {
      case SupportStatus.online:
        return AdminTextStyles.statusOnline;
      case SupportStatus.away:
        return AdminTextStyles.statusAway;
      case SupportStatus.offline:
        return AdminTextStyles.statusOffline;
    }
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MetricItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AdminTextStyles.labelBase.copyWith(
            color: AdminColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AdminTextStyles.bodySmall.copyWith(
            fontWeight: AdminTypography.fontWeightBlack,
            color: color,
          ),
        ),
      ],
    );
  }
}