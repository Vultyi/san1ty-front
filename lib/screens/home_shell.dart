// AppShell + Home + Drawer + Suporte (design San1ty).
// Tokens compartilhados vêm de sales_screen.dart (ink, sky, ice, mu, line,
// disp(), body(), brl(), parse(), Shell, Cta).
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:estrutura_front_san1ty/screens/commerce_intro_screen.dart';
import 'package:estrutura_front_san1ty/screens/extra_screens.dart';
import 'package:estrutura_front_san1ty/screens/auth_screens.dart';
import 'package:estrutura_front_san1ty/screens/notifications_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_home_screen.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

class AppShell extends StatefulWidget {
  static const String routeName = '/shell';

  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int tab = 0;
  static const _ic = [Icons.home_rounded, Icons.receipt_long_outlined, Icons.storefront_outlined, Icons.account_balance_wallet_outlined];
  static const _lb = ['Início', 'Extrato', 'Comércio', 'Carteira'];

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onTab: (i) => setState(() => tab = i)),
      const ExtratoPage(),
      const CommerceIntroScreen(),
      const CarteiraPage(),
    ];
    return Scaffold(
      drawer: const MenuDrawer(),
      body: PopScope(
        canPop: tab != 2,
        child: IndexedStack(index: tab, children: pages),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(color: Color(0xF203050F), border: Border(top: BorderSide(color: line))),
        padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).padding.bottom + 10),
        child: Row(children: [
          for (var i = 0; i < 4; i++)
            Expanded(
              child: InkWell(
                onTap: () => setState(() => tab = i),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_ic[i], color: i == tab ? sky : mu),
                  const SizedBox(height: 3),
                  Text(_lb[i], style: body(12, c: i == tab ? Colors.white : mu, w: i == tab ? FontWeight.w600 : FontWeight.w400)),
                ]),
              ),
            ),
        ]),
      ),
    );
  }
}

class Soon extends StatelessWidget {
  final String title;
  const Soon(this.title, {super.key});
  @override
  Widget build(BuildContext context) =>
      Shell(Center(child: Text('$title\nem construção', textAlign: TextAlign.center, style: disp(22, c: mu))));
}

class RowItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? sub;
  final VoidCallback? onTap;
  final Widget? trailing;
  const RowItem(this.icon, this.title, {this.sub, this.onTap, this.trailing, super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
          child: Row(children: [
            iconBox(icon),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: body(15, w: FontWeight.w600)),
                if (sub != null) Text(sub!, style: body(13, c: mu)),
              ]),
            ),
            trailing ?? (onTap != null ? const Icon(Icons.chevron_right_rounded, color: mu) : const SizedBox()),
          ]),
        ),
      );
}

Widget iconBox(IconData i) => Container(
    width: 46, height: 46,
    decoration: BoxDecoration(color: const Color(0x12D6E2FF), borderRadius: BorderRadius.circular(14)),
    child: Icon(i, color: sky));

void openPage(BuildContext c, Widget p) => Navigator.push(c, MaterialPageRoute(builder: (_) => p));

class HomePage extends StatefulWidget {
  final ValueChanged<int> onTab;
  const HomePage({super.key, required this.onTab});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool hide = false;
  double? goal; // meta definida pelo usuário
  String _name = 'por aqui';
  final double earned = 3610; // TODO: soma das vendas do mês vinda da API

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final user = await AuthService().getCurrentUser();
    if (!mounted) return;
    setState(() {
      goal = prefs.getDouble('meta_mes');
      final full = ((user?['full_name'] ?? '') as String).trim();
      final first = full.split(RegExp(r'\s+')).firstWhere((p) => p.isNotEmpty, orElse: () => '');
      if (first.isNotEmpty) _name = first;
    });
  }

  Future<void> editGoal() async {
    final v = await showModalBottomSheet<double>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B1235),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => GoalSheet(goal),
    );
    if (v == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('meta_mes', v);
    if (!mounted) return;
    setState(() => goal = v); // TODO: salvar a meta na API
  }

  Widget tile(IconData i, String t, String s, {bool first = false, bool off = false, VoidCallback? tap}) => Expanded(
        child: InkWell(
          onTap: tap,
          borderRadius: BorderRadius.circular(18),
          child: Opacity(
            opacity: off ? .55 : 1,
            child: Container(
              height: 112,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: first ? const Color(0x246C92FF) : const Color(0x12D6E2FF),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: first ? sky : Colors.transparent),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(i, color: off ? mu : sky),
                const Spacer(),
                Text(t, style: disp(14).copyWith(fontWeight: FontWeight.w700)),
                Text(s, style: body(11.5, c: mu), maxLines: 2),
              ]),
            ),
          ),
        ),
      );

  Widget goalRow() {
    final g = goal;
    return InkWell(
      onTap: editGoal,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            iconBox(Icons.track_changes_rounded),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Meta do mês', style: body(15, w: FontWeight.w600)),
                Text(g == null ? 'Toque para definir quanto quer vender' : 'Toque para editar sua meta', style: body(13, c: mu)),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: mu),
          ]),
          if (g != null) ...[
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(value: (earned / g).clamp(0.0, 1.0), minHeight: 4, backgroundColor: line, color: sky),
            ),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('${brl(earned)} de ${brl(g)}', style: body(13, c: mu)),
              Text(earned >= g ? 'Meta batida' : '${(earned / g * 100).floor()}%, faltam ${brl(g - earned)}', style: body(13, c: sky)),
            ]),
          ],
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Shell(ListView(padding: const EdgeInsets.fromLTRB(18, 8, 18, 24), children: [
        Row(children: [
          IconButton(onPressed: () => Scaffold.of(context).openDrawer(), icon: const Icon(Icons.menu_rounded, color: ice)),
          const Spacer(),
          IconButton(onPressed: () => openPage(context, const SupportPage()), icon: const Icon(Icons.headset_mic_outlined, color: ice)),
          IconButton(
            onPressed: () => openPage(context, const NotificationsScreen()),
            icon: Stack(children: [
              const Icon(Icons.notifications_none_rounded, color: ice),
              Positioned(right: 1, top: 1, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: sky, shape: BoxShape.circle))),
            ]),
          ),
        ]),
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 4, 22),
          child: Row(children: [
            Container(width: 58, height: 58, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: sky, width: 2)), child: const Icon(Icons.photo_camera_outlined, color: ice)),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Olá, $_name', style: disp(21)), Text('Que bom ter você por aqui.', style: body(14, c: mu))]),
          ]),
        ),
        // "quadrado invisível": só um fundo bem sutil, sem borda
        InkWell(
          onTap: () => widget.onTab(3),
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: const Color(0x0DD6E2FF), borderRadius: BorderRadius.circular(24)),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Saldo em conta', style: body(14, c: mu)),
                    const SizedBox(width: 8),
                    GestureDetector(onTap: () => setState(() => hide = !hide), child: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 18, color: mu)),
                  ]),
                  const SizedBox(height: 8),
                  Text(hide ? 'R\$ ••••••' : 'R\$ 1.356,98', style: disp(30)),
                  const SizedBox(height: 6),
                  Text('Seu dinheiro rende mais aqui', style: body(13, c: mu)),
                ]),
              ),
              const Icon(Icons.chevron_right_rounded, color: mu),
            ]),
          ),
        ),
        const SizedBox(height: 16),
        Row(children: [
          tile(Icons.pix, 'Pix', 'Transferir e pagar',
              first: true,
              tap: () => Navigator.pushNamed(context, PixHomeScreen.routeName)),
          tile(Icons.shopping_bag_outlined, 'Vendas', 'Seu faturamento',
              tap: () => Navigator.pushNamed(context, SalesScreen.routeName)),
          tile(Icons.request_page_outlined, 'Pagar conta', 'Boletos e serviços', tap: () {}),
          tile(Icons.close_rounded, 'Em breve', 'Novidades', off: true),
        ]),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(children: [
            RowItem(Icons.bar_chart_rounded, 'Seu desempenho', sub: 'Acompanhe como está o seu negócio', onTap: () => widget.onTab(2)),
            goalRow(),
            const RowItem(Icons.lightbulb_outline_rounded, 'Dica do seu banco', sub: 'Ative o Pix automático e nunca perca uma venda', onTap: null),
            RowItem(Icons.shield_outlined, 'Segurança em primeiro lugar', sub: 'Ative a verificação em 2 etapas', trailing: Text('Ativar', style: body(13, c: sky, w: FontWeight.w600))),
          ]),
        ),
      ]));
}

class GoalSheet extends StatefulWidget {
  final double? current;
  const GoalSheet(this.current, {super.key});
  @override
  State<GoalSheet> createState() => _GoalSheetState();
}

class _GoalSheetState extends State<GoalSheet> {
  late final c = TextEditingController(text: widget.current == null ? '' : widget.current!.toStringAsFixed(2).replaceAll('.', ','));
  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.fromLTRB(22, 14, 22, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 42, height: 4, decoration: BoxDecoration(color: line, borderRadius: BorderRadius.circular(4)))),
          const SizedBox(height: 20),
          Text('Quanto você quer vender este mês?', style: disp(22)),
          const SizedBox(height: 6),
          Text('A gente acompanha suas vendas até lá.', style: body(14, c: mu)),
          const SizedBox(height: 14),
          TextField(
            controller: c,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            cursorColor: sky,
            style: disp(36),
            decoration: InputDecoration(
              prefixText: 'R\$ ',
              prefixStyle: disp(36, c: mu),
              hintText: '5.000',
              hintStyle: disp(36, c: const Color(0xFF2C3A82)),
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 14),
          Cta('Definir meta', parse(c.text) > 0 ? () => Navigator.pop(context, parse(c.text)) : null),
        ]),
      );
}

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});
  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  String _name = '';

  @override
  void initState() {
    super.initState();
    AuthService().getCurrentUser().then((user) {
      if (!mounted) return;
      final full = ((user?['full_name'] ?? '') as String).trim();
      final first = full.split(RegExp(r'\s+')).firstWhere((p) => p.isNotEmpty, orElse: () => '');
      if (first.isNotEmpty) setState(() => _name = first);
    });
  }

  void _open(BuildContext ctx, Widget p) {
    final nav = Navigator.of(ctx);
    nav.pop();
    nav.push(MaterialPageRoute(builder: (_) => p));
  }

  Future<void> _logout(BuildContext ctx) async {
    final nav = Navigator.of(ctx);
    nav.pop();
    await AuthService().logout();
    if (!ctx.mounted) return;
    nav.pushNamedAndRemoveUntil(LoginPage.routeName, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final initial = _name.isNotEmpty ? _name[0].toUpperCase() : '?';
    return Drawer(
      backgroundColor: const Color(0xFF070D2E),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 0),
          child: Column(children: [
            Row(children: [
              Container(width: 52, height: 52, alignment: Alignment.center, decoration: const BoxDecoration(color: Color(0xFF2336D9), shape: BoxShape.circle), child: Text(initial, style: disp(22))),
              const SizedBox(width: 14),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(_name.isEmpty ? 'Olá' : _name, style: disp(20)), Text('Conta San1ty', style: body(13, c: mu))]),
            ]),
            const SizedBox(height: 20),
            RowItem(Icons.person_outline_rounded, 'Perfil', onTap: () => _open(context, const InfoPage('Perfil', [
                  RowItem(Icons.badge_outlined, 'Dados da conta', sub: 'Nome, CPF e endereço'),
                  RowItem(Icons.pix, 'Minhas chaves Pix'),
                ]))),
            RowItem(Icons.settings_outlined, 'Configurações', onTap: () => _open(context, const InfoPage('Configurações', [
                  RowItem(Icons.notifications_none_rounded, 'Notificações'),
                  RowItem(Icons.lock_outline_rounded, 'Segurança e senha'),
                ]))),
            RowItem(Icons.headset_mic_outlined, 'Suporte', onTap: () => _open(context, const SupportPage())),
            const Spacer(),
            RowItem(Icons.logout_rounded, 'Sair da conta', onTap: () => _logout(context)),
            const SizedBox(height: 12),
          ]),
        ),
      ),
    );
  }
}

class InfoPage extends StatelessWidget {
  final String title;
  final List<Widget> rows;
  const InfoPage(this.title, this.rows, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: Text('Voltar', style: body(14, c: mu))),
              Text(title, style: disp(18)),
              const SizedBox(width: 40),
            ]),
            const SizedBox(height: 20),
            ...rows,
          ]),
        )),
      );
}

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});
  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  static const topics = ['Pix', 'Saque', 'Vendas', 'Minha conta', 'Outro'];
  final msg = TextEditingController();
  int topic = 0;
  String? proto;

  @override
  void dispose() {
    msg.dispose();
    super.dispose();
  }

  void send() => setState(() => proto = '#SP-${10000 + Random().nextInt(89999)}'); // TODO: enviar para sua API

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
          child: proto != null
              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(width: 84, height: 84, decoration: const BoxDecoration(color: Color(0xFF2336D9), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 44)),
                  const SizedBox(height: 20),
                  Text('Recebemos seu pedido', style: disp(26)),
                  const SizedBox(height: 8),
                  Text('Protocolo $proto. Respondemos em até 24 horas.', style: body(14, c: mu), textAlign: TextAlign.center),
                  const SizedBox(height: 26),
                  Cta('Voltar ao início', () => Navigator.pop(context)),
                ])
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    GestureDetector(onTap: () => Navigator.pop(context), child: Text('Voltar', style: body(14, c: mu))),
                    Text('Suporte', style: disp(18)),
                    const SizedBox(width: 40),
                  ]),
                  const SizedBox(height: 24),
                  Text('Como podemos ajudar?', style: disp(26)),
                  const SizedBox(height: 6),
                  Text('Escolha o assunto e conte o que aconteceu.', style: body(14, c: mu)),
                  const SizedBox(height: 18),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (var i = 0; i < topics.length; i++)
                      GestureDetector(
                        onTap: () => setState(() => topic = i),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(color: i == topic ? const Color(0xFFF3F6FF) : null, borderRadius: BorderRadius.circular(99), border: Border.all(color: i == topic ? const Color(0xFFF3F6FF) : line)),
                          child: Text(topics[i], style: body(13.5, c: i == topic ? const Color(0xFF0A1070) : ice, w: i == topic ? FontWeight.w600 : FontWeight.w400)),
                        ),
                      ),
                  ]),
                  const SizedBox(height: 22),
                  Text('Descreva o problema', style: body(13, c: mu)),
                  TextField(
                    controller: msg,
                    maxLines: 5,
                    onChanged: (_) => setState(() {}),
                    cursorColor: sky,
                    style: body(17),
                    decoration: InputDecoration(
                      hintText: 'Ex.: fiz um Pix e o valor não apareceu no saldo',
                      hintStyle: body(16, c: const Color(0xFF3C4C8F)),
                      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: line, width: 1.5)),
                      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: sky, width: 1.5)),
                    ),
                  ),
                  const Spacer(),
                  Cta('Enviar para o suporte', msg.text.trim().length >= 10 ? send : null),
                ]),
        )),
      );
}
