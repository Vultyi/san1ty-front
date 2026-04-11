import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';

class SupportSidebar extends StatelessWidget {
  final String attendantName;
  final String currentRoute;
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const SupportSidebar({
    super.key,
    required this.attendantName,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SupportDimensions.sidebarWidth,
      color: SupportColors.bgSecondary,
      child: Column(
        children: [
          // Header com Logo e Avatar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: SupportColors.borderPrimary,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // Logo
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: SupportColors.brandGradient,
                    borderRadius: SupportBorderRadius.radiusLg,
                  ),
                  child: const Center(
                    child: Text(
                      'S1',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Avatar e Nome
                Row(
                  children: [
                    SupportAvatar(
                      initials: attendantName.substring(0, 2).toUpperCase(),
                      size: SupportDimensions.avatarBase,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            attendantName,
                            style: SupportTypography.bodySm.copyWith(
                              fontWeight: FontWeight.w500,
                              color: SupportColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Atendente',
                            style: SupportTypography.bodyXs.copyWith(
                              color: SupportColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Menu Items
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildMenuItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Dashboard',
                    route: '/support-dashboard',
                    isActive: currentRoute == '/support-dashboard',
                    onTap: () => onNavigate('/support-dashboard'),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.help_outline,
                    label: 'Suporte Pré-Login',
                    route: '/pre-login-support',
                    isActive: currentRoute == '/pre-login-support',
                    onTap: () => onNavigate('/pre-login-support'),
                    badge: 'NOVO',
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.chat_bubble_outline,
                    label: 'Chats de Suporte',
                    route: '/support-chats',
                    isActive: currentRoute == '/support-chats',
                    onTap: () => onNavigate('/support-chats'),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.verified_user_outlined,
                    label: 'Aprovação de Contas',
                    route: '/support-approval',
                    isActive: currentRoute == '/support-approval',
                    onTap: () => onNavigate('/support-approval'),
                  ),
                  const SizedBox(height: 8),
                  _buildMenuItem(
                    icon: Icons.history,
                    label: 'Histórico',
                    route: '/support-history',
                    isActive: currentRoute == '/support-history',
                    onTap: () => onNavigate('/support-history'),
                  ),
                ],
              ),
            ),
          ),
          // Logout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: SupportColors.borderPrimary,
                  width: 1,
                ),
              ),
            ),
            child: InkWell(
              onTap: onLogout,
              borderRadius: SupportBorderRadius.radiusLg,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      size: SupportDimensions.iconBase,
                      color: SupportColors.textTertiary,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Logout',
                      style: SupportTypography.bodySm.copyWith(
                        fontWeight: FontWeight.w500,
                        color: SupportColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    required VoidCallback onTap,
    String? badge,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: SupportBorderRadius.radiusLg,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? SupportColors.brandPrimary : Colors.transparent,
          borderRadius: SupportBorderRadius.radiusLg,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: SupportDimensions.iconBase,
              color: isActive ? Colors.white : SupportColors.textTertiary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: SupportTypography.bodySm.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : SupportColors.textTertiary,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: SupportColors.statusPurple,
                  borderRadius: SupportBorderRadius.radiusFull,
                ),
                child: Text(
                  badge,
                  style: SupportTypography.bodyXs.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
