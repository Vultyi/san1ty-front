// Telas de autenticação (design San1ty): login, cadastro e recuperar senha.
// Tokens (disp, body, line, mu, sky, ice, Shell, Cta) vêm de sales_screen.dart.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:estrutura_front_san1ty/screens/extra_screens.dart' show appName, outC, navy;
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
  final id = TextEditingController(), pw = TextEditingController();
  final _auth = AuthService();
  bool _busy = false;
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
    } else {
      setState(() => _error = res['error']?.toString() ?? 'Não foi possível entrar.');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const _San1tyWordmark(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: line)), // TODO: seletor de idioma
                child: Row(children: [const Icon(Icons.language_rounded, size: 18, color: mu), const SizedBox(width: 6), Text('PT-BR', style: body(13, c: mu, w: FontWeight.w600))]),
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
                    Text('Acessar conta', style: disp(34)),
                    const SizedBox(height: 8),
                    Text('Bom te ver de novo.', style: body(15, c: mu)),
                    const SizedBox(height: 34),
                    AuthField('E-mail ou CPF', id, 'exemplo@email.com',
                        type: TextInputType.emailAddress, onChanged: (_) => setState(() {})),
                    AuthField('Senha', pw, '••••••••', secret: true, onChanged: (_) => setState(() {})),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                          onTap: () => Navigator.push(
                              context, MaterialPageRoute(builder: (_) => const ForgotPage())),
                          child: Text('Esqueci minha senha',
                              style: body(14, c: sky, w: FontWeight.w600))),
                    ),
                    const SizedBox(height: 28),
                    if (_error != null) ...[
                      Text(_error!, style: body(14, c: outC)),
                      const SizedBox(height: 12),
                    ],
                    Cta(_busy ? 'Entrando...' : 'Entrar', valid ? enter : null),
                    const SizedBox(height: 22),
                    Row(children: [
                      const Expanded(child: Divider(color: line)),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text('ou', style: body(14, c: mu))),
                      const Expanded(child: Divider(color: line))
                    ]),
                    const SizedBox(height: 22),
                    Ghost('Criar nova conta',
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
                Text('Bem-vindo!', style: disp(32)),
                const SizedBox(height: 6),
                Text('Crie sua conta para começar.', style: body(15, c: mu)),
                const SizedBox(height: 28),
                AuthField('Nome completo', n, 'Digite seu nome completo', onChanged: rebuild),
                AuthField('E-mail', e, 'Digite seu e-mail', type: TextInputType.emailAddress, onChanged: rebuild),
                AuthField('Telefone', p, '(11) 99999-9999', type: TextInputType.phone, onChanged: rebuild),
                AuthField('Senha', s, 'Mínimo de 8 caracteres', secret: true, onChanged: rebuild),
                AuthField('Confirmar senha', s2, 'Digite novamente sua senha', secret: true, error: s2.text.isNotEmpty && !same ? 'As senhas não são iguais' : null, onChanged: rebuild),
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
                          const TextSpan(text: 'Aceito os '),
                          TextSpan(text: 'Termos de Uso', style: body(14, c: sky).copyWith(decoration: TextDecoration.underline)), // TODO: abrir os termos
                          const TextSpan(text: ' e a '),
                          TextSpan(text: 'Política de Privacidade', style: body(14, c: sky).copyWith(decoration: TextDecoration.underline)),
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
                Cta(_busy ? 'Criando...' : 'Criar conta', valid ? _submit : null),
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
            Text('Confira seu e-mail', style: disp(30)),
            const SizedBox(height: 8),
            Text('Enviamos um código de 6 dígitos para ${widget.email}.',
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
                  ? Text('Reenviar código em 0:${_secs.toString().padLeft(2, '0')}',
                      style: body(14, c: mu))
                  : GestureDetector(
                      onTap: _resend,
                      child: Text('Reenviar código',
                          style: body(14, c: sky, w: FontWeight.w600))),
            ),
            const Spacer(),
            Cta(_busy ? 'Verificando...' : 'Confirmar', code.text.length == 6 && !_busy ? _confirm : null),
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
            Text('Senha redefinida', style: disp(26)),
            const SizedBox(height: 8),
            Text('Agora é só entrar com a nova senha.', style: body(14, c: mu)),
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
          titleBlock('Esqueceu sua senha?',
              'Digite o e-mail da conta. O código de 6 dígitos aparece logo abaixo.'),
          AuthField('E-mail', mail, 'exemplo@email.com',
              type: TextInputType.emailAddress, onChanged: rebuild),
          const SizedBox(height: 4),
          Cta(_busy && !_sent ? 'Enviando...' : _sent ? 'Código enviado ✓' : 'Enviar código',
              okMail(mail.text) && !_busy && !_sent ? _sendCode : null),
          if (_sent) ...[
            const SizedBox(height: 24),
            Text('Digite o código', style: disp(20)),
            const SizedBox(height: 4),
            Text('Enviamos para ${mail.text.trim()}. Vale por 15 minutos.',
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
                  ? Text('Reenviar código em 0:${_secs.toString().padLeft(2, '0')}',
                      style: body(14, c: mu))
                  : GestureDetector(
                      onTap: _resendCode,
                      child: Text('Reenviar código',
                          style: body(14, c: sky, w: FontWeight.w600))),
            ),
            const SizedBox(height: 16),
            _errorLine(),
            Cta(_busy ? 'Verificando...' : 'Continuar',
                code.text.length == 6 && !_busy ? _goReset : null),
          ],
          if (_verified) ...[
            const SizedBox(height: 24),
            Text('Nova senha', style: disp(20)),
            const SizedBox(height: 12),
            AuthField('Nova senha', a, 'Mínimo de 8 caracteres',
                secret: true, onChanged: rebuild),
            AuthField('Confirmar nova senha', b, 'Digite novamente',
                secret: true,
                error: b.text.isNotEmpty && a.text != b.text
                    ? 'As senhas não são iguais'
                    : null,
                onChanged: rebuild),
            const SizedBox(height: 8),
            _errorLine(),
            Cta(_busy ? 'Salvando...' : 'Redefinir senha',
                a.text.length >= 8 && a.text == b.text && !_busy ? _savePassword : null),
          ],
          const SizedBox(height: 24),
        ],
      )),
    );
  }
}
