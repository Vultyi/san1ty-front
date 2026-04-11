import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/models/support_models.dart';
import 'package:estrutura_front_san1ty/widgets/support_sidebar.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';
import 'package:estrutura_front_san1ty/widgets/support_badge.dart';

class SupportHistoryScreen extends StatefulWidget {
  static const String routeName = '/support-history';

  const SupportHistoryScreen({super.key});

  @override
  State<SupportHistoryScreen> createState() => _SupportHistoryScreenState();
}

class _SupportHistoryScreenState extends State<SupportHistoryScreen> {
  String _currentRoute = '/support-history';
  late List<AttendanceRecordSupport> _records;

  @override
  void initState() {
    super.initState();
    _records = [
      AttendanceRecordSupport(
        id: '1',
        userName: 'João Silva',
        issue: 'Problema com depósito',
        date: '2026-01-04 14:30',
        duration: '12 min',
        status: 'Resolvido',
        rating: 5.0,
      ),
      AttendanceRecordSupport(
        id: '2',
        userName: 'Maria Santos',
        issue: 'Dúvida sobre PIX',
        date: '2026-01-04 13:15',
        duration: '8 min',
        status: 'Resolvido',
        rating: 4.5,
      ),
      AttendanceRecordSupport(
        id: '3',
        userName: 'Pedro Costa',
        issue: 'Erro na verificação',
        date: '2026-01-04 11:45',
        duration: '15 min',
        status: 'Resolvido',
        rating: 4.0,
      ),
      AttendanceRecordSupport(
        id: '4',
        userName: 'Ana Paula',
        issue: 'Senha esquecida',
        date: '2026-01-03 16:20',
        duration: '5 min',
        status: 'Resolvido',
        rating: 5.0,
      ),
    ];
  }

  void _handleNavigation(String route) {
    setState(() => _currentRoute = route);
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/support-login');
  }

  @override
  Widget build(BuildContext context) {
    final totalAtendimentos = _records.length;
    final resolvidos = _records.length;
    final mediaAvaliacao =
        _records.where((r) => r.rating != null).fold<double>(0, (a, b) => a + (b.rating ?? 0)) /
            _records.where((r) => r.rating != null).length;

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Histórico de Atendimentos',
                        style: SupportTypography.heading2xl.copyWith(
                          color: SupportColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Consulte seus atendimentos anteriores',
                        style: SupportTypography.bodySm.copyWith(
                          color: SupportColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estatísticas
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                'Total de Atendimentos',
                                totalAtendimentos.toString(),
                                null,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildStatCard(
                                'Taxa de Resolução',
                                '${((resolvidos / totalAtendimentos) * 100).toStringAsFixed(1)}%',
                                null,
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: _buildStatCard(
                                'Avaliação Média',
                                mediaAvaliacao.toStringAsFixed(1),
                                '★',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Atendimentos Realizados
                        SupportCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atendimentos Realizados',
                                style: SupportTypography.headingXl.copyWith(
                                  color: SupportColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ..._records.map((record) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: _buildHistoryItem(record),
                                );
                              }),
                            ],
                          ),
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

  Widget _buildStatCard(String label, String value, String? subtitle) {
    return SupportCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: SupportTypography.bodySm.copyWith(
              color: SupportColors.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: SupportTypography.heading2xl.copyWith(
                  color: label.contains('Avaliação')
                      ? SupportColors.statusWarning
                      : SupportColors.brandPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(width: 4),
                Text(
                  subtitle,
                  style: SupportTypography.bodyBase.copyWith(
                    color: SupportColors.statusWarning,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(AttendanceRecordSupport record) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportColors.bgTertiary,
        borderRadius: SupportBorderRadius.radiusLg,
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Usuário e Status
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        record.userName,
                        style: SupportTypography.bodyBase.copyWith(
                          fontWeight: FontWeight.w500,
                          color: SupportColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SupportBadge(
                      text: record.status,
                      variant: SupportBadgeVariant.success,
                    ),
                  ],
                ),
              ),
              // Data e Duração
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    record.date,
                    style: SupportTypography.bodyXs.copyWith(
                      color: SupportColors.textDisabled,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Duração: ${record.duration}',
                    style: SupportTypography.bodyXs.copyWith(
                      color: SupportColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Issue
          Text(
            record.issue,
            style: SupportTypography.bodySm.copyWith(
              color: SupportColors.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          // Divider
          Container(
            height: 1,
            color: SupportColors.borderSecondary,
          ),
          const SizedBox(height: 12),
          // Avaliação
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Avaliação do usuário:',
                style: SupportTypography.bodyXs.copyWith(
                  color: SupportColors.textDisabled,
                ),
              ),
              _buildRating(record.rating),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRating(double? rating) {
    if (rating == null) {
      return Text(
        'Sem avaliação',
        style: SupportTypography.bodyXs.copyWith(
          color: SupportColors.textDisabled,
        ),
      );
    }

    return Row(
      children: [
        ...List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 4),
            child: Icon(
              index < rating ? Icons.star : Icons.star_border,
              size: SupportDimensions.iconSm,
              color: index < rating
                  ? SupportColors.statusWarning
                  : SupportColors.textDisabled,
            ),
          );
        }),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: SupportTypography.bodySm.copyWith(
            color: SupportColors.textTertiary,
          ),
        ),
      ],
    );
  }
}
