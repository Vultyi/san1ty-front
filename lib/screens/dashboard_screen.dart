import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/commerce_intro_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_home_screen.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/screens/statement_screen.dart';
import 'package:estrutura_front_san1ty/screens/wallet_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _balanceVisible = true;
  String _userName = 'Olá';

  static const List<String> _titles = [
    'San1ty',
    'Carteira',
    'PIX',
    'Vendas',
    'Histórico',
  ];

  @override
  void initState() {
    super.initState();
    AuthService().getCurrentUser().then((user) {
      if (!mounted || user == null) return;
      final full = (user['full_name'] ?? user['name'] ?? '') as String;
      final first = full.trim().split(RegExp(r'\s+')).firstWhere(
            (p) => p.isNotEmpty,
            orElse: () => '',
          );
      if (first.isNotEmpty && mounted) {
        setState(() => _userName = first);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: _selectedIndex == 0 ? _buildMainDashboard() : _buildPlaceholderScreen(_titles[_selectedIndex]),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildMainDashboard() {
    return ListView(
      padding: Dimensions.screenPadding,
      children: [
        const SizedBox(height: Dimensions.space16),
        _buildHeader(),
        const SizedBox(height: Dimensions.space20),
        _buildBalanceHero(),
        const SizedBox(height: Dimensions.space24),
        _buildSectionTitle('Ações rápidas'),
        const SizedBox(height: Dimensions.space16),
        _buildQuickActionsGrid(context),
        const SizedBox(height: Dimensions.space24),
        _buildOverviewCards(),
        const SizedBox(height: Dimensions.space24),
        _buildMonthlyGoalCard(),
        const SizedBox(height: Dimensions.space32),
      ],
    );
  }

  Widget _buildPlaceholderScreen(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: Dimensions.space16),
          Text(
            '$title\nEm breve!',
            style: AppTextStyles.heading2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.brandPrimary, AppColors.actionPrimary],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: Dimensions.space12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá,', style: AppTextStyles.bodySmall),
            Text(_userName, style: AppTextStyles.heading3),
          ],
        ),
        const Spacer(),
        _IconButton(
          icon: _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          onTap: () => setState(() => _balanceVisible = !_balanceVisible),
        ),
      ],
    );
  }

  Widget _buildBalanceHero() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, WalletScreen.routeName),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1D4ED8), Color(0xFF2962FF)],
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius18),
          boxShadow: const [AppColors.shadowBlue],
        ),
        padding: Dimensions.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Saldo em conta',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFFB0CFFF)),
                ),
                const Icon(Icons.account_balance_wallet_outlined, color: Colors.white70, size: 20),
              ],
            ),
            const SizedBox(height: Dimensions.space8),
            Text(
              _balanceVisible ? 'R\$ 1.356,98' : 'R\$ ••••••',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, height: 1.2),
            ),
            const SizedBox(height: Dimensions.space12),
            Row(
              children: [
                const Text(
                  'Ver carteira',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(width: Dimensions.space8),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final items = [
      _ActionItem(
        label: 'PIX',
        icon: Icons.pix_outlined,
        tint: AppColors.pixGreen,
        onTap: () => Navigator.pushNamed(context, PixHomeScreen.routeName),
      ),
      _ActionItem(
        label: 'Vendas',
        icon: Icons.shopping_bag_outlined,
        tint: AppColors.actionPrimary,
        onTap: () => Navigator.pushNamed(context, SalesScreen.routeName),
      ),
      _ActionItem(
        label: 'Histórico',
        icon: Icons.receipt_long_outlined,
        tint: AppColors.brandPrimary,
        onTap: () => Navigator.pushNamed(context, StatementScreen.routeName),
      ),
      _ActionItem(
        label: 'Comércio',
        icon: Icons.storefront_outlined,
        tint: AppColors.warningOrange,
        onTap: () => Navigator.pushNamed(context, CommerceIntroScreen.routeName),
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: Dimensions.space12,
      mainAxisSpacing: Dimensions.space12,
      childAspectRatio: 0.92,
      children: items.map(_buildQuickActionCard).toList(),
    );
  }

  Widget _buildQuickActionCard(_ActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: item.tint.withAlpha((0.14 * 255).round()),
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              child: Icon(item.icon, color: item.tint, size: 24),
            ),
            const SizedBox(height: Dimensions.space8),
            Text(
              item.label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Meus ganhos',
            value: 'R\$ 245,50',
            icon: Icons.trending_up,
            iconColor: AppColors.successGreen,
            subtitle: '+15% vs ontem',
          ),
        ),
        const SizedBox(width: Dimensions.space16),
        Expanded(child: _buildSummaryCard()),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: Dimensions.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withAlpha((0.14 * 255).round()),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: Dimensions.space16),
          Text(title, style: AppTextStyles.bodySmall),
          const SizedBox(height: Dimensions.space4),
          const Text('R\$ 245,50',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.successGreen)),
          const SizedBox(height: Dimensions.space8),
          Text(subtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.right),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: Dimensions.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Resumo',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
          const SizedBox(height: Dimensions.space16),
          _buildDataRow('Saldo disponível', 'R\$ 1.245,50'),
          const SizedBox(height: Dimensions.space12),
          _buildDataRow('Vendas hoje', '18'),
          const SizedBox(height: Dimensions.space12),
          _buildDataRow('Meta do mês', 'R\$ 5.000'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  Widget _buildMonthlyGoalCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2962FF), Color(0xFF007AFF)],
        ),
        borderRadius: BorderRadius.circular(Dimensions.radius18),
        boxShadow: const [AppColors.shadowBlue],
      ),
      padding: Dimensions.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Meta do mês',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: Dimensions.space12),
          const Text('R\$ 1.245,50',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: Dimensions.space8),
          const Text('72% da meta alcançada', style: TextStyle(fontSize: 12, color: Color(0xFFB0CFFF))),
          const SizedBox(height: Dimensions.space16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 8,
              backgroundColor: Color(0x40000000),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: Dimensions.space12),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('72%', style: TextStyle(fontSize: 12, color: Color(0xFFB0CFFF))),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: AppColors.backgroundPrimary,
      selectedItemColor: AppColors.actionPrimary,
      unselectedItemColor: AppColors.textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      iconSize: 22,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_outlined), label: 'Carteira'),
        BottomNavigationBarItem(icon: Icon(Icons.pix_outlined), label: 'PIX'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Vendas'),
        BottomNavigationBarItem(icon: Icon(Icons.receipt_long_outlined), label: 'Histórico'),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        if (index == 0) {
          setState(() => _selectedIndex = 0);
          return;
        }
        // Não troca o índice: telas abrem por cima e o voltar cai no Início.
        if (index == 1) {
          Navigator.pushNamed(context, WalletScreen.routeName);
        } else if (index == 2) {
          Navigator.pushNamed(context, PixHomeScreen.routeName);
        } else if (index == 3) {
          Navigator.pushNamed(context, SalesScreen.routeName);
        } else if (index == 4) {
          Navigator.pushNamed(context, StatementScreen.routeName);
        }
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 24),
      ),
    );
  }
}

class _ActionItem {
  final String label;
  final IconData icon;
  final Color tint;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.label,
    required this.icon,
    required this.tint,
    this.onTap,
  });
}
