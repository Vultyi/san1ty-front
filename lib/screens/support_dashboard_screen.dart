import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/widgets/support_sidebar.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';

class SupportMetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String? subtitle;

  const SupportMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SupportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: SupportTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SupportColors.textTertiary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: SupportBorderRadius.radiusLg,
                ),
                child: Icon(
                  icon,
                  size: SupportDimensions.iconBase,
                  color: iconColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: SupportTypography.heading3xl.copyWith(
                  color: SupportColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 8),
                Text(
                  subtitle!,
                  style: SupportTypography.bodySm.copyWith(
                    color: SupportColors.textTertiary,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class SupportDashboardScreen extends StatefulWidget {
  static const String routeName = '/support-dashboard';

  const SupportDashboardScreen({super.key});

  @override
  State<SupportDashboardScreen> createState() => _SupportDashboardScreenState();
}

class _SupportDashboardScreenState extends State<SupportDashboardScreen> {
  String _currentRoute = '/support-dashboard';

  void _handleNavigation(String route) {
    setState(() => _currentRoute = route);
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/support-login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportColors.bgPrimary,
      body: Row(
        children: [
          // Sidebar
          SupportSidebar(
            attendantName: 'Carlos Silva',
            currentRoute: _currentRoute,
            onNavigate: _handleNavigation,
            onLogout: _handleLogout,
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: SupportColors.bgSecondary,
                    border: Border(
                      bottom: BorderSide(
                        color: SupportColors.borderPrimary,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dashboard',
                            style: SupportTypography.heading2xl.copyWith(
                              color: SupportColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Visão geral dos seus atendimentos',
                            style: SupportTypography.bodySm.copyWith(
                              color: SupportColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                      // Perfil
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Carlos Silva',
                                style: SupportTypography.bodySm.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: SupportColors.textPrimary,
                                ),
                              ),
                              Text(
                                'Atendente',
                                style: SupportTypography.bodyXs.copyWith(
                                  color: SupportColors.textTertiary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          SupportAvatar(
                            initials: 'CS',
                            size: SupportDimensions.avatarBase,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        // Métrica Cards - 3 colunas
                        Row(
                          children: [
                            Expanded(
                              child: SupportMetricCard(
                                title: 'Total de Atendimentos',
                                value: '742',
                                icon: Icons.chat_bubble_outline,
                                iconColor: SupportColors.statusInfo,
                                iconBgColor: SupportColors.blueBg10,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: SupportMetricCard(
                                title: 'Resolvidos',
                                value: '716',
                                subtitle: '(96.5%)',
                                icon: Icons.check_circle_outline,
                                iconColor: SupportColors.statusSuccess,
                                iconBgColor: SupportColors.emeraldBg10,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: SupportMetricCard(
                                title: 'Avaliação Média',
                                value: '4.8',
                                subtitle: '★',
                                icon: Icons.star_outline,
                                iconColor: SupportColors.statusWarning,
                                iconBgColor: SupportColors.amberBg10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Atendimentos Recentes
                        Row(
                          children: [
                            Expanded(
                              child: SupportCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Atendimentos Recentes',
                                      style:
                                          SupportTypography.headingXl.copyWith(
                                        color: SupportColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildRecentTicket(
                                      'João Silva',
                                      'Problema com depósito',
                                      '2 min atrás',
                                      'resolved',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildRecentTicket(
                                      'Maria Santos',
                                      'Dúvida sobre PIX',
                                      '15 min atrás',
                                      'active',
                                    ),
                                    const SizedBox(height: 12),
                                    _buildRecentTicket(
                                      'Pedro Costa',
                                      'Erro na verificação',
                                      '1 hora atrás',
                                      'resolved',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: SupportCard(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Métricas do Mês',
                                      style:
                                          SupportTypography.headingXl.copyWith(
                                        color: SupportColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    _buildMetricRow(
                                      'Tempo Médio de Resposta',
                                      '2 min 15 seg',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildMetricRow(
                                      'Taxa de Satisfação',
                                      '94.2%',
                                    ),
                                    const SizedBox(height: 16),
                                    _buildMetricRow(
                                      'Atendimentos Hoje',
                                      '23',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTicket(
    String name,
    String issue,
    String time,
    String status,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: SupportColors.bgTertiary,
        borderRadius: SupportBorderRadius.radiusLg,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: SupportTypography.bodySm.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SupportColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  issue,
                  style: SupportTypography.bodyXs.copyWith(
                    color: SupportColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: SupportTypography.bodyXs.copyWith(
                  color: SupportColors.textDisabled,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == 'resolved'
                      ? SupportColors.emeraldBg10
                      : SupportColors.blueBg10,
                  borderRadius: SupportBorderRadius.radiusFull,
                ),
                child: Text(
                  status == 'resolved' ? 'Resolvido' : 'Em atendimento',
                  style: SupportTypography.labelSm.copyWith(
                    color: status == 'resolved'
                        ? SupportColors.statusSuccess
                        : SupportColors.statusInfo,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: SupportTypography.bodySm.copyWith(
            color: SupportColors.textTertiary,
          ),
        ),
        Text(
          value,
          style: SupportTypography.bodyBase.copyWith(
            fontWeight: FontWeight.w600,
            color: SupportColors.brandPrimary,
          ),
        ),
      ],
    );
  }
}
