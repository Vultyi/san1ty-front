// lib/core/security/app_lifecycle_security.dart
import 'package:flutter/material.dart';
import 'secure_storage_service.dart';

/// Gerencia segurança baseada no ciclo de vida do app
class AppLifecycleSecurity extends WidgetsBindingObserver {
  static final AppLifecycleSecurity _instance = AppLifecycleSecurity._internal();

  late Function()? _onAppPaused;
  late Function()? _onAppResumed;

  AppLifecycleSecurity._internal();

  factory AppLifecycleSecurity() {
    return _instance;
  }

  /// Inicializa o monitoramento de ciclo de vida
  void initialize({
    Function()? onAppPaused,
    Function()? onAppResumed,
  }) {
    _onAppPaused = onAppPaused;
    _onAppResumed = onAppResumed;
    WidgetsBinding.instance.addObserver(this);
  }

  /// Remove observador
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        // App foi para background
        _handleAppPaused();
        break;

      case AppLifecycleState.resumed:
        // App voltou para foreground
        _handleAppResumed();
        break;

      case AppLifecycleState.inactive:
        // App está inativo (não totalmente pausado)
        _handleAppInactive();
        break;

      case AppLifecycleState.detached:
        // App será destruído
        _handleAppDetached();
        break;

      case AppLifecycleState.hidden:
        // App foi ocultado
        _handleAppHidden();
        break;
    }
  }

  /// Executado quando app vai para background
  void _handleAppPaused() {
    // Aqui você pode:
    // 1. Limpar dados sensíveis da memória
    // 2. Fazer logout automático após timeout
    // 3. Bloquear o app com biometria
    // 4. Cancelar requisições em andamento

    if (_onAppPaused != null) {
      _onAppPaused!();
    }

    // Exemplo de logout automático após timeout (40 segundos de background)
    _scheduleAutoLogout();
  }

  /// Executado quando app volta ao foreground
  void _handleAppResumed() {
    // Aqui você pode:
    // 1. Validar sessão
    // 2. Verificar se foi feito logout automático
    // 3. Parar auto-logout

    if (_onAppResumed != null) {
      _onAppResumed!();
    }

    _cancelAutoLogout();
  }

  /// Executado quando app fica inativo
  void _handleAppInactive() {
    // Não fazer muito aqui, pois pode aparecer dialogs
  }

  /// Executado quando app será destruído
  void _handleAppDetached() {
    // Limpeza final
    dispose();
  }

  /// Executado quando app foi ocultado (não visível)
  void _handleAppHidden() {
    // Tomar ações para segurança
  }

  /// Agenda logout automático após 30 minutos de inatividade
  void _scheduleAutoLogout() {
    Future.delayed(const Duration(minutes: 30), () async {
      // Faz logout automático
      final storage = SecureStorageService();
      await storage.clearAll();
    });
  }

  /// Cancela logout automático
  void _cancelAutoLogout() {
    // Cancelar timers se necessário
  }
}

/// Mixin para segurança em telas com dados sensíveis
mixin SecureScreenMixin<T extends StatefulWidget> on State<T> {
  late AppLifecycleSecurity _appLifecycleSecurity;

  @override
  void initState() {
    super.initState();
    _appLifecycleSecurity = AppLifecycleSecurity();
  }

  @override
  void dispose() {
    _appLifecycleSecurity.dispose();
    super.dispose();
  }
}