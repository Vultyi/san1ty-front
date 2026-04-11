import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/models/support_models.dart';
import 'package:estrutura_front_san1ty/widgets/support_sidebar.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';
import 'package:estrutura_front_san1ty/widgets/support_badge.dart';
import 'package:estrutura_front_san1ty/widgets/support_button.dart';

class SupportApprovalScreen extends StatefulWidget {
  static const String routeName = '/support-approval';

  const SupportApprovalScreen({super.key});

  @override
  State<SupportApprovalScreen> createState() => _SupportApprovalScreenState();
}

class _SupportApprovalScreenState extends State<SupportApprovalScreen> {
  String _currentRoute = '/support-approval';
  late List<PendingAccountSupport> _pendingAccounts;

  @override
  void initState() {
    super.initState();
    _pendingAccounts = [
      PendingAccountSupport(
        id: '1',
        userName: 'Carlos Eduardo Silva',
        email: 'carlos@email.com',
        userId: 'USR001',
        document: 'CPF: 123.456.789-00',
        requestDate: '2026-01-04 10:30',
        status: 'pendente',
      ),
      PendingAccountSupport(
        id: '2',
        userName: 'Ana Paula Costa',
        email: 'ana@email.com',
        userId: 'USR002',
        document: 'CPF: 987.654.321-00',
        requestDate: '2026-01-04 11:15',
        status: 'pendente',
      ),
      PendingAccountSupport(
        id: '3',
        userName: 'Bruno Rodrigues',
        email: 'bruno@email.com',
        userId: 'USR003',
        document: 'CPF: 555.666.777-00',
        requestDate: '2026-01-04 14:20',
        status: 'pendente',
      ),
    ];
  }

  void _handleNavigation(String route) {
    setState(() => _currentRoute = route);
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/support-login');
  }

  void _handleApprove(PendingAccountSupport account) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conta de ${account.userName} aprovada!'),
        backgroundColor: SupportColors.statusSuccess,
      ),
    );
    setState(() => _pendingAccounts.remove(account));
  }

  void _handleReject(PendingAccountSupport account) {
    showDialog(
      context: context,
      builder: (context) => _buildRejectDialog(account),
    );
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Aprovação de Contas',
                        style: SupportTypography.heading2xl.copyWith(
                          color: SupportColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Gerencie solicitações de abertura de conta',
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
                        // Contas Pendentes Card
                        SupportCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Contas Pendentes',
                                    style: SupportTypography.heading2xl.copyWith(
                                      color: SupportColors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: SupportColors.amberBg10,
                                      borderRadius:
                                          SupportBorderRadius.radiusFull,
                                    ),
                                    child: Text(
                                      '${_pendingAccounts.length}',
                                      style:
                                          SupportTypography.labelBase.copyWith(
                                        color: SupportColors.statusWarning,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              ..._pendingAccounts.map((account) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _buildAccountCard(account),
                                );
                              }),
                              if (_pendingAccounts.isEmpty)
                                SupportEmptyState(
                                  icon: Icons.check_circle_outline,
                                  message:
                                      'Nenhuma conta pendente de aprovação',
                                ),
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

  Widget _buildAccountCard(PendingAccountSupport account) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportColors.bgTertiary,
        borderRadius: SupportBorderRadius.radiusLg,
      ),
      child: Row(
        children: [
          // Informações
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nome e User ID
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        account.userName,
                        style: SupportTypography.bodyBase.copyWith(
                          fontWeight: FontWeight.w500,
                          color: SupportColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SupportBadge(
                      text: account.userId,
                      variant: SupportBadgeVariant.defaultBadge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Grid de Informações
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn('Email', account.email),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'Data da solicitação',
                        account.requestDate,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoColumn('Documento', account.document),
                    ),
                    Expanded(
                      child: _buildInfoColumn(
                        'Status',
                        '',
                        badge: SupportBadge(
                          text: 'Pendente',
                          variant: SupportBadgeVariant.warning,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Botões
          Column(
            children: [
              SupportButton(
                text: 'Visualizar',
                onPressed: () => _showDetailsDialog(account),
                size: SupportButtonSize.sm,
                variant: SupportButtonVariant.outline,
                icon: Icon(
                  Icons.visibility_outlined,
                  size: SupportDimensions.iconSm,
                ),
              ),
              const SizedBox(height: 8),
              SupportButton(
                text: 'Aprovar',
                onPressed: () => _handleApprove(account),
                size: SupportButtonSize.sm,
                variant: SupportButtonVariant.primary,
                icon: Icon(
                  Icons.check,
                  size: SupportDimensions.iconSm,
                ),
              ),
              const SizedBox(height: 8),
              SupportButton(
                text: 'Reprovar',
                onPressed: () => _handleReject(account),
                size: SupportButtonSize.sm,
                variant: SupportButtonVariant.destructive,
                icon: Icon(
                  Icons.close,
                  size: SupportDimensions.iconSm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {Widget? badge}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: SupportTypography.bodySm.copyWith(
            color: SupportColors.textDisabled,
          ),
        ),
        const SizedBox(height: 4),
        badge ??
            Text(
              value,
              style: SupportTypography.bodySm.copyWith(
                color: SupportColors.textSecondary,
              ),
            ),
      ],
    );
  }

  void _showDetailsDialog(PendingAccountSupport account) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: SupportColors.bgSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: SupportBorderRadius.radiusLg,
          side: const BorderSide(
            color: SupportColors.borderPrimary,
            width: 1,
          ),
        ),
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes da Conta',
                style: SupportTypography.headingXl.copyWith(
                  color: SupportColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('Nome Completo', account.userName),
              _buildDetailRow('Email', account.email),
              _buildDetailRow('ID do Usuário', account.userId),
              _buildDetailRow('Documento', account.document),
              _buildDetailRow('Data da Solicitação', account.requestDate),
              _buildDetailRow(
                'Status',
                '',
                badge: SupportBadge(
                  text: 'Pendente',
                  variant: SupportBadgeVariant.warning,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: SupportButton(
                  text: 'Fechar',
                  onPressed: () => Navigator.of(context).pop(),
                  size: SupportButtonSize.base,
                  variant: SupportButtonVariant.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Widget? badge}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: SupportTypography.bodySm.copyWith(
              color: SupportColors.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          badge ??
              Text(
                value,
                style: SupportTypography.bodyBase.copyWith(
                  color: SupportColors.textPrimary,
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildRejectDialog(PendingAccountSupport account) {
    final messageController = TextEditingController();

    return Dialog(
      backgroundColor: SupportColors.bgSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: SupportBorderRadius.radiusLg,
        side: const BorderSide(
          color: SupportColors.borderPrimary,
          width: 1,
        ),
      ),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reprovar Conta',
              style: SupportTypography.headingXl.copyWith(
                color: SupportColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Usuário',
              style: SupportTypography.bodySm.copyWith(
                color: SupportColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              account.userName,
              style: SupportTypography.bodyBase.copyWith(
                color: SupportColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Mensagem para o usuário *',
              style: SupportTypography.labelBase.copyWith(
                color: SupportColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: 120,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: SupportColors.bgTertiary,
                borderRadius: SupportBorderRadius.radiusLg,
                border: Border.all(
                  color: SupportColors.borderSecondary,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: messageController,
                maxLines: null,
                expands: true,
                style: SupportTypography.bodyBase.copyWith(
                  color: SupportColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Explique o motivo da reprovação...',
                  hintStyle: SupportTypography.bodyBase.copyWith(
                    color: SupportColors.textQuaternary,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Esta mensagem será enviada ao usuário',
              style: SupportTypography.bodyXs.copyWith(
                color: SupportColors.textDisabled,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SupportButton(
                  text: 'Cancelar',
                  onPressed: () => Navigator.of(context).pop(),
                  size: SupportButtonSize.base,
                  variant: SupportButtonVariant.outline,
                ),
                const SizedBox(width: 12),
                SupportButton(
                  text: 'Confirmar Reprovação',
                  onPressed: () {
                    if (messageController.text.trim().isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Conta de ${account.userName} reprovada!',
                          ),
                          backgroundColor: SupportColors.statusError,
                        ),
                      );
                      setState(() => _pendingAccounts.remove(account));
                      Navigator.of(context).pop();
                    }
                  },
                  size: SupportButtonSize.base,
                  variant: SupportButtonVariant.destructive,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
