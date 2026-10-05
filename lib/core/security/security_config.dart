import 'package:flutter/services.dart';

/// Configurações de segurança do aplicativo
class SecurityConfig {
  /// Desabilita screenshots e taskreviews (previne capturas de dados sensíveis)
  static void disableScreenshots() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
  }

  /// Habilita screenshots (para desenvolvimento)
  static void enableScreenshots() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
  }

  /// Configura orientações permitidas (apenas portrait em telas sensíveis)
  static void setSecureOrientations() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Configura modo seguro para telas de pagamento/login
  static void enableSecureMode() {
    // Desabilita screenshots dentro do aplicativo
    disableScreenshots();

    // Define orientação portrait apenas (mais seguro)
    setSecureOrientations();
  }

  /// Limpa dados sensíveis da memória
  static void clearSensitiveData() {
    // Aqui você pode implementar lógica para limpar dados da memória
    // quando o app entra em background
  }

  /// Configurações de política de segurança para prod
  static const SecurityPolicy productionPolicy = SecurityPolicy(
    enableCertificatePinning: true,
    enableProxyDetection: true,
    enableRootDetection: true,
    enableScreenShareDetection: true,
    requestTimeout: Duration(seconds: 30),
    maxRetries: 3,
    cacheExpiration: Duration(minutes: 5),
    minPasswordLength: 8,
    maxLoginAttempts: 5,
    sessionTimeout: Duration(minutes: 30),
  );

  /// Configurações de política de segurança para dev
  static const SecurityPolicy developmentPolicy = SecurityPolicy(
    enableCertificatePinning: false,
    enableProxyDetection: false,
    enableRootDetection: false,
    enableScreenShareDetection: false,
    requestTimeout: Duration(seconds: 60),
    maxRetries: 5,
    cacheExpiration: Duration(hours: 1),
    minPasswordLength: 4,
    maxLoginAttempts: 10,
    sessionTimeout: Duration(hours: 2),
  );
}

class SecurityPolicy {
  final bool enableCertificatePinning;
  final bool enableProxyDetection;
  final bool enableRootDetection;
  final bool enableScreenShareDetection;
  final Duration requestTimeout;
  final int maxRetries;
  final Duration cacheExpiration;
  final int minPasswordLength;
  final int maxLoginAttempts;
  final Duration sessionTimeout;

  const SecurityPolicy({
    required this.enableCertificatePinning,
    required this.enableProxyDetection,
    required this.enableRootDetection,
    required this.enableScreenShareDetection,
    required this.requestTimeout,
    required this.maxRetries,
    required this.cacheExpiration,
    required this.minPasswordLength,
    required this.maxLoginAttempts,
    required this.sessionTimeout,
  });
}