// lib/core/security/security_validator.dart
import 'encryption_service.dart';

/// Validador de segurança para o aplicativo
class SecurityValidator {
  /// Valida entrada de formulário contra injeção
  static bool validateFormInput(String input, {int maxLength = 255}) {
    if (input.isEmpty || input.length > maxLength) {
      return false;
    }

    // Detecta padrões de injeção SQL comum
    final sqlKeywords = [
      'drop', 'delete', 'insert', 'update', 'select', 'exec', 'execute',
      'union', 'or', 'and', 'xor', '--', '/*', '*/'
    ];

    final lowerInput = input.toLowerCase();
    for (final keyword in sqlKeywords) {
      if (lowerInput.contains(keyword)) {
        return false;
      }
    }

    return true;
  }

  /// Valida URL para prevenir open redirect
  static bool isValidSecureUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Aceita apenas HTTPS
      if (uri.scheme != 'https' && uri.scheme != 'http') {
        return false;
      }

      // Whitelist de domínios permitidos
      const allowedDomains = [
        'san1typay.com',
        'api.san1typay.com',
        'admin.san1typay.com',
      ];

      return allowedDomains
          .any((domain) => uri.host.contains(domain));
    } catch (e) {
      return false;
    }
  }

  /// Valida força de PIN (números)
  static bool isValidPIN(String pin) {
    if (pin.length != 4 && pin.length != 6) {
      return false;
    }

    // Verifica se contém apenas números
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      return false;
    }

    // Não permite sequências óbvias
    if (RegExp(r'^(\d)\1+$').hasMatch(pin)) {
      return false; // 1111 or 666666
    }

    if (RegExp(r'^(0123|1234|2345|3456|4567|5678|6789)').hasMatch(pin)) {
      return false; // Sequências
    }

    return true;
  }

  /// Valida dados de pagamento (validação básica de cartão)
  static bool isValidCardNumber(String cardNumber) {
    // Remove espaços
    final cleanNumber = cardNumber.replaceAll(RegExp(r'\s'), '');

    // Verifica comprimento (13-19 dígitos)
    if (cleanNumber.length < 13 || cleanNumber.length > 19) {
      return false;
    }

    // Verifica se contém apenas números
    if (!RegExp(r'^\d+$').hasMatch(cleanNumber)) {
      return false;
    }

    // Algoritmo de Luhn para validação de cartão
    return _luhnCheck(cleanNumber);
  }

  /// Implementa algoritmo de Luhn
  static bool _luhnCheck(String cardNo) {
    int sum = 0;
    int alternate = 0;

    for (int i = cardNo.length - 1; i >= 0; i--) {
      int n = int.parse(cardNo[i]);

      if (alternate == 1) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }

      sum += n;
      alternate ^= 1;
    }

    return (sum % 10) == 0;
  }

  /// Valida data de expiração do cartão
  static bool isValidCardExpiry(String expiry) {
    final parts = expiry.split('/');
    if (parts.length != 2) {
      return false;
    }

    try {
      final month = int.parse(parts[0]);
      final year = int.parse(parts[1]);

      if (month < 1 || month > 12) {
        return false;
      }

      final now = DateTime.now();
      final expiryDate = DateTime(2000 + year, month);

      return expiryDate.isAfter(now);
    } catch (e) {
      return false;
    }
  }

  /// Valida CVV
  static bool isValidCVV(String cvv) {
    return RegExp(r'^\d{3,4}$').hasMatch(cvv);
  }

  /// Detecta comportamento suspeito
  static bool detectSuspiciousBehavior({
    required int failedAttempts,
    required DateTime lastAttempt,
    int maxFailedAttempts = 5,
    Duration lockoutDuration = const Duration(minutes: 15),
  }) {
    if (failedAttempts >= maxFailedAttempts) {
      final now = DateTime.now();
      final difference = now.difference(lastAttempt);

      if (difference.inMinutes < lockoutDuration.inMinutes) {
        return true; // Comportamento suspeito detectado
      }
    }

    return false;
  }
}