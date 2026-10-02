import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const ink = Color(0xFF03050F), sky = Color(0xFF6C92FF), ice = Color(0xFFD6E2FF), mu = Color(0xFF8E9FD8);
const line = Color(0x24D6E2FF);
const covers = [Color(0xFF2336D9), Color(0xFF1D7BFF), Color(0xFF14246B), Color(0xFF0E6BA8), Color(0xFF2A3350)];

TextStyle disp(double s, {Color c = Colors.white}) => GoogleFonts.bricolageGrotesque(
    fontSize: s, fontWeight: FontWeight.w800, letterSpacing: -s * .035, color: c, height: .95);
TextStyle body(double s, {Color c = Colors.white, FontWeight w = FontWeight.w400}) =>
    GoogleFonts.instrumentSans(fontSize: s, color: c, fontWeight: w);

String brl(double v) {
  final f = v.toStringAsFixed(2).split('.');
  final i = f[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  return 'R\$ $i,${f[1]}';
}

double parse(String s) => double.tryParse(s.replaceAll('.', '').replaceAll(',', '.')) ?? 0;

String slugify(String s) {
  const a = 'áàâãäéèêëíìîïóòôõöúùûüç', b = 'aaaaaeeeeiiiiooooouuuuc';
  var t = s.toLowerCase();
  for (var i = 0; i < a.length; i++) {
    t = t.replaceAll(a[i], b[i]);
  }
  return t.replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-|-$'), '');
}

/// Troque `d` (vendas dos últimos 7 dias) pelos dados reais da sua API.
class Product {
  String name;
  double price;
  Color color;
  List<int> d;
  Product(this.name, this.price, this.color, this.d);
  List<int> counts(int per) => per == 7 ? d : List.generate(30, (i) => d[(i * 3 + 1) % 7]);
}

class Shell extends StatelessWidget {
  final Widget child;
  const Shell(this.child, {super.key});
  @override
  Widget build(BuildContext context) => Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF070D4A), Color(0xFF040829), ink],
                stops: [0, .38, 1])),
        child: SafeArea(child: child),
      );
}

class Cta extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  const Cta(this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onTap == null ? .35 : 1,
        child: Material(
          color: const Color(0xFFF3F6FF),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                alignment: Alignment.center,
                child: Text(label, style: disp(17, c: const Color(0xFF0A1070)))),
          ),
        ),
      );
}

class CoverPreview extends StatelessWidget {
  final String title, sub;
  final Color color;
  const CoverPreview(this.title, this.sub, this.color, {super.key});
  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 170,
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(begin: const Alignment(-.4, -1), end: const Alignment(.4, 1), colors: [color, const Color(0xFF050A33)])),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: disp(32), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 8),
          Text(sub, style: body(15, c: ice)),
        ]),
      );
}

class BarsPainter extends CustomPainter {
  final List<double> v;
  BarsPainter(this.v);
  @override
  void paint(Canvas c, Size s) {
    final mx = v.fold<double>(1, (a, b) => b > a ? b : a), w = s.width / v.length;
    for (var i = 0; i < v.length; i++) {
      final h = (v[i] / mx * s.height).clamp(v[i] > 0 ? 4.0 : 2.0, s.height);
      final p = Paint()..color = v[i] > 0 ? (i == v.length - 1 ? ice : sky) : const Color(0xFF25306F);
      c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(i * w + w * .14, s.height - h, w * .72, h), Radius.circular(w < 12 ? 3 : 6)), p);
    }
  }

  @override
  bool shouldRepaint(BarsPainter o) => true;
}

class SalesScreen extends StatefulWidget {
  static const String routeName = '/sales';

  const SalesScreen({super.key});
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final prods = <Product>[
    Product('Curso de edição de vídeo', 149.9, covers[0], [3, 5, 2, 6, 4, 7, 5]),
    Product('Pack de presets', 39.9, covers[1], [8, 6, 9, 5, 7, 4, 6]),
    Product('Mentoria 1:1', 497, covers[2], [0, 1, 0, 0, 1, 0, 0]),
    Product('E-book de roteiros', 29.9, covers[3], [0, 0, 0, 0, 0, 0, 0]),
  ];
  int per = 7;
  Product? sel;

  int qty(Product p) => p.counts(per).fold(0, (a, b) => a + b);
  double rev(Product p) => qty(p) * p.price;

  @override
  Widget build(BuildContext context) {
    final src = sel == null ? prods : [sel!];
    final days = List<double>.filled(per, 0);
    var q = 0;
    for (final p in src) {
      final c = p.counts(per);
      for (var i = 0; i < per; i++) {
        days[i] += c[i] * p.price;
        q += c[i];
      }
    }
    final tot = days.fold<double>(0, (a, b) => a + b);
    final rank = [...prods]..sort((a, b) => rev(b).compareTo(rev(a)));
    final all = prods.fold<double>(0, (a, p) => a + rev(p));

    return Scaffold(
      body: Shell(Stack(children: [
        ListView(padding: const EdgeInsets.fromLTRB(22, 20, 22, 120), children: [
          Center(child: Text('Vendas', style: disp(18))),
          const SizedBox(height: 22),
          Text(sel?.name ?? 'Todos os produtos', style: body(14, c: mu)),
          const SizedBox(height: 6),
          Text(brl(tot), style: disp(46)),
          const SizedBox(height: 6),
          Text('$q ${q == 1 ? 'venda' : 'vendas'} nos últimos $per dias', style: body(14, c: mu)),
          const SizedBox(height: 14),
          Row(children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(color: const Color(0x17D6E2FF), borderRadius: BorderRadius.circular(12)),
              child: Row(children: [7, 30].map((n) {
                final on = n == per;
                return GestureDetector(
                  onTap: () => setState(() => per = n),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(color: on ? const Color(0xFFF3F6FF) : null, borderRadius: BorderRadius.circular(9)),
                    child: Text('$n dias', style: body(13, c: on ? const Color(0xFF0A1070) : mu, w: on ? FontWeight.w600 : FontWeight.w400)),
                  ),
                );
              }).toList()),
            ),
          ]),
          const SizedBox(height: 14),
          SizedBox(height: 130, child: CustomPaint(size: Size.infinite, painter: BarsPainter(days))),
          const SizedBox(height: 6),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('há $per dias', style: body(11.5, c: mu)), Text('hoje', style: body(11.5, c: mu))]),
          const SizedBox(height: 26),
          Text('Seus produtos', style: disp(17)),
          const SizedBox(height: 4),
          Text('Toque num produto para ver só as vendas dele.', style: body(13, c: mu)),
          for (final p in rank) productRow(p, all),
        ]),
        Positioned(
          left: 0, right: 0, bottom: 0,
          child: Container(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0x0003050F), ink], stops: [0, .4])),
            child: Cta('Criar produto', () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => CreatePage(onPublish: (p) => setState(() { prods.add(p); sel = null; }))));
            }),
          ),
        ),
      ])),
    );
  }

  Widget productRow(Product p, double all) {
    final hot = qty(p) > 0, selected = sel == p;
    return InkWell(
      onTap: () => setState(() => sel = selected ? null : p),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
        child: Row(children: [
          Container(
            width: 46, height: 46, alignment: Alignment.center,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(13), gradient: LinearGradient(begin: const Alignment(-.4, -1), end: const Alignment(.4, 1), colors: [p.color, const Color(0xFF050A33)])),
            child: Text(p.name[0], style: disp(18)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: body(15, c: selected ? sky : Colors.white, w: FontWeight.w600)),
              Text(hot ? '${qty(p)} vendas, ${brl(rev(p))}' : 'Sem vendas há $per dias', style: body(13, c: mu)),
              const SizedBox(height: 7),
              ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: all == 0 ? 0 : rev(p) / all, minHeight: 3, backgroundColor: line, color: sky)),
            ]),
          ),
          const SizedBox(width: 12),
          Row(children: [
            Container(width: 7, height: 7, decoration: BoxDecoration(shape: BoxShape.circle, color: hot ? sky : null, border: hot ? null : Border.all(color: mu, width: 1.5))),
            const SizedBox(width: 6),
            Text(hot ? 'Vendendo' : 'Parado', style: body(12.5, c: hot ? ice : mu)),
          ]),
        ]),
      ),
    );
  }
}

class CreatePage extends StatefulWidget {
  final void Function(Product) onPublish;
  const CreatePage({super.key, required this.onPublish});
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final name = TextEditingController(), price = TextEditingController(), desc = TextEditingController();
  final upName = TextEditingController(), upPrice = TextEditingController();
  int step = 1;
  bool guarantee = true, upsell = false, done = false, copied = false;
  Color color = covers[0];

  bool get valid => step != 1 || (name.text.trim().isNotEmpty && parse(price.text) > 0);
  String get link => 'pay.sanitypay.com/${slugify(name.text)}';

  void next() {
    if (step < 3) return setState(() => step++);
    widget.onPublish(Product(name.text.trim(), parse(price.text), color, [0, 0, 0, 0, 0, 0, 0]));
    setState(() => done = true);
  }

  Widget field(String label, TextEditingController c, String hint, {bool big = true, bool money = false}) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: body(13, c: mu)),
          TextField(
            controller: c,
            onChanged: (_) => setState(() {}),
            keyboardType: money ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
            style: big ? disp(28) : body(17),
            cursorColor: sky,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: (big ? disp(28) : body(17)).copyWith(color: const Color(0xFF3C4C8F)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: line, width: 1.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: sky, width: 1.5)),
              contentPadding: const EdgeInsets.only(top: 6, bottom: 8),
            ),
          ),
        ]),
      );

  Widget toggle(String t, String s, bool v, ValueChanged<bool> f) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: line))),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: body(15, w: FontWeight.w600)), Text(s, style: body(13, c: mu))])),
          Switch(value: v, onChanged: f, activeTrackColor: sky, activeColor: Colors.white),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    final title = name.text.isEmpty ? 'Nome do produto' : name.text;
    if (done) {
      return Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.all(22),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(height: 20),
            CoverPreview(title, desc.text.isEmpty ? brl(parse(price.text)) : desc.text, color),
            const SizedBox(height: 22),
            Text('Seu produto está no ar', style: disp(20)),
            const SizedBox(height: 6),
            Text('Mande esse link por onde você vende. Cada compra aparece em Vendas.', style: body(14, c: mu)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0x17D6E2FF), borderRadius: BorderRadius.circular(16)),
              child: Text(link, style: GoogleFonts.bricolageGrotesque(fontSize: 15, fontWeight: FontWeight.w500)),
            ),
            Wrap(spacing: 8, children: ['WhatsApp', 'Instagram', 'Telegram', 'E-mail']
                .map((e) => Chip(label: Text(e, style: body(13, c: ice)), backgroundColor: Colors.transparent, side: const BorderSide(color: line)))
                .toList()),
            const Spacer(),
            Cta(copied ? 'Link copiado' : 'Copiar link', () {
              Clipboard.setData(ClipboardData(text: 'https://$link'));
              setState(() => copied = true);
            }),
            TextButton(onPressed: () => Navigator.pop(context), child: Center(child: Text('Voltar para vendas', style: body(14, c: mu)))),
          ]),
        )),
      );
    }
    return Scaffold(
      body: Shell(Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            GestureDetector(onTap: () => step > 1 ? setState(() => step--) : Navigator.pop(context), child: Text('Voltar', style: body(14, c: mu))),
            Text('Novo produto', style: disp(18)),
            Row(children: List.generate(3, (i) => Container(margin: const EdgeInsets.only(left: 6), width: 22, height: 4, decoration: BoxDecoration(color: i < step ? Colors.white : line, borderRadius: BorderRadius.circular(4))))),
          ]),
        ),
        Expanded(
          child: ListView(padding: const EdgeInsets.all(22), children: [
            CoverPreview(title, brl(parse(price.text)), color),
            const SizedBox(height: 22),
            if (step == 1) ...[
              field('Como se chama o produto?', name, 'Ex.: Curso de edição'),
              field('Quanto custa? (R\$)', price, '0,00', money: true),
            ],
            if (step == 2) ...[
              field('O que a pessoa leva?', desc, 'Ex.: 14 aulas, acesso imediato', big: false),
              Text('Cor da capa', style: body(13, c: mu)),
              const SizedBox(height: 10),
              Row(children: covers.map((c) => GestureDetector(
                    onTap: () => setState(() => color = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12), width: 40, height: 40,
                      decoration: BoxDecoration(color: c, shape: BoxShape.circle, border: Border.all(color: c == color ? Colors.white : Colors.transparent, width: 2)),
                    ),
                  )).toList()),
              const SizedBox(height: 18),
              // TODO: plugar image_picker aqui para a foto virar a capa.
              toggle('Imagem do produto', 'Sua foto ocupa a capa inteira do checkout', false, (_) {}),
            ],
            if (step == 3) ...[
              toggle('Garantia de 7 dias', 'Aparece no checkout e passa confiança', guarantee, (v) => setState(() => guarantee = v)),
              toggle('Oferecer um produto extra', 'Aparece na hora do pagamento, antes do Pix', upsell, (v) => setState(() => upsell = v)),
              if (upsell) ...[
                const SizedBox(height: 16),
                field('Nome do extra', upName, 'Ex.: Pacote de transições', big: false),
                field('Preço do extra (R\$)', upPrice, '29,90', big: false, money: true),
              ],
            ],
          ]),
        ),
        Padding(padding: const EdgeInsets.fromLTRB(22, 0, 22, 18), child: Cta(step == 3 ? 'Publicar produto' : 'Continuar', valid ? next : null)),
      ])),
    );
  }
}
