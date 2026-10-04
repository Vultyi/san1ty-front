import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/core/update/update_service.dart';
import 'package:estrutura_front_san1ty/core/security/device_security_service.dart';
import 'package:estrutura_front_san1ty/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UpdateService _updates = UpdateService();
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    // Integridade primeiro: root/jailbreak não entra (fail-closed).
    final deviceSecurity = DeviceSecurityService();
    final integrityOk = await deviceSecurity.checkDeviceIntegrity();
    if (!mounted || _navigated) return;
    if (!integrityOk) {
      _showBlockedDialog();
      return;
    }
    // Tempo mínimo de splash + checagem de update em paralelo.
    // Falhas de rede/API resultam em null e seguem para o login.
    final results = await Future.wait([
      Future.delayed(const Duration(milliseconds: 1400)),
      _updates.checkForUpdate(),
    ]);
    if (!mounted || _navigated) return;
    final info = results[1] as UpdateInfo?;
    if (info == null) {
      _goToLogin();
      return;
    }
    final wantsUpdate = await _askUpdate(info);
    if (!mounted || _navigated) return;
    if (wantsUpdate != true) {
      _goToLogin();
      return;
    }
    await _runUpdate(info);
    if (!mounted || _navigated) return;
    _goToLogin();
  }

  void _goToLogin() {
    if (!mounted || _navigated) return;
    _navigated = true;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  /// Bloqueio por dispositivo comprometido: sem botão de continuar.
  void _showBlockedDialog() {
    if (!mounted || _navigated) return;
    _navigated = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Dispositivo não seguro'),
        content: const Text(
          'Este aparelho tem root/jailbreak ativo. Por segurança, '
          'o San1tyPay não pode ser usado aqui.',
        ),
        actions: const [],
      ),
    );
  }

  Future<bool?> _askUpdate(UpdateInfo info) {
    if (!mounted) return Future.value(false);
    // ignore: use_build_context_synchronously — chamador verifica mounted antes.
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        title: const Text('Atualização disponível'),
        content: Text(
          'Nova versão ${info.tag} encontrada. Deseja baixar e instalar agora?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Depois'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Atualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _runUpdate(UpdateInfo info) async {
    int progress = 0;
    String status = 'Baixando atualização...';
    if (!mounted) return;
    // ignore: use_build_context_synchronously — verificado mounted acima.
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialog) {
          StreamSubscription<OtaEvent>? sub;
          sub = _updates.downloadAndInstall(info).listen(
            (event) {
              if (!mounted) return;
              setDialog(() {
                if (event.status == OtaStatus.DOWNLOADING) {
                  final v = int.tryParse(event.value ?? '');
                  if (v != null) progress = v.clamp(0, 100);
                  status = 'Baixando... $progress%';
                } else if (event.status == OtaStatus.INSTALLING) {
                  status = 'Abrindo instalador...';
                  progress = 100;
                } else if (event.status == OtaStatus.PERMISSION_NOT_GRANTED_ERROR ||
                    event.status == OtaStatus.DOWNLOAD_ERROR ||
                    event.status == OtaStatus.CHECKSUM_ERROR ||
                    event.status == OtaStatus.INTERNAL_ERROR) {
                  status = 'Falha na atualização. Use o app atual.';
                }
              });
              final s = event.status;
              if (s == OtaStatus.INSTALLING ||
                  s == OtaStatus.PERMISSION_NOT_GRANTED_ERROR ||
                  s == OtaStatus.DOWNLOAD_ERROR ||
                  s == OtaStatus.CHECKSUM_ERROR ||
                  s == OtaStatus.INTERNAL_ERROR ||
                  s == OtaStatus.ALREADY_RUNNING_ERROR) {
                // Instalador do Android assume daqui; fecha o diálogo.
                Future.delayed(const Duration(milliseconds: 800), () {
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                });
                sub?.cancel();
              }
            },
            onError: (_) {
              if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
            },
          );

          return AlertDialog(
            title: const Text('Atualizando app'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LinearProgressIndicator(
                  value: progress == 0 ? null : progress / 100,
                ),
                const SizedBox(height: 12),
                Text(status),
                const SizedBox(height: 8),
                const Text(
                  'O Android vai pedir confirmação para instalar. '
                  'Se falhar, siga usando esta versão.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  try {
                    OtaUpdate().cancel();
                  } catch (_) {}
                  if (Navigator.of(ctx).canPop()) Navigator.of(ctx).pop();
                },
                child: const Text('Cancelar'),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: Dimensions.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              const Icon(Icons.shield_outlined, size: 72, color: AppColors.blueLight),
              const SizedBox(height: Dimensions.space24),
              Text('San1ty Pay', style: AppTextStyles.logoStyle.copyWith(fontSize: 34)),
              const SizedBox(height: Dimensions.space12),
              Text(
                'Bem-vindo ao seu painel financeiro digital',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              const SizedBox(height: Dimensions.space24),
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.blueLight),
                ),
              ),
              const SizedBox(height: Dimensions.space16),
              Text('Carregando o dashboard...', style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary)),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
