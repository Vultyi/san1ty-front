import 'package:flutter_test/flutter_test.dart';
import 'package:estrutura_front_san1ty/core/utils/format.dart';

void main() {
  group('formatBrlCents', () {
    test('zero e centavos', () {
      expect(formatBrlCents(0), 'R\$ 0,00');
      expect(formatBrlCents(5), 'R\$ 0,05');
      expect(formatBrlCents(50), 'R\$ 0,50');
    });
    test('milhar com ponto', () {
      expect(formatBrlCents(5000), 'R\$ 50,00');
      expect(formatBrlCents(135698), 'R\$ 1.356,98');
      expect(formatBrlCents(500000), 'R\$ 5.000,00');
    });
  });

  group('formatBrl', () {
    test('reais com decimais', () {
      expect(formatBrl(50.0), 'R\$ 50,00');
      expect(formatBrl(1356.98), 'R\$ 1.356,98');
    });
  });

  group('parseBrl', () {
    test('formatos BR', () {
      expect(parseBrl('R\$ 1.356,98'), 1356.98);
      expect(parseBrl('5.000'), 5000.0);
      expect(parseBrl('0,00'), 0.0);
      expect(parseBrl('abc'), 0.0);
      expect(parseBrl(''), 0.0);
    });
  });

  group('slugify', () {
    test('acentos e simbolos', () {
      expect(slugify('Curso de edição'), 'curso-de-edicao');
      expect(slugify('  Pack!! '), 'pack');
      expect(slugify('Mentoria 1:1'), 'mentoria-1-1');
    });
  });

  group('okMail', () {
    test('validos e invalidos', () {
      expect(okMail('a@b.com'), isTrue);
      expect(okMail('a@b'), isFalse);
      expect(okMail('sem-arroba'), isFalse);
      expect(okMail(''), isFalse);
      expect(okMail('  a@b.com  '), isTrue);
    });
  });
}
