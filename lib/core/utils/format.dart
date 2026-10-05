/// Formatação BRL + slug (lógica pura, testável sem Flutter).
String formatBrlCents(int cents) {
  final reais = (cents ~/ 100).toString();
  final buffer = StringBuffer();
  for (var i = 0; i < reais.length; i++) {
    if (i > 0 && (reais.length - i) % 3 == 0) buffer.write('.');
    buffer.write(reais[i]);
  }
  final centavos = (cents % 100).toString().padLeft(2, '0');
  return 'R\$ $buffer,$centavos';
}

String formatBrl(double v) {
  final f = v.toStringAsFixed(2).split('.');
  final i = f[0].replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.');
  return 'R\$ $i,${f[1]}';
}

double parseBrl(String s) {
  final cleaned = s.replaceAll(RegExp(r'[^0-9,.\-]'), '');
  if (cleaned.isEmpty) return 0;
  return double.tryParse(cleaned.replaceAll('.', '').replaceAll(',', '.')) ?? 0;
}

String slugify(String s) {
  const a = 'áàâãäéèêëíìîïóòôõöúùûüç', b = 'aaaaaeeeeiiiiooooouuuuc';
  var t = s.toLowerCase();
  for (var i = 0; i < a.length; i++) {
    t = t.replaceAll(a[i], b[i]);
  }
  return t.replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-|-$'), '');
}

bool okMail(String s) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s.trim());
