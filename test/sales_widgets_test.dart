import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  testWidgets('CoverPreview mostra titulo e subtitulo', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CoverPreview('Curso X', 'R\$ 50,00', Color(0xFF2336D9)),
        ),
      ),
    );
    expect(find.text('Curso X'), findsOneWidget);
    expect(find.text('R\$ 50,00'), findsOneWidget);
  });

  testWidgets('Cta desabilitado sem onTap', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: Cta('Entrar', null))),
    );
    expect(find.text('Entrar'), findsOneWidget);
    await tester.tap(find.text('Entrar'), warnIfMissed: false);
    await tester.pump();
  });
}
