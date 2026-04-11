import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/widgets/support_button.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';

class SupportLoginScreen extends StatefulWidget {
  static const String routeName = '/support-login';

  const SupportLoginScreen({super.key});

  @override
  State<SupportLoginScreen> createState() => _SupportLoginScreenState();
}

class _SupportLoginScreenState extends State<SupportLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _emailController.text.trim().isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _handleLogin() {
    setState(() => _loading = true);

    // Simular delay de autenticação
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() => _loading = false);
        // Navegar para dashboard de suporte
        Navigator.pushReplacementNamed(context, '/support-dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportColors.bgPrimary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 448),
            child: SupportCard(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      gradient: SupportColors.brandGradient,
                      borderRadius: SupportBorderRadius.radiusLg,
                    ),
                    child: const Center(
                      child: Text(
                        'S1',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Subtítulo
                  Text(
                    'Acesso exclusivo para equipe de suporte',
                    style: SupportTypography.bodySm.copyWith(
                      color: SupportColors.textTertiary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Email Input
                  SupportInput(
                    label: 'Email ou ID do suporte',
                    placeholder: 'suporte@s1.com',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 24),
                  // Password Input
                  SupportInput(
                    label: 'Senha',
                    placeholder: '••••••••',
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      onPressed: _togglePasswordVisibility,
                      icon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          key: ValueKey<bool>(_obscurePassword),
                          size: 20,
                          color: SupportColors.textLabel,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Login Button
                  SupportButton(
                    text: 'Entrar',
                    onPressed: _canSubmit ? _handleLogin : null,
                    fullWidth: true,
                    variant: SupportButtonVariant.primary,
                    loading: _loading,
                  ),
                  const SizedBox(height: 16),
                  // Info Text
                  Text(
                    'Sistema de suporte restrito. Apenas pessoal autorizado.',
                    style: SupportTypography.bodyXs.copyWith(
                      color: SupportColors.textDisabled,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
