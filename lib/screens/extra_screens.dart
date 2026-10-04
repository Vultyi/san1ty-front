// Telas extras da home: Extrato, Carteira, Depositar, Saque e Abertura.
// Tokens (ink, sky, ice, mu, line, disp(), body(), brl(), parse(), Shell,
// Cta) vêm de sales_screen.dart.
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';

// Ciclo home_shell <-> extra_screens permitido: só referências de classes.
import 'package:estrutura_front_san1ty/screens/home_shell.dart';

const appName = 'San1ty'; // nome mostrado na abertura
const outC = Color(0xFFFF9393);
const white = Color(0xFFF3F6FF), navy = Color(0xFF0A1070);

void _openPage(BuildContext c, Widget p) =>
    Navigator.push(c, MaterialPageRoute(builder: (_) => p));

class Tx {
  final String day, kind, who, time;
  final double v;
  const Tx(this.day, this.kind, this.who, this.time, this.v);
}

// TODO: troque pelos dados reais da API
const txs = [
  Tx('Hoje', 'Pix recebido', 'João Silva', '14:30', 50),
  Tx('Hoje', 'Compra', 'Shopping', '12:15', -120),
  Tx('Ontem', 'Pix recebido', 'Maria Santos', '18:45', 89.9),
  Tx('Ontem', 'Saque', 'Nubank, final 4471', '10:30', -200),
  Tx('2 dias atrás', 'Pix recebido', 'Pedro Oliveira', '16:10', 150),
  Tx('2 dias atrás', 'Venda', 'Pack de presets', '09:02', 39.9),
];

String signed(double v) => '${v > 0 ? '+' : '−'} ${brl(v.abs())}';

Widget txRow(Tx t) => Container(
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(t.who, style: body(15, w: FontWeight.w600)),
          Text('${t.kind}, ${t.time}', style: body(13, c: mu)),
        ]),
        Text(signed(t.v), style: disp(16, c: t.v > 0 ? ice : outC)),
      ]),
    );

Widget header(BuildContext c, String title, {Widget? right, bool back = false}) => Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        SizedBox(width: 60, child: back ? GestureDetector(onTap: () => Navigator.pop(c), child: Text('Voltar', style: body(14, c: mu))) : null),
        Text(title, style: disp(18)),
        SizedBox(width: 60, child: Align(alignment: Alignment.centerRight, child: right)),
      ]),
    );

Widget ln(String a, Widget b) => Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a, style: body(14.5, c: mu)), b]),
    );

Widget stat(String l, String v, {Color c = Colors.white}) =>
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(l, style: body(13, c: mu)), const SizedBox(height: 2), Text(v, style: disp(20, c: c))]);

// ---------------- EXTRATO ----------------
class ExtratoPage extends StatefulWidget {
  const ExtratoPage({super.key});
  @override
  State<ExtratoPage> createState() => _ExtratoPageState();
}

class _ExtratoPageState extends State<ExtratoPage> {
  int f = 0;
  @override
  Widget build(BuildContext context) {
    final inn = txs.where((t) => t.v > 0).fold<double>(0, (a, t) => a + t.v);
    final out = txs.where((t) => t.v < 0).fold<double>(0, (a, t) => a + t.v);
    final list = txs.where((t) => f == 0 || (f == 1 ? t.v > 0 : t.v < 0)).toList();
    final kids = <Widget>[];
    String? last;
    for (final t in list) {
      if (t.day != last) {
        last = t.day;
        kids.add(Padding(padding: const EdgeInsets.only(top: 22, bottom: 2), child: Text(t.day, style: body(12.5, c: mu))));
      }
      kids.add(txRow(t));
    }
    return Shell(ListView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 24), children: [
      header(context, 'Extrato',
          right: GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Extrato baixado em PDF'))), // TODO: gerar PDF
              child: Text('Baixar', style: body(14, c: mu)))),
      Text('Saldo do período', style: body(14, c: mu)),
      const SizedBox(height: 6),
      Text(brl(inn + out), style: disp(34)),
      const SizedBox(height: 16),
      Row(children: [stat('Entradas', '+ ${brl(inn)}', c: ice), const SizedBox(width: 34), stat('Saídas', '− ${brl(-out)}', c: outC)]),
      const SizedBox(height: 16),
      Row(children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(color: const Color(0x12D6E2FF), borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            for (var i = 0; i < 3; i++)
              GestureDetector(
                onTap: () => setState(() => f = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(color: i == f ? white : null, borderRadius: BorderRadius.circular(9)),
                  child: Text(['Tudo', 'Entradas', 'Saídas'][i], style: body(13, c: i == f ? navy : mu, w: i == f ? FontWeight.w600 : FontWeight.w400)),
                ),
              ),
          ]),
        ),
      ]),
      ...kids,
    ]));
  }
}

// ---------------- CARTEIRA ----------------
class CarteiraPage extends StatefulWidget {
  const CarteiraPage({super.key});
  @override
  State<CarteiraPage> createState() => _CarteiraPageState();
}

class _CarteiraPageState extends State<CarteiraPage> {
  bool hide = false;

  Widget act(IconData i, String l, {bool filled = false, VoidCallback? tap}) => Expanded(
        child: InkWell(
          onTap: tap,
          child: Column(children: [
            Container(
              width: 56, height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle, color: filled ? white : null, border: Border.all(color: filled ? white : sky, width: 1.5)),
              child: Icon(i, color: filled ? navy : sky),
            ),
            const SizedBox(height: 8),
            Text(l, style: body(13)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) => Shell(ListView(padding: const EdgeInsets.fromLTRB(22, 18, 22, 24), children: [
        header(context, 'Carteira',
            right: GestureDetector(onTap: () => setState(() => hide = !hide), child: Icon(hide ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: mu))),
        Text('Saldo disponível', style: body(14, c: mu)),
        const SizedBox(height: 6),
        Text(hide ? 'R\$ ••••••' : brl(1356.98), style: disp(34)),
        const SizedBox(height: 14),
        Row(children: [stat('A receber', 'R\$ 45,50'), const SizedBox(width: 34), stat('Bloqueado', 'R\$ 0,00')]),
        const SizedBox(height: 26),
        Row(children: [
          act(Icons.south_rounded, 'Depositar', filled: true, tap: () => _openPage(context, const DepositPage())),
          act(Icons.north_rounded, 'Sacar', filled: true, tap: () => _openPage(context, const WithdrawPage())),
          act(Icons.pix, 'Pix'), // TODO: tela de Pix
          act(Icons.swap_horiz_rounded, 'Transferir'), // TODO
        ]),
        const SizedBox(height: 28),
        Text('Contas para saque', style: disp(17)),
        const RowItemPlaceholder(),
        const SizedBox(height: 26),
        Text('Últimas movimentações', style: disp(17)),
        const SizedBox(height: 6),
        txRow(txs[0]),
        txRow(txs[3]),
      ]));
}

class RowItemPlaceholder extends StatelessWidget {
  const RowItemPlaceholder({super.key});
  @override
  Widget build(BuildContext context) => Column(children: const [
        _AcctRow(name: 'Nubank', sub: 'Pix, chave CPF final 4471'),
        _AcctRow(name: 'Itaú', sub: 'Pix, chave e-mail'),
      ]);
}

class _AcctRow extends StatelessWidget {
  final String name, sub;
  const _AcctRow({required this.name, required this.sub});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
        child: Row(children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(color: const Color(0x12D6E2FF), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.account_balance_wallet_outlined, color: sky),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: body(15, w: FontWeight.w600)),
              Text(sub, style: body(13, c: mu)),
            ]),
          ),
          const Icon(Icons.chevron_right_rounded, color: mu),
        ]),
      );
}

// ---------------- DEPOSITAR ----------------
class DepositPage extends StatelessWidget {
  const DepositPage({super.key});
  static const code = '00020126580014br.gov.bcb.pix0136sanitypay-coutinho5204000053039865802BR'; // TODO: gerar na API
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            header(context, 'Depositar', back: true),
            Text('Deposite por Pix', style: disp(26)),
            const SizedBox(height: 6),
            Text('Copie o código e pague no app do seu banco. Cai na hora.', style: body(14, c: mu)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 22),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0x12D6E2FF), borderRadius: BorderRadius.circular(16)),
              child: Text(code, style: GoogleFonts.bricolageGrotesque(fontSize: 14, color: Colors.white)),
            ),
            Cta('Copiar código', () {
              Clipboard.setData(const ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Código copiado')));
            }),
          ]),
        )),
      );
}

// ---------------- SAQUE (3 passos) ----------------
class WithdrawPage extends StatefulWidget {
  const WithdrawPage({super.key});
  @override
  State<WithdrawPage> createState() => _WithdrawPageState();
}

class _WithdrawPageState extends State<WithdrawPage> {
  static const saldo = 1356.98, fee = 3.5;
  static const accts = ['Nubank, final 4471', 'Itaú, chave e-mail'];
  final c = TextEditingController();
  int step = 1, acct = 0;
  String proto = '';
  double get v => parse(c.text);
  bool get valid => v > fee && v <= saldo;

  @override
  void dispose() {
    c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (step < 3)
              Padding(
                padding: const EdgeInsets.only(bottom: 22),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  GestureDetector(onTap: () => step > 1 ? setState(() => step--) : Navigator.pop(context), child: Text('Voltar', style: body(14, c: mu))),
                  Text('Sacar', style: disp(18)),
                  const SizedBox(width: 40),
                ]),
              ),
            Expanded(child: step == 1 ? one() : step == 2 ? two() : three()),
          ]),
        )),
      );

  Widget one() => ListView(children: [
        Text('Quanto você quer sacar?', style: body(14, c: mu)),
        TextField(
          controller: c,
          onChanged: (_) => setState(() {}),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          cursorColor: sky,
          style: disp(48),
          decoration: InputDecoration(prefixText: 'R\$ ', prefixStyle: disp(48, c: mu), hintText: '0,00', hintStyle: disp(48, c: const Color(0xFF2C3A82)), border: InputBorder.none),
        ),
        Row(children: [
          Text('Disponível ${brl(saldo)}  ·  ', style: body(14, c: mu)),
          GestureDetector(onTap: () => setState(() => c.text = saldo.toStringAsFixed(2).replaceAll('.', ',')), child: Text('Sacar tudo', style: body(14, c: sky))),
        ]),
        const SizedBox(height: 24),
        Text('Para onde?', style: disp(17)),
        const SizedBox(height: 10),
        Wrap(spacing: 8, children: [
          for (var i = 0; i < accts.length; i++)
            GestureDetector(
              onTap: () => setState(() => acct = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(color: i == acct ? white : null, borderRadius: BorderRadius.circular(99), border: Border.all(color: i == acct ? white : line)),
                child: Text(accts[i], style: body(13.5, c: i == acct ? navy : ice, w: i == acct ? FontWeight.w600 : FontWeight.w400)),
              ),
            ),
        ]),
        const SizedBox(height: 20),
        ln('Taxa de saque', Text(brl(fee), style: body(14.5))),
        ln('Prazo', Text('Na hora, por Pix', style: body(14.5))),
        ln('Você recebe', Text(brl(max(v - fee, 0)), style: disp(15))),
        const SizedBox(height: 24),
        Cta('Revisar saque', valid ? () => setState(() => step = 2) : null),
      ]);

  Widget two() => ListView(children: [
        Text('Você vai sacar', style: body(14, c: mu)),
        const SizedBox(height: 8),
        Text(brl(v), style: disp(44)),
        const SizedBox(height: 22),
        ln('De', Text('Saldo $appName', style: body(14.5))),
        ln('Para', Text(accts[acct], style: body(14.5))),
        ln('Taxa', Text(brl(fee), style: body(14.5))),
        ln('Você recebe', Text(brl(v - fee), style: disp(15))),
        const SizedBox(height: 24),
        // TODO: aqui você chama sua API de saque antes de ir pro passo 3
        Cta('Confirmar saque', () => setState(() {
              proto = '#SQ-${10000 + Random().nextInt(89999)}';
              step = 3;
            })),
      ]);

  Widget three() => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 84, height: 84, decoration: const BoxDecoration(color: Color(0xFF2336D9), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 44)),
        const SizedBox(height: 20),
        Text('Saque enviado', style: disp(26)),
        const SizedBox(height: 8),
        Text('${brl(v - fee)} a caminho de ${accts[acct]}', style: body(14, c: mu), textAlign: TextAlign.center),
        const SizedBox(height: 22),
        ln('Protocolo', Text(proto, style: body(14.5))),
        const SizedBox(height: 22),
        Cta('Voltar à carteira', () => Navigator.pop(context)),
      ]);
}

// ---------------- ABERTURA ----------------
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final ac = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..forward();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2800), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) => const AppShell(),
          transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
        ),
      );
    });
  }

  @override
  void dispose() {
    ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final word = CurvedAnimation(parent: ac, curve: const Interval(0, .7, curve: Curves.easeOutCubic));
    final tag = CurvedAnimation(parent: ac, curve: const Interval(.55, 1, curve: Curves.easeOut));
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(center: Alignment(.8, -1), radius: 1.3, colors: [Color(0xFF2A47E0), Color(0xFF070D4A), ink], stops: [0, .45, 1]),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: ac,
            builder: (_, __) => Column(mainAxisSize: MainAxisSize.min, children: [
              Opacity(
                opacity: word.value,
                child: Transform.translate(
                  offset: Offset(0, 18 * (1 - word.value)),
                  child: Text.rich(
                    TextSpan(children: [
                      const TextSpan(text: 'San', style: TextStyle(color: Colors.white)),
                      const TextSpan(text: '1', style: TextStyle(color: sky)),
                      const TextSpan(text: 'ty', style: TextStyle(color: Colors.white)),
                    ]),
                    style: GoogleFonts.bricolageGrotesque(fontSize: 54, fontWeight: FontWeight.w800, letterSpacing: 10 - 12.5 * word.value, height: 1),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Opacity(opacity: tag.value, child: Text('Seu dinheiro, do seu jeito.', style: body(15, c: mu))),
            ]),
          ),
        ),
      ),
    );
  }
}
