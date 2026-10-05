import 'package:crypto/crypto.dart';
import 'dart:convert';

/// Serviço de criptografia e hashing para dados sensíveis
/// Implementa best practices de segurança do frontend
class EncryptionService {
  // Private constructor
  EncryptionService._();

  /// Hash SHA-256 para senhas e dados sensíveis
  static String hashSHA256(String text) {
    return sha256.convert(utf8.encode(text)).toString();
  }

  /// Validação de força de senha
  static PasswordStrength validatePasswordStrength(String password) {
    if (password.length < 8) {
      return PasswordStrength.weak;
    }

    bool hasUpperCase = password.contains(RegExp('[A-Z]'));
    bool hasLowerCase = password.contains(RegExp('[a-z]'));
    bool hasDigit = password.contains(RegExp('[0-9]'));
    bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    int strength = 0;
    if (hasUpperCase) strength++;
    if (hasLowerCase) strength++;
    if (hasDigit) strength++;
    if (hasSpecialChar) strength++;

    if (password.length >= 12 && strength == 4) {
      return PasswordStrength.veryStrong;
    } else if (password.length >= 10 && strength >= 3) {
      return PasswordStrength.strong;
    } else if (strength >= 2) {
      return PasswordStrength.moderate;
    } else {
      return PasswordStrength.weak;
    }
  }

  /// Sanitização de entrada para prevenir injeção
  static String sanitizeInput(String input) {
    // Remove caracteres perigosos
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;')
        .trim();
  }

  /// Validação de email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validação de CPF
  static bool isValidCPF(String cpf) {
    // Remove caracteres especiais
    String cleanCpf = cpf.replaceAll(RegExp(r'\D'), '');

    if (cleanCpf.length != 11) return false;

    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cleanCpf)) return false;

    // Calcula primeiro dígito verificador
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(cleanCpf[i]) * (10 - i);
    }
    int mod = sum % 11;
    int firstDigit = mod < 2 ? 0 : 11 - mod;

    if (int.parse(cleanCpf[9]) != firstDigit) return false;

    // Calcula segundo dígito verificador
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(cleanCpf[i]) * (11 - i);
    }
    mod = sum % 11;
    int secondDigit = mod < 2 ? 0 : 11 - mod;

    return int.parse(cleanCpf[10]) == secondDigit;
  }

  /// Masking de dados sensíveis para logs
  static String maskSensitiveData(String data, {int visibleChars = 4}) {
    if (data.length <= visibleChars) return '****';
    return data.substring(0, visibleChars) +
        '*' * (data.length - visibleChars);
  }
}

enum PasswordStrength {
  weak,
  moderate,
  strong,
  veryStrong,
}

extension PasswordStrengthExtension on PasswordStrength {
  String get label {
    switch (this) {
      case PasswordStrength.weak:
        return 'Fraca';
      case PasswordStrength.moderate:
        return 'Moderada';
      case PasswordStrength.strong:
        return 'Forte';
      case PasswordStrength.veryStrong:
        return 'Muito Forte';
    }
  }

  String get color {
    switch (this) {
      case PasswordStrength.weak:
        return '#EF4444'; // red
      case PasswordStrength.moderate:
        return '#FBBF24'; // yellow
      case PasswordStrength.strong:
        return '#3B82F6'; // blue
      case PasswordStrength.veryStrong:
        return '#4ADE80'; // green
    }
  }
}