// Telas de autenticação (design San1ty): login, cadastro e recuperar senha.
// Tokens (disp, body, line, mu, sky, ice, Shell, Cta) vêm de sales_screen.dart.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:estrutura_front_san1ty/screens/extra_screens.dart' show appName, outC, navy;
import 'package:estrutura_front_san1ty/screens/home_shell.dart';
import 'package:estrutura_front_san1ty/screens/sales_screen.dart';

// ---------------- LOGO ----------------
class SanLogo extends StatelessWidget {
  final double size;
  const SanLogo({super.key, this.size = 34});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        CustomPaint(size: Size(size, size), painter: _Mark()),
        SizedBox(width: size * .3),
        Text.rich(const TextSpan(children: [TextSpan(text: 'San'), TextSpan(text: '1', style: TextStyle(color: sky)), TextSpan(text: 'ty')]), style: disp(size * .9)),
      ]);
}

class _Mark extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final w = s.width, h = s.height;
    final shield = Path()
      ..moveTo(w * .5, h * .04)
      ..lineTo(w * .9, h * .18)
      ..lineTo(w * .9, h * .52)
      ..cubicTo(w * .9, h * .78, w * .7, h * .92, w * .5, h * .98)
      ..cubicTo(w * .3, h * .92, w * .1, h * .78, w * .1, h * .52)
      ..lineTo(w * .1, h * .18)
      ..close();
    c.drawPath(
        shield,
        Paint()
          ..shader = const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF6C92FF), Color(0xFF2336D9)]).createShader(Offset.zero & s));
    c.drawPath(
        Path()
          ..moveTo(w * .36, h * .40)
          ..lineTo(w * .53, h * .29)
          ..lineTo(w * .53, h * .70),
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * .11
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
  }

  @override
  bool shouldRepaint(_Mark o) => false;
}

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

// ---------------- LOGIN ----------------
class LoginPage extends StatefulWidget {
  static const String routeName = '/auth/login';

  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final id = TextEditingController(), pw = TextEditingController();
  String _version = 'v1.0.0';
  bool get valid => id.text.trim().length >= 3 && pw.text.length >= 6;

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

  void enter() => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AppShell())); // TODO: autenticar na API

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 0),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const SanLogo(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: line)), // TODO: seletor de idioma
                child: Row(children: [const Icon(Icons.language_rounded, size: 18, color: mu), const SizedBox(width: 6), Text('PT-BR', style: body(13, c: mu, w: FontWeight.w600))]),
              ),
            ]),
          ),
          Expanded(
            child: ListView(padding: const EdgeInsets.fromLTRB(22, 70, 22, 24), children: [
              Text('Acessar conta', style: disp(34)),
              const SizedBox(height: 8),
              Text('Bom te ver de novo.', style: body(15, c: mu)),
              const SizedBox(height: 34),
              AuthField('E-mail ou CPF', id, 'exemplo@email.com', type: TextInputType.emailAddress, onChanged: (_) => setState(() {})),
              AuthField('Senha', pw, '••••••••', secret: true, onChanged: (_) => setState(() {})),
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPage())), child: Text('Esqueci minha senha', style: body(14, c: sky, w: FontWeight.w600))),
              ),
              const SizedBox(height: 28),
              Cta('Entrar', valid ? enter : null),
              const SizedBox(height: 22),
              Row(children: [const Expanded(child: Divider(color: line)), Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('ou', style: body(14, c: mu))), const Expanded(child: Divider(color: line))]),
              const SizedBox(height: 22),
              Ghost('Criar nova conta', () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterPage()))),
            ]),
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
  bool terms = false;

  bool get same => s.text == s2.text;
  bool get valid => n.text.trim().length >= 3 && okMail(e.text) && p.text.replaceAll(RegExp(r'\D'), '').length >= 10 && s.text.length >= 8 && same && terms;

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
                Cta('Criar conta', valid ? () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AppShell()), (_) => false) : null), // TODO: cadastrar na API
              ]),
            ),
          ]),
        )),
      );
}

// ---------------- RECUPERAR SENHA ----------------
class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});
  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  final mail = TextEditingController(), code = TextEditingController(), a = TextEditingController(), b = TextEditingController();
  int step = 1, secs = 0;
  Timer? t;

  @override
  void dispose() {
    t?.cancel();
    for (final c in [mail, code, a, b]) {
      c.dispose();
    }
    super.dispose();
  }

  void startTimer() {
    t?.cancel();
    setState(() => secs = 30);
    t = Timer.periodic(const Duration(seconds: 1), (k) {
      if (secs <= 1) k.cancel();
      setState(() => secs--);
    });
  }

  void rebuild(String _) => setState(() {});

  Widget titleBlock(String h, String s) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(h, style: disp(30)),
        const SizedBox(height: 8),
        Text(s, style: body(15, c: mu)),
        const SizedBox(height: 30),
      ]);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Shell(Padding(
          padding: const EdgeInsets.fromLTRB(22, 14, 22, 18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (step < 4)
              Padding(
                padding: const EdgeInsets.only(bottom: 26),
                child: Row(children: [
                  GestureDetector(onTap: () => step > 1 ? setState(() => step--) : Navigator.pop(context), child: const Icon(Icons.arrow_back_rounded, color: sky)),
                  const Spacer(),
                  for (var i = 1; i <= 3; i++) Container(margin: const EdgeInsets.only(left: 6), width: 22, height: 4, decoration: BoxDecoration(color: i <= step ? Colors.white : line, borderRadius: BorderRadius.circular(4))),
                ]),
              ),
            Expanded(child: [one, two, three, four][step - 1]()),
          ]),
        )),
      );

  Widget one() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleBlock('Esqueceu sua senha?', 'Digite o e-mail da sua conta. Se ele estiver cadastrado, enviamos um código de 6 dígitos.'),
        AuthField('E-mail', mail, 'exemplo@email.com', type: TextInputType.emailAddress, onChanged: rebuild),
        const Spacer(),
        Cta('Enviar código', okMail(mail.text) ? () {
              // TODO: chamar a API que envia o código por e-mail
              setState(() => step = 2);
              startTimer();
            } : null),
      ]);

  Widget two() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleBlock('Confira seu e-mail', 'Enviamos um código para ${mail.text.trim()}. Ele vale por alguns minutos.'),
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
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: line, width: 1.5)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: sky, width: 1.5)),
          ),
        ),
        const SizedBox(height: 18),
        Center(
          child: secs > 0
              ? Text('Reenviar código em 0:${secs.toString().padLeft(2, '0')}', style: body(14, c: mu))
              : GestureDetector(onTap: startTimer, child: Text('Reenviar código', style: body(14, c: sky, w: FontWeight.w600))), // TODO: reenviar na API
        ),
        const Spacer(),
        Cta('Verificar código', code.text.length == 6 ? () => setState(() => step = 3) : null), // TODO: validar o código na API
      ]);

  Widget three() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        titleBlock('Nova senha', 'Escolha uma senha com pelo menos 8 caracteres.'),
        AuthField('Nova senha', a, 'Mínimo de 8 caracteres', secret: true, onChanged: rebuild),
        AuthField('Confirmar nova senha', b, 'Digite novamente', secret: true, error: b.text.isNotEmpty && a.text != b.text ? 'As senhas não são iguais' : null, onChanged: rebuild),
        const Spacer(),
        Cta('Redefinir senha', a.text.length >= 8 && a.text == b.text ? () => setState(() => step = 4) : null), // TODO: salvar a nova senha na API
      ]);

  Widget four() => Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(width: 84, height: 84, decoration: const BoxDecoration(color: Color(0xFF2336D9), shape: BoxShape.circle), child: const Icon(Icons.check_rounded, size: 44)),
        const SizedBox(height: 20),
        Text('Senha redefinida', style: disp(26)),
        const SizedBox(height: 8),
        Text('Agora é só entrar com a nova senha.', style: body(14, c: mu)),
        const SizedBox(height: 28),
        Cta('Entrar', () => Navigator.popUntil(context, (r) => r.isFirst)),
      ]);
}
