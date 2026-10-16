// Telas de autenticação (design San1ty): login, cadastro e recuperar senha.
// Tokens (disp, body, line, mu, sky, ice, Shell, Cta) vêm de sales_screen.dart.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:estrutura_front_san1ty/core/i18n_service.dart';
import 'package:estrutura_front_san1ty/screens/extra_screens.dart'
    show appName, outC, navy, SplashPage;
import 'package:estrutura_front_san1ty/screens/home_shell.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';

// ---------------- COMPONENTES ----------------
class AuthField extends StatefulWidget {
  final String label, hint;
  final TextEditingController c;
  final bool secret;
  final TextInputType? type;
  final String? error;
  final ValueChanged<String> onChanged;
  const AuthField(this.label, this.c, this.hint, {super.key, this.secret = false, this.type, this.error, required this.onChanged});
  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool ob = true;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(widget.label, style: body(13, c: mu)),
          TextField(
            controller: widget.c,
            onChanged: widget.onChanged,
            obscureText: widget.secret && ob,
            keyboardType: widget.type,
            cursorColor: sky,
            style: body(17),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: body(16, c: const Color(0xFF3C4C8F)),
              errorText: widget.error,
              errorStyle: body(12.5, c: outC),
              suffixIcon: widget.secret ? IconButton(onPressed: () => setState(() => ob = !ob), icon: Icon(ob ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: mu)) : null,
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: line, width: 1.5)),
              focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: sky, width: 1.5)),
              errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: outC, width: 1.5)),
              focusedErrorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: outC, width: 1.5)),
            ),
          ),
        ]),
      );
}

class Ghost extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const Ghost(this.label, this.onTap, {super.key});
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 17),
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), border: Border.all(color: sky, width: 1.5)),
          child: Text(label, style: disp(17, c: sky)),
        ),
      );
}

bool okMail(String s) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s.trim());

/// Seletor de idioma (PT/ES/EN) com restart do fluxo para aplicar.
Future<void> _pickLanguage(BuildContext context) async {
  const options = [('pt-BR', 'Português'), ('es', 'Español'), ('en', 'English')];
  final current = I18nService.instance.locale.value;
  final chosen = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: const Color(0xFF0B1235),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (code, label) in options)
            ListTile(
              title: Text(label,
                  style: body(16,
                      c: code == current ? sky : Colors.white,
                      w: code == current ? FontWeight.w600 : FontWeight.w400)),
              trailing: code == current
                  ? const Icon(Icons.check_rounded, color: sky)
                  : null,
              onTap: () => Navigator.pop(context, code),
            ),
          const SizedBox(height: 12),
        ],
      ),
    ),
  );
  if (chosen != null && chosen != current && context.mounted) {
    await I18nService.instance.setLocale(chosen);
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashPage()),
      (_) => false,
    );
  }
}

// Wordmark textual San1ty (sem símbolo).
class _San1tyWordmark extends StatelessWidget {
  const _San1tyWordmark();
  @override
  Widget build(BuildContext context) => Text.rich(
        const TextSpan(children: [
          TextSpan(text: 'San', style: TextStyle(color: Colors.white)),
          TextSpan(text: '1', style: TextStyle(color: sky)),
          TextSpan(text: 'ty', style: TextStyle(color: Colors.white)),
        ]),
        style: disp(30),
      );
}

// ---------------- LOGIN ----------------
class LoginPage extends StatefulWidget {
  static const String routeName = '/auth/login';

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id = TextEditingController(), pw = TextEditingController(), tfa = TextEditingController();
  final _auth = AuthService();
  bool _busy = false;
  bool _needs2fa = false;
  String? _error;
  String _version = 'v1.0.0';
  bool get valid => id.text.trim().length >= 3 && pw.text.length >= 6 && !_busy;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() => _version = 'v${info.version} (build ${info.buildNumber})');
    });
  }

  @override
  void dispose() {
    id.dispose();
    pw.dispose();
    tfa.dispose();
    super.dispose();
  }

  Future<void> enter() async {
    if (!valid) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.login(id.text.trim(), pw.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AppShell()));
    } else if (res['needs2fa'] == true) {
      setState(() => _needs2fa = true);
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Não foi possível entrar.');
    }
  }

  Future<void> enterWith2fa() async {
    if (tfa.text.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.login(id.text.trim(), pw.text, twoFactorToken: tfa.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AppShell()));
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Código inválido.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const _San1tyWordmark(),
              GestureDetector(
                onTap: () => _pickLanguage(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: line)),
                  child: Row(children: [
                    const Icon(Icons.language_rounded, size: 18, color: mu),
                    const SizedBox(width: 6),
                    ValueListenableBuilder<String>(
                      valueListenable: I18nService.instance.locale,
                      builder: (_, code, __) => Text(
                        code == 'en' ? 'EN' : code == 'es' ? 'ES' : 'PT-BR',
                        style: body(13, c: mu, w: FontWeight.w600),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tr('app.access_account'), style: disp(34)),
                    const SizedBox(height: 8),
                    Text(tr('app.welcome_back'), style: body(15, c: mu)),
                    const SizedBox(height: 34),
                    AuthField(tr('auth.email_or_cpf'), id, 'exemplo@email.com',
                        type: TextInputType.emailAddress, onChanged: (_) => setState(() {})),
                    AuthField(tr('auth.password'), pw, '••••••••', secret: true, onChanged: (_) => setState(() {})),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () => Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const ForgotPage())),
                          child: Text(tr('auth.forgot_password'),
                              style: body(14, c: sky, w: FontWeight.w600))),
                    ),
                    const SizedBox(height: 28),
                    if (_error != null) ...[
                      Text(_error!, style: body(14, c: outC)),
                      const SizedBox(height: 12),
                    ],
                    if (_needs2fa) ...[
                      AuthField('Código do autenticador', tfa, '••••••',
                          type: TextInputType.number,
                          onChanged: (_) => setState(() {})),
                      const SizedBox(height: 12),
                    ],
                    Cta(_busy ? tr('app.entering') : tr('app.enter'),
                        valid ? (_needs2fa ? enterWith2fa : enter) : null),
                    const SizedBox(height: 22),
                    Row(children: [
                      const Expanded(child: Divider(color: line)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(tr('app.or'), style: body(14, c: mu))),
                      const Expanded(child: Divider(color: line))
                    ]),
                    const SizedBox(height: 22),
                    Ghost(tr('app.create_account'),
                        () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()))),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: line))),
            child: Text('© 2026 $appName  •  $_version', textAlign: TextAlign.center, style: body(12.5, c: mu)),
          ),
        ])),
      );
}

// ---------------- CRIAR CONTA ----------------
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final n = TextEditingController(), e = TextEditingController(), p = TextEditingController(), s = TextEditingController(), s2 = TextEditingController();
  final _auth = AuthService();
  bool terms = false;
  bool _busy = false;
  String? _error;

  bool get same => s.text == s2.text;
  bool get valid =>
      n.text.trim().length >= 3 &&
      okMail(e.text) &&
      p.text.replaceAll(RegExp(r'\D'), '').length >= 10 &&
      s.text.length >= 8 &&
      same &&
      terms &&
      !_busy;

  Future<void> _submit() async {
    if (!valid) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.register(
      email: e.text.trim(),
      password: s.text,
      name: n.text.trim(),
    );
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] != true) {
      setState(() => _error = res['error']?.toString() ?? 'Não foi possível criar a conta.');
      return;
    }
    final code = await _auth.sendEmailCode(e.text.trim());
    if (!mounted) return;
    if (code['success'] != true) {
      setState(() => _error = 'Conta criada, mas o código não chegou. Tente reenviar.');
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyCodePage(email: e.text.trim(), password: s.text),
      ),
    );
  }

  @override
  void dispose() {
    for (final c in [n, e, p, s, s2]) {
      c.dispose();
    }
    super.dispose();
  }

  void rebuild(String _) => setState(() {});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_rounded, color: sky)),
              Expanded(child: Center(child: Text('Criar conta', style: disp(18)))),
              const SizedBox(width: 24),
            ]),
            Expanded(
              child: ListView(padding: const EdgeInsets.only(top: 26, bottom: 24), children: [
                Text(tr('app.welcome'), style: disp(32)),
                const SizedBox(height: 6),
                Text(tr('app.create_sub'), style: body(15, c: mu)),
                const SizedBox(height: 28),
                AuthField(tr('app.full_name'), n, tr('app.type_full_name'), onChanged: rebuild),
                AuthField(tr('app.email'), e, tr('app.type_email'), type: TextInputType.emailAddress, onChanged: rebuild),
                AuthField(tr('app.phone'), p, '(11) 99999-9999', type: TextInputType.phone, onChanged: rebuild),
                AuthField(tr('app.password'), s, tr('app.min8'), secret: true, onChanged: rebuild),
                AuthField(tr('app.confirm_password'), s2, tr('app.type_password_again'), secret: true, error: s2.text.isNotEmpty && !same ? tr('app.passwords_differ') : null, onChanged: rebuild),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() => terms = !terms),
                  child: Row(children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 24, height: 24,
                      decoration: BoxDecoration(color: terms ? sky : null, borderRadius: BorderRadius.circular(7), border: Border.all(color: terms ? sky : mu, width: 1.5)),
                      child: terms ? const Icon(Icons.check_rounded, size: 18, color: navy) : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text.rich(
                        TextSpan(style: body(14, c: mu), children: [
                          TextSpan(text: '${tr('app.accept')} '),
                          TextSpan(text: tr('app.terms'), style: body(14, c: sky).copyWith(decoration: TextDecoration.underline)), // TODO: abrir os termos
                          TextSpan(text: ' ${tr('app.and_the')} '),
                          TextSpan(text: tr('app.privacy'), style: body(14, c: sky).copyWith(decoration: TextDecoration.underline)),
                        ]),
                      ),
                    ),
                  ]),
                ),
                const SizedBox(height: 26),
                if (_error != null) ...[
                  Text(_error!, style: body(14, c: outC)),
                  const SizedBox(height: 12),
                ],
                Cta(_busy ? tr('app.creating') : tr('app.create_account'), valid ? _submit : null),
              ]),
            ),
          ]),
        )),
      );
}

// ---------------- CONFIRMAR CÓDIGO (pós-cadastro) ----------------
class VerifyCodePage extends StatefulWidget {
  final String email;
  final String password;
  const VerifyCodePage({super.key, required this.email, required this.password});
  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final code = TextEditingController();
  final _auth = AuthService();
  bool _busy = false;
  String? _error;
  int _secs = 0;
  Timer? _t;

  @override
  void initState() {
    super.initState();
    _restartTimer();
  }

  @override
  void dispose() {
    _t?.cancel();
    code.dispose();
    super.dispose();
  }

  void _restartTimer() {
    _t?.cancel();
    setState(() => _secs = 30);
    _t = Timer.periodic(const Duration(seconds: 1), (k) {
      if (_secs <= 1) k.cancel();
      if (mounted) setState(() => _secs--);
    });
  }

  Future<void> _resend() async {
    _restartTimer();
    await _auth.sendEmailCode(widget.email);
  }

  Future<void> _confirm() async {
    if (code.text.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final ver = await _auth.verifyEmailCode(widget.email, code.text);
    if (!mounted) return;
    if (ver['success'] != true) {
      setState(() {
        _busy = false;
        _error = ver['error']?.toString() ?? 'Código inválido ou expirado.';
      });
      return;
    }
    final login = await _auth.login(widget.email, widget.password);
    if (!mounted) return;
    setState(() => _busy = false);
    if (login['success'] == true) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false);
    } else {
      setState(() => _error = 'Email confirmado! Entre com sua senha.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_rounded, color: sky)),
            const SizedBox(height: 26),
            Text(tr('app.verify_email_title'), style: disp(30)),
            const SizedBox(height: 8),
            Text('${tr('app.verify_email_sub')} ${widget.email}.',
                style: body(15, c: mu)),
            const SizedBox(height: 24),
            TextField(
              controller: code,
              onChanged: (_) => setState(() {}),
              maxLength: 6,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: sky,
              style: disp(38).copyWith(letterSpacing: 14),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                hintStyle: disp(38, c: const Color(0xFF2C3A82)).copyWith(letterSpacing: 14),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: line, width: 1.5)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: sky, width: 1.5)),
              ),
            ),
            const SizedBox(height: 18),
            if (_error != null) ...[
              Text(_error!, style: body(14, c: outC)),
              const SizedBox(height: 12),
            ],
            Center(
              child: _secs > 0
                  ? Text(tr('app.resend_in') + ' 0:${_secs.toString().padLeft(2, '0')}',
                      style: body(14, c: mu))
                  : GestureDetector(
                      onTap: _resend,
                      child: Text(tr('app.resend'),
                          style: body(14, c: sky, w: FontWeight.w600))),
            ),
            const Spacer(),
            Cta(_busy ? tr('app.verifying') : tr('app.confirm'), code.text.length == 6 && !_busy ? _confirm : null),
          ]),
        )),
      );
}

// ---------------- RECUPERAR SENHA (tela única, código expande abaixo) ----------------
class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});
  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final mail = TextEditingController(), code = TextEditingController(), a = TextEditingController(), b = TextEditingController();
  final _auth = AuthService();
  bool _sent = false, _verified = false, _done = false;
  bool _busy = false;
  String? _error;
  int _secs = 0;
  Timer? t;

  @override
  void dispose() {
    t?.cancel();
    for (final c in [mail, code, a, b]) {
      c.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    t?.cancel();
    setState(() => _secs = 30);
    t = Timer.periodic(const Duration(seconds: 1), (k) {
      if (_secs <= 1) k.cancel();
      if (mounted) setState(() => _secs--);
    });
  }

  Future<void> _sendCode() async {
    if (!okMail(mail.text) || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    await _auth.sendEmailCode(mail.text.trim());
    if (!mounted) return;
    setState(() {
      _busy = false;
      _sent = true;
    });
    _startTimer();
  }

  Future<void> _resendCode() async {
    if (_busy) return;
    await _auth.sendEmailCode(mail.text.trim());
    if (!mounted) return;
    _startTimer();
  }

  Future<void> _goReset() async {
    if (code.text.length != 6 || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.verifyEmailCode(mail.text.trim(), code.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      setState(() => _verified = true);
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Código inválido ou expirado.');
    }
  }

  Future<void> _savePassword() async {
    if (a.text.length < 8 || a.text != b.text || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final res = await _auth.resetPasswordWithCode(mail.text.trim(), code.text, a.text);
    if (!mounted) return;
    setState(() => _busy = false);
    if (res['success'] == true) {
      setState(() => _done = true);
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Não foi possível redefinir.');
    }
  }

  void rebuild(String _) => setState(() {});

  Widget titleBlock(String h, String s) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(h, style: disp(30)),
        const SizedBox(height: 8),
        Text(s, style: body(15, c: mu)),
        const SizedBox(height: 30),
      ]);

  Widget _errorLine() => _error == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(_error!, style: body(14, c: outC)),
        );

  @override
  Widget build(BuildContext context) {
    if (_done) {
      return Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(width: 84, height: 84, decoration: const BoxDecoration(color: Color(0xFF2336D9), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 44)),
            const SizedBox(height: 20),
            Text(tr('app.reset_done'), style: disp(26)),
            const SizedBox(height: 8),
            Text(tr('app.reset_done_sub'), style: body(14, c: mu)),
            const SizedBox(height: 28),
            Cta('Entrar', () => Navigator.popUntil(context, (r) => r.isFirst)),
          ]),
        )),
      );
    }
    return Scaffold(
      body: Shell(ListView(
        padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
        children: [
          Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_rounded, color: sky)),
            const Spacer(),
            Container(margin: const EdgeInsets.only(left: 6), width: 66, height: 4, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4))),
          ]),
          const SizedBox(height: 26),
          titleBlock(tr('app.forgot_title'),
              tr('app.forgot_sub')),
          AuthField(tr('app.email'), mail, 'exemplo@email.com',
              type: TextInputType.emailAddress, onChanged: rebuild),
          const SizedBox(height: 4),
          Cta(_busy && !_sent ? tr('app.sending') : _sent ? tr('app.code_sent') : tr('app.send_code'),
              okMail(mail.text) && !_busy && !_sent ? _sendCode : null),
          if (_sent) ...[
            const SizedBox(height: 24),
            Text(tr('app.type_code'), style: disp(20)),
            const SizedBox(height: 4),
            Text('${tr('app.code_sub')} ${mail.text.trim()}. ${tr('app.code_validity')}',
                style: body(14, c: mu)),
            const SizedBox(height: 12),
            TextField(
              controller: code,
              onChanged: rebuild,
              maxLength: 6,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              cursorColor: sky,
              style: disp(38).copyWith(letterSpacing: 14),
              decoration: InputDecoration(
                counterText: '',
                hintText: '••••••',
                hintStyle: disp(38, c: const Color(0xFF2C3A82)).copyWith(letterSpacing: 14),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: line, width: 1.5)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: sky, width: 1.5)),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: _secs > 0
                  ? Text(tr('app.resend_in') + ' 0:${_secs.toString().padLeft(2, '0')}',
                      style: body(14, c: mu))
                  : GestureDetector(
                      onTap: _resendCode,
                      child: Text(tr('app.resend'),
                          style: body(14, c: sky, w: FontWeight.w600))),
            ),
            const SizedBox(height: 16),
            _errorLine(),
            Cta(_busy ? tr('app.verifying') : tr('app.continue'),
                code.text.length == 6 && !_busy ? _goReset : null),
          ],
          if (_verified) ...[
            const SizedBox(height: 24),
            Text(tr('app.new_password'), style: disp(20)),
            const SizedBox(height: 12),
            AuthField(tr('app.new_password'), a, tr('app.min8'),
                secret: true, onChanged: rebuild),
            AuthField(tr('app.confirm_password'), b, tr('app.type_password_again'),
                secret: true,
                error: b.text.isNotEmpty && a.text != b.text
                    ? 'As senhas não são iguais'
                    : null,
                onChanged: rebuild),
            const SizedBox(height: 8),
            _errorLine(),
            Cta(_busy ? tr('app.saving') : tr('auth.reset_password'),
                a.text.length >= 8 && a.text == b.text && !_busy ? _savePassword : null),
          ],
          const SizedBox(height: 24),
        ],
      )),
    );
  }
}
