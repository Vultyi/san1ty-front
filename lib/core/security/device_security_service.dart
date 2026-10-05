import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
// REMOVIDO TEMPORÁRIO (build): flutter_jailbreak_detection 1.10.0 e
// flutter_windowmanager 0.2.0 não declaram `namespace` e quebram o AGP 8+.
// Reativar via fork com namespace antes de vender. Até lá: sem root-block
// e sem FLAG_SECURE (fail-open documentado, só em dev/teste).
import 'package:local_auth/local_auth.dart';

/// Segurança do dispositivo (LGPD art. 46 — barreiras no endpoint).
///
/// - Integridade: root/jailbreak bloqueia o boot (fail-closed).
/// - Biometria: gate para reentrada via refresh token.
/// - FLAG_SECURE: anti-screenshot em telas com PIX/chaves/saldo.
class DeviceSecurityService {
  static final DeviceSecurityService _instance =
      DeviceSecurityService._internal();
  DeviceSecurityService._internal();
  factory DeviceSecurityService() => _instance;

  final LocalAuthentication _biometrics = LocalAuthentication();

  /// Bypass explícito p/ emulador de dev:
  /// `flutter run --dart-define=ALLOW_ROOTED=true`.
  static const bool _allowRooted =
      bool.fromEnvironment('ALLOW_ROOTED', defaultValue: false);

  /// true = dispositivo íntegro (ou bypass de dev). false = bloquear.
  /// TEMPORÁRIO: plugin de root removido (sem namespace) — sempre true até
  /// o fork. Não usar como garantia em produção.
  Future<bool> checkDeviceIntegrity() async {
    if (_allowRooted) return true;
    debugPrint('device: root-check desativado (plugin sem namespace) — fail-open temporário');
    return true;
  }

  /// Biometria disponível e com credencial cadastrada?
  Future<bool> canUseBiometrics() async {
    try {
      return await _biometrics.canCheckBiometrics &&
          await _biometrics.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  /// Prompt biométrico. false = falhou/cancelou (não entra).
  Future<bool> authenticate({String reason = 'Confirme sua identidade'}) async {
    try {
      return await _biometrics.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  /// Liga anti-screenshot (chamar no initState de telas sensíveis).
  /// TEMPORÁRIO: sem plugin (sem namespace) — no-op até o fork.
  Future<void> secureScreenOn() async {
    debugPrint('device: FLAG_SECURE desativado (plugin sem namespace)');
  }

  /// Desliga (chamar no dispose).
  Future<void> secureScreenOff() async {}
}
