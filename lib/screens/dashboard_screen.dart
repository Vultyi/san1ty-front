import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/screens/login_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_home_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_manage_keys_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_pay_screen.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/screens/statement_screen.dart';
import 'package:estrutura_front_san1ty/screens/support_login_screen.dart';
import 'package:estrutura_front_san1ty/screens/wallet_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

/// Home bancária — spec 390x844, Inter, sem glow/sombras azuis.
class DashboardScreen extends StatefulWidget {
  static const String routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

TextStyle _inter(double size, FontWeight weight, Color color, {double height = 1.4}) {
  return GoogleFonts.inter(fontSize: size, fontWeight: weight, color: color, height: height);
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool _balanceVisible = true;
  String _userName = 'por aqui';

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

  void _soon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disponível em breve'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: _buildDrawer(context),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: 12),
            Builder(builder: (ctx) => _buildHeader(ctx)),
            const SizedBox(height: 20),
            _buildUserArea(),
            const SizedBox(height: 20),
            _buildBalanceCard(context),
            const SizedBox(height: 24),
            _buildShortcuts(context),
            const SizedBox(height: 24),
            _buildPerformanceCard(context),
            const SizedBox(height: 16),
            _buildGoalCard(),
            const SizedBox(height: 16),
            _buildTipCard(context),
            const SizedBox(height: 16),
            _buildSecurityCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  // Drawer lateral com destinos reais + sair.
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundSecondary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: AppColors.actionPrimary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                      style: _inter(18, FontWeight.w700, Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Olá, $_userName',
                            style: _inter(17, FontWeight.w600, AppColors.textPrimary)),
                        Text('Conta San1tyPay',
                            style: _inter(13, FontWeight.w400, AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.borderDefault, height: 1),
            _drawerItem(context, Icons.account_balance_wallet_outlined, 'Carteira',
                () => Navigator.pushNamed(context, WalletScreen.routeName)),
            _drawerItem(context, Icons.pix_outlined, 'PIX',
                () => Navigator.pushNamed(context, PixHomeScreen.routeName)),
            _drawerItem(context, Icons.key_outlined, 'Minhas chaves',
                () => Navigator.pushNamed(context, PixManageKeysScreen.routeName)),
            _drawerItem(context, Icons.shopping_bag_outlined, 'Vendas',
                () => Navigator.pushNamed(context, SalesScreen.routeName)),
            _drawerItem(context, Icons.support_agent_outlined, 'Suporte',
                () => Navigator.pushNamed(context, SupportLoginScreen.routeName)),
            const Spacer(),
            const Divider(color: AppColors.borderDefault, height: 1),
            _drawerItem(context, Icons.logout_outlined, 'Sair', () async {
              Navigator.of(context).pop();
              await AuthService().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.routeName, (_) => false);
              }
            }, danger: true),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String label, VoidCallback onTap,
      {bool danger = false}) {
    final color = danger ? AppColors.errorRed : AppColors.textPrimary;
    return ListTile(
      leading: Icon(icon, size: 24, color: danger ? color : AppColors.textSecondary),
      title: Text(label, style: _inter(15, FontWeight.w500, color)),
      onTap: onTap,
    );
  }

  // Header ~120px: menu 44px esq, sino 44px dir com ponto.
  Widget _buildHeader(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _tapBox(
            onTap: () => Scaffold.of(context).openDrawer(),
            child: const Icon(Icons.menu, size: 24, color: AppColors.textPrimary),
          ),
          _tapBox(
            onTap: () => _soon(context),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined, size: 24, color: AppColors.textPrimary),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.actionPrimary,
                      shape: BoxShape.circle,
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

  Widget _tapBox({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  // Avatar 64 + nome 20/600 + subtexto 14.
  Widget _buildUserArea() {
    return Row(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.actionPrimary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                _userName.isNotEmpty ? _userName[0].toUpperCase() : '?',
                style: _inter(24, FontWeight.w700, Colors.white),
              ),
            ),
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: AppColors.backgroundTertiary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.backgroundPrimary, width: 2),
                ),
                child: const Icon(Icons.photo_camera_outlined, size: 12, color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Olá, $_userName', style: _inter(20, FontWeight.w600, AppColors.textPrimary, height: 1.2)),
            const SizedBox(height: 4),
            Text('Que bom ter você por aqui.',
                style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          ],
        ),
      ],
    );
  }

  // Card saldo 150-165px, radius 18, padding 20.
  Widget _buildBalanceCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, WalletScreen.routeName),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Saldo em conta',
                    style: _inter(14, FontWeight.w500, AppColors.textSecondary)),
                GestureDetector(
                  onTap: () => setState(() => _balanceVisible = !_balanceVisible),
                  child: Icon(
                    _balanceVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    size: 24,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  _balanceVisible ? 'R\$ ••••••' : 'R\$ ••••••',
                  style: _inter(40, FontWeight.w700, AppColors.textPrimary, height: 1.1),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.chevron_right, size: 24, color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text('Seu dinheiro rende mais aqui',
                style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  // 4 atalhos: Pix / Vendas / Pagar conta / Em breve.
  Widget _buildShortcuts(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _shortcut(
            context,
            icon: Icons.pix_outlined,
            iconSize: 28,
            iconColor: AppColors.actionPrimary,
            title: 'Pix',
            subtitle: 'Enviar e receber',
            onTap: () => Navigator.pushNamed(context, PixHomeScreen.routeName),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            context,
            icon: Icons.shopping_bag_outlined,
            iconSize: 28,
            iconColor: AppColors.actionPrimary,
            title: 'Vendas',
            subtitle: 'Cobrar clientes',
            onTap: () => Navigator.pushNamed(context, SalesScreen.routeName),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            context,
            icon: Icons.barcode_reader,
            iconSize: 28,
            iconColor: AppColors.actionPrimary,
            title: 'Pagar conta',
            subtitle: 'Boletos e Pix',
            onTap: () => Navigator.pushNamed(context, PixPayScreen.routeName),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _shortcut(
            context,
            icon: Icons.close,
            iconSize: 24,
            iconColor: AppColors.textTertiary,
            title: 'Em breve',
            subtitle: 'Novidades',
            onTap: () => _soon(context),
          ),
        ),
      ],
    );
  }

  Widget _shortcut(
    BuildContext context, {
    required IconData icon,
    required double iconSize,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 8),
            Text(title,
                style: _inter(15, FontWeight.w600, AppColors.textPrimary, height: 1.2),
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(subtitle,
                style: _inter(12, FontWeight.w400, AppColors.textSecondary, height: 1.2),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({required Widget child, VoidCallback? onTap}) {
    final card = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: child,
    );
    if (onTap == null) return card;
    return GestureDetector(onTap: onTap, child: card);
  }

  Widget _iconBox(IconData icon, {Color? color}) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: (color ?? AppColors.actionPrimary).withAlpha((0.12 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 24, color: color ?? AppColors.actionPrimary),
    );
  }

  // Seu desempenho -> extrato.
  Widget _buildPerformanceCard(BuildContext context) {
    return _sectionCard(
      onTap: () => Navigator.pushNamed(context, StatementScreen.routeName),
      child: Row(
        children: [
          _iconBox(Icons.trending_up, color: AppColors.successGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seu desempenho',
                    style: _inter(17, FontWeight.w600, AppColors.textPrimary, height: 1.2)),
                const SizedBox(height: 4),
                Text('Acompanhe como está o seu negócio',
                    style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 24, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  // Meta do mês.
  Widget _buildGoalCard() {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Meta do mês', style: _inter(17, FontWeight.w600, AppColors.textPrimary, height: 1.2)),
          const SizedBox(height: 4),
          Text('Faltam R\$ 1.390 para a meta de R\$ 5.000',
              style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
          const SizedBox(height: 12),
          Text('R\$ 3.610,00', style: _inter(26, FontWeight.w700, AppColors.textPrimary, height: 1.1)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.72,
              minHeight: 8,
              backgroundColor: AppColors.backgroundTertiary,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.actionPrimary),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('72%', style: _inter(14, FontWeight.w600, AppColors.actionPrimary)),
          ),
        ],
      ),
    );
  }

  // Dica do banco.
  Widget _buildTipCard(BuildContext context) {
    return _sectionCard(
      onTap: () => _soon(context),
      child: Row(
        children: [
          _iconBox(Icons.lightbulb_outlined, color: AppColors.warningOrange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dica do seu banco',
                    style: _inter(17, FontWeight.w600, AppColors.textPrimary, height: 1.2)),
                const SizedBox(height: 4),
                Text('Ative o Pix automático e nunca perca uma venda',
                    style: _inter(14, FontWeight.w400, AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 24, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  // Segurança com botão pill.
  Widget _buildSecurityCard(BuildContext context) {
    return _sectionCard(
      child: Row(
        children: [
          _iconBox(Icons.shield_outlined, color: AppColors.actionPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Segurança', style: _inter(17, FontWeight.w600, AppColors.textPrimary, height: 1.2)),
                const SizedBox(height: 4),
                Text('Verificação em 2 etapas protege sua conta',
                    style: _inter(13, FontWeight.w400, AppColors.textSecondary)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 105,
            height: 42,
            child: ElevatedButton(
              onPressed: () => _soon(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
                padding: EdgeInsets.zero,
              ),
              child: Text('Ativar', style: _inter(14, FontWeight.w600, Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // Navegação inferior: 4 itens, indicador 32x3 no ativo.
  Widget _buildBottomNav(BuildContext context) {
    const items = [
      (Icons.home_outlined, 'Início'),
      (Icons.account_balance_wallet_outlined, 'Carteira'),
      (Icons.shopping_bag_outlined, 'Vendas'),
      (Icons.receipt_long_outlined, 'Histórico'),
    ];
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundPrimary,
        border: Border(top: BorderSide(color: AppColors.borderDefault, width: 1)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (i == 0) return;
                  if (i == 1) {
                    Navigator.pushNamed(context, WalletScreen.routeName);
                  } else if (i == 2) {
                    Navigator.pushNamed(context, SalesScreen.routeName);
                  } else {
                    Navigator.pushNamed(context, StatementScreen.routeName);
                  }
                },
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(items[i].$1,
                          size: 24,
                          color: i == 0 ? AppColors.actionPrimary : AppColors.textSecondary),
                      const SizedBox(height: 4),
                      Text(items[i].$2,
                          style: _inter(12, FontWeight.w500,
                              i == 0 ? AppColors.actionPrimary : AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Container(
                        width: 32,
                        height: 3,
                        decoration: BoxDecoration(
                          color: i == 0 ? AppColors.actionPrimary : Colors.transparent,
                          borderRadius: BorderRadius.circular(2),
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
}
