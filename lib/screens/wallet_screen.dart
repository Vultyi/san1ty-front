import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/core/security/device_security_service.dart';

class WalletScreen extends StatefulWidget {
  static const String routeName = '/wallet';

  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen>
    with TickerProviderStateMixin {
  bool _showBalance = true;
  late AnimationController _balanceAnimationController;
  late Animation<double> _balanceAnimation;

  @override
  void initState() {
    super.initState();
    DeviceSecurityService().secureScreenOn();
    _balanceAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _balanceAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _balanceAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    DeviceSecurityService().secureScreenOff();
    _balanceAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Carteira'),
        actions: [
          IconButton(
            icon: Icon(_showBalance ? Icons.visibility : Icons.visibility_off),
            onPressed: _toggleBalanceVisibility,
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.screenPadding,
          children: [
            const SizedBox(height: Dimensions.space24),
            _buildBalanceCard(),
            const SizedBox(height: Dimensions.space24),
            _buildQuickActions(),
            const SizedBox(height: Dimensions.space24),
            _buildRecentTransactions(),
            const SizedBox(height: Dimensions.space24),
            _buildWalletOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius20),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Saldo disponível',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              IconButton(
                icon: Icon(
                  _showBalance ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: _toggleBalanceVisibility,
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space8),
          AnimatedBuilder(
            animation: _balanceAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _showBalance ? 1.0 : _balanceAnimation.value,
                child: Text(
                  _showBalance ? 'R\$ 1.356,98' : '••••••',
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: Dimensions.space16),
          Row(
            children: [
              _buildBalanceInfo('Bloqueado', 'R\$ 0,00'),
              const SizedBox(width: Dimensions.space16),
              _buildBalanceInfo('Pendente', 'R\$ 45,50'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceInfo(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: Colors.white60),
            ),
            const SizedBox(height: Dimensions.space4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Ações rápidas', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.add,
                label: 'Depositar',
                color: AppColors.successGreen,
                onTap: () {
                  // Navigate to deposit
                },
              ),
            ),
            const SizedBox(width: Dimensions.space12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.arrow_upward,
                label: 'Transferir',
                color: AppColors.actionPrimary,
                onTap: () {
                  // Navigate to transfer
                },
              ),
            ),
            const SizedBox(width: Dimensions.space12),
            Expanded(
              child: _buildActionButton(
                icon: Icons.qr_code,
                label: 'PIX',
                color: AppColors.pixGreen,
                onTap: () {
                  // Navigate to PIX
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Color.alphaBlend(
                  color.withOpacity(0.1),
                  AppColors.backgroundSecondary,
                ),
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: Dimensions.space8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Movimentações recentes', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () {
                // Navigate to full statement
              },
              child: const Text(
                'Ver todas',
                style: TextStyle(color: AppColors.actionPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.space16),
        _buildTransactionItem(
          icon: Icons.arrow_downward,
          title: 'Recebimento PIX',
          subtitle: 'João Silva',
          amount: '+R\$ 50,00',
          color: AppColors.successGreen,
          time: 'Hoje, 14:30',
        ),
        const SizedBox(height: Dimensions.space12),
        _buildTransactionItem(
          icon: Icons.arrow_upward,
          title: 'Transferência',
          subtitle: 'Para conta poupança',
          amount: '-R\$ 200,00',
          color: AppColors.errorRed,
          time: 'Ontem, 10:30',
        ),
        const SizedBox(height: Dimensions.space12),
        _buildTransactionItem(
          icon: Icons.arrow_downward,
          title: 'Recebimento PIX',
          subtitle: 'Maria Santos',
          amount: '+R\$ 89,90',
          color: AppColors.successGreen,
          time: 'Ontem, 18:45',
        ),
      ],
    );
  }

  Widget _buildTransactionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String amount,
    required Color color,
    required String time,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color.alphaBlend(
                color.withOpacity(0.1),
                AppColors.backgroundSecondary,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: Dimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(subtitle, style: AppTextStyles.bodySmall),
                Text(time, style: AppTextStyles.caption),
              ],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Opções da carteira', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        _buildOptionItem(
          icon: Icons.credit_card,
          title: 'Cartões',
          subtitle: 'Gerenciar cartões cadastrados',
          onTap: () {
            // Navigate to cards
          },
        ),
        const SizedBox(height: Dimensions.space12),
        _buildOptionItem(
          icon: Icons.security,
          title: 'Segurança',
          subtitle: 'Configurações de segurança',
          onTap: () {
            // Navigate to security
          },
        ),
        const SizedBox(height: Dimensions.space12),
        _buildOptionItem(
          icon: Icons.settings,
          title: 'Configurações',
          subtitle: 'Preferências da carteira',
          onTap: () {
            // Navigate to settings
          },
        ),
      ],
    );
  }

  Widget _buildOptionItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0x1A007AFF),
                borderRadius: BorderRadius.circular(Dimensions.radius12),
              ),
              child: Icon(icon, color: AppColors.actionPrimary, size: 24),
            ),
            const SizedBox(width: Dimensions.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyMedium),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  void _toggleBalanceVisibility() {
    setState(() {
      _showBalance = !_showBalance;
    });
    if (_showBalance) {
      _balanceAnimationController.reverse();
    } else {
      _balanceAnimationController.forward();
    }
  }
}
