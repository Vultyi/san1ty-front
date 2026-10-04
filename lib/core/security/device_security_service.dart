// lib/core/security/device_security_service.dart
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
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
  Future<bool> checkDeviceIntegrity() async {
    if (_allowRooted) return true;
    try {
      final jailbroken = await FlutterJailbreakDetection.jailbroken;
      if (jailbroken) return false;
      final devMode = await FlutterJailbreakDetection.developerMode;
      // Modo desenvolvedor sozinho não bloqueia (comum em dev), só registra.
      return true;
    } on PlatformException {
      // Plugin indisponível (desktop/teste): não bloqueia fora do mobile.
      return true;
    } catch (_) {
      return false;
    }
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
  Future<void> secureScreenOn() async {
    try {
      await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (_) {}
  }

  /// Desliga (chamar no dispose).
  Future<void> secureScreenOff() async {
    try {
      await FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
    } catch (_) {}
  }
}
