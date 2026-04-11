import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/commerce_intro_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_home_screen.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/screens/statement_screen.dart';
import 'package:estrutura_front_san1ty/screens/wallet_screen.dart';

class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'San1ty',
    'QR Code',
    'Vendas',
    'Saques',
    'Assistente',
  ];

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
        const SizedBox(height: Dimensions.space20),
        _buildHeader(),
        const SizedBox(height: Dimensions.space24),
        _buildProfileCard(),
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _IconButton(icon: Icons.menu, onTap: () {}),
        Text(_titles[_selectedIndex], style: AppTextStyles.logoStyle),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius18),
      ),
      padding: Dimensions.cardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.brandPrimary, width: 2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(Icons.person, color: AppColors.textPrimary, size: 32),
              ),
              const SizedBox(width: Dimensions.space16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Olá,', style: AppTextStyles.bodySmall),
                  SizedBox(height: Dimensions.space4),
                  Text('Carlos Eduardo Silva', style: AppTextStyles.heading3),
                ],
              ),
              const Spacer(),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary,
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: const Icon(Icons.remove_red_eye_outlined, color: AppColors.actionPrimary, size: 20),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space20),
          const Text('Conta', style: AppTextStyles.bodySmall),
          const SizedBox(height: Dimensions.space4),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, WalletScreen.routeName),
            child: Row(
              children: [
                const Text('R\$ 1.356,98', style: AppTextStyles.heading1),
                const SizedBox(width: Dimensions.space8),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: AppTextStyles.heading3);
  }

  Widget _buildQuickActionsGrid(BuildContext context) {
    final items = [
      _ActionItem(label: 'PIX', icon: Icons.qr_code, iconColor: AppColors.pixGreen, valueColor: AppColors.pixGreen, subtitle: 'Em breve', onTap: () {
        Navigator.pushNamed(context, PixHomeScreen.routeName);
      }),
      _ActionItem(label: 'Vendas', icon: Icons.shopping_bag, iconColor: AppColors.actionPrimary, valueColor: AppColors.actionPrimary, onTap: () {
        Navigator.pushNamed(context, SalesScreen.routeName);
      }),
      _ActionItem(label: 'Histórico', icon: Icons.bar_chart, iconColor: AppColors.brandPrimary, valueColor: AppColors.brandPrimary, onTap: () {
        Navigator.pushNamed(context, StatementScreen.routeName);
      }),
      _ActionItem(label: 'Comércio', icon: Icons.storefront, iconColor: AppColors.actionPrimary, valueColor: AppColors.actionPrimary, onTap: () {
        Navigator.pushNamed(context, CommerceIntroScreen.routeName);
      }),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: Dimensions.space12,
      mainAxisSpacing: Dimensions.space12,
      childAspectRatio: 1,
      children: items.map((item) => _buildQuickActionCard(context, item)).toList(),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, _ActionItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundPrimary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0x1A007AFF),
                borderRadius: BorderRadius.circular(Dimensions.radius16),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 24),
            ),
            const SizedBox(height: Dimensions.space8),
            Text(item.label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppColors.textPrimary), textAlign: TextAlign.center),
            if (item.subtitle != null) ...[
              const SizedBox(height: Dimensions.space4),
              Text(item.subtitle!, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary), textAlign: TextAlign.center),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildMetricCard(
          title: 'Meus ganhos',
          value: 'R\$ 245,50',
          icon: Icons.trending_up,
          iconColor: AppColors.actionPrimary,
          valueColor: AppColors.successGreen,
          subtitle: '+15% vs ontem',
        )),
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
    required Color valueColor,
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
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0x1A007AFF),
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: Dimensions.space12),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: Dimensions.space16),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.successGreen, fontFamily: 'monospace')),
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
          const Text('Resumo', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
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
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
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
          const Text('Meta do mês', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: Dimensions.space12),
          const Text('R\$ 1.245,50', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: Dimensions.space8),
          const Text('72% da meta alcançada', style: TextStyle(fontSize: 12, color: Color(0xFFB0CFFF))),
          const SizedBox(height: Dimensions.space16),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.backgroundPrimary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.72,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF007AFF), Color(0xFF2962FF)]),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
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
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Vendas'),
        BottomNavigationBarItem(icon: Icon(Icons.arrow_downward), label: 'Saques'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Assistente'),
      ],
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() => _selectedIndex = index);
        if (index == 2) { // Vendas
          Navigator.pushNamed(context, SalesScreen.routeName);
        } else if (index == 1) { // QR Code - could navigate to wallet or PIX
          Navigator.pushNamed(context, WalletScreen.routeName);
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
  final Color iconColor;
  final Color valueColor;
  final String? subtitle;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.label,
    required this.icon,
    required this.iconColor,
    required this.valueColor,
    this.subtitle,
    this.onTap,
  });
}
