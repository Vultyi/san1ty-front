import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

/// Ativação de 2FA (TOTP): mostra QR, confirma código, permite desativar.
class TwoFactorSetupScreen extends StatefulWidget {
  static const String routeName = '/2fa/setup';

  const TwoFactorSetupScreen({super.key});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  final _auth = AuthService();
  final code = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  bool _enabled = false;
  String? _qrB64;
  String? _secret;
  List<String> _backup = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _status();
  }

  @override
  void dispose() {
    code.dispose();
    super.dispose();
  }

  Future<void> _status() async {
    final res = await _auth.twoFaStatus();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _enabled = res['data']?['enabled'] == true;
    });
  }

  Future<void> _begin() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.setup2fa();
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] != true) {
      setState(() => _error = res['error']?.toString() ?? 'Tente de novo.');
      return;
    }
    final data = res['data'] as Map<String, dynamic>? ?? {};
    var qr = (data['qr_code_url'] ?? '').toString();
    if (qr.startsWith('data:image')) qr = qr.split(',').last;
    setState(() {
      _qrB64 = qr.isEmpty ? null : qr;
      _secret = (data['secret'] ?? '').toString();
      final codes = data['backup_codes'];
      _backup = codes is List ? codes.map((e) => e.toString()).toList() : [];
    });
  }

  Future<void> _confirm() async {
    if (code.text.length < 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.verify2fa(code.text.trim());
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      setState(() {
        _enabled = true;
        _qrB64 = null;
      });
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Código inválido.');
    }
  }

  Future<void> _disable() async {
    setState(() => _busy = true);
    await _auth.disable2fa();
    if (!mounted) return;
    setState(() {
      _busy = false;
      _enabled = false;
      _qrB64 = null;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(ListView(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
          children: [
            Row(children: [
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text('Voltar', style: body(14, c: mu))),
              const Spacer(),
              Text('Verificação em 2 etapas', style: disp(18)),
              const Spacer(),
              const SizedBox(width: 40),
            ]),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_enabled)
              _enabledCard()
            else if (_qrB64 == null)
              _introCard()
            else
              _confirmCard(),
          ],
        )),
      );

  Widget _introCard() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Proteja sua conta', style: disp(26)),
        const SizedBox(height: 8),
        Text('Escaneie o QR no app autenticador e confirme com o código.',
            style: body(14, c: mu)),
        const SizedBox(height: 24),
        if (_error != null) ...[
          Text(_error!, style: body(14, c: const Color(0xFFFF9393))),
          const SizedBox(height: 12),
        ],
        Cta(_busy ? 'Gerando...' : 'Ativar 2FA', _busy ? null : _begin),
      ]);

  Widget _confirmCard() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Image.memory(base64Decode(_qrB64!), width: 200, height: 200),
          ),
        ),
        const SizedBox(height: 16),
        if (_secret != null && _secret!.isNotEmpty)
          Center(child: Text('Ou digite: $_secret', style: body(13, c: mu))),
        if (_backup.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Códigos reserva (guarde bem):', style: body(14, c: mu)),
          const SizedBox(height: 8),
          Text(_backup.join('   '), style: body(13, c: mu)),
        ],
        const SizedBox(height: 16),
        TextField(
          controller: code,
          onChanged: (_) => setState(() {}),
          maxLength: 6,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          cursorColor: sky,
          style: disp(32).copyWith(letterSpacing: 10),
          decoration: const InputDecoration(
              counterText: '',
              hintText: '••••••',
              border: UnderlineInputBorder()),
        ),
        const SizedBox(height: 12),
        if (_error != null) ...[
          Text(_error!, style: body(14, c: const Color(0xFFFF9393))),
          const SizedBox(height: 12),
        ],
        Cta(_busy ? 'Verificando...' : 'Confirmar e ativar',
            code.text.length >= 6 && !_busy ? _confirm : null),
      ]);

  Widget _enabledCard() => Column(children: [
        const SizedBox(height: 20),
        const Icon(Icons.check_circle_outline, size: 64, color: sky),
        const SizedBox(height: 16),
        Text('2FA ativo', style: disp(24)),
        const SizedBox(height: 8),
        Text('Sua conta pede o código do autenticador ao entrar.',
            style: body(14, c: mu), textAlign: TextAlign.center),
        const SizedBox(height: 24),
        Cta(_busy ? 'Aguarde...' : 'Desativar', _busy ? null : _disable),
      ]);
}
