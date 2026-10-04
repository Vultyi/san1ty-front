import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/services/auth_service.dart';
import 'package:estrutura_front_san1ty/core/security/device_security_service.dart';
import 'package:estrutura_front_san1ty/core/security/secure_storage_service.dart';
import 'package:estrutura_front_san1ty/screens/home_shell.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _authService = AuthService();
  final _deviceSecurity = DeviceSecurityService();
  final _secureStorage = SecureStorageService();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _biometricLoading = false;
  bool _canUseBiometrics = false;
  bool _hasRefreshToken = false;
  String _versionLabel = '';

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_onFormChanged);
    _passwordController.addListener(_onFormChanged);
    PackageInfo.fromPlatform().then((info) {
      if (!mounted) return;
      setState(() {
        _versionLabel = 'v${info.version} (build ${info.buildNumber})';
      });
    });
    _checkBiometricAvailability();
  }

  /// Biometria só aparece se o aparelho suporta E há refresh guardado.
  Future<void> _checkBiometricAvailability() async {
    final canBio = await _deviceSecurity.canUseBiometrics();
    final refresh = await _secureStorage.getRefreshToken();
    if (!mounted) return;
    setState(() {
      _canUseBiometrics = canBio;
      _hasRefreshToken = refresh != null && refresh.isNotEmpty;
    });
  }

  Future<void> _onBiometricLoginPressed() async {
    if (_biometricLoading) return;
    setState(() => _biometricLoading = true);
    try {
      final response = await _authService.loginWithBiometrics(
        () => _deviceSecurity.authenticate(
          reason: 'Confirme sua identidade para entrar no San1tyPay',
        ),
      );
      if (!mounted) return;
      if (response['success'] == true) {
        Navigator.pushReplacementNamed(context, AppShell.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error'] ?? 'Biometria falhou'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _biometricLoading = false);
    }
  }

  @override
  void dispose() {
    _emailController.removeListener(_onFormChanged);
    _passwordController.removeListener(_onFormChanged);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    return _emailController.text.trim().isNotEmpty && _passwordController.text.isNotEmpty;
  }

  void _onFormChanged() {
    setState(() {});
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _onLoginPressed() async {
    if (!mounted) return;

    FocusScope.of(context).unfocus();

    setState(() => _isLoading = true);

    try {
      final response = await _authService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (response['success'] == true) {
        // Login bem-sucedido - navegar para o dashboard
        Navigator.pushReplacementNamed(context, AppShell.routeName);
      } else {
        // Mostrar erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error'] ?? 'Erro no login'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      debugPrint('LOGIN_ERROR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _onCreateAccountPressed() async {
    Navigator.pushNamed(context, '/signup');
  }

  void _onForgotPasswordPressed() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite seu email primeiro.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await _authService.requestPasswordReset(email);

      if (!mounted) return;

      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email de recuperação enviado!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['error'] ?? 'Erro ao enviar email.'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildContent()),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space24, vertical: Dimensions.space16),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_outlined, size: 28, color: AppColors.blueLight),
              const SizedBox(width: Dimensions.space8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, height: 1.2),
                  children: [
                    TextSpan(text: 'San', style: TextStyle(color: AppColors.textPrimary)),
                    TextSpan(text: '1', style: TextStyle(color: AppColors.blueLight)),
                    TextSpan(text: 'tyPay', style: TextStyle(color: AppColors.textPrimary)),
                  ],
                ),
              ),
            ],
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderNormal, width: 1),
      ),
      child: Row(
        children: const [
          Icon(Icons.language, size: 16, color: AppColors.textLabel),
          SizedBox(width: 6),
          Text('PT-BR', style: TextStyle(color: AppColors.textLabel, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.space24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 448),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Dimensions.space32),
              const Text('Acessar Conta', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimary, height: 1.33)),
              const SizedBox(height: Dimensions.space32),
              _buildTextFieldSection(
                label: 'E-mail ou CPF',
                hintText: 'exemplo@email.com',
                controller: _emailController,
                focusNode: _emailFocusNode,
                obscureText: false,
              ),
              const SizedBox(height: Dimensions.space20),
              _buildTextFieldSection(
                label: 'Senha',
                hintText: '••••••••',
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: _togglePasswordVisibility,
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      key: ValueKey<bool>(_obscurePassword),
                      size: 20,
                      color: AppColors.textLabel,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.space8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _onForgotPasswordPressed,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Esqueci minha senha',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.blueLight, height: 1.43),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.space24),
              _buildPrimaryButton(),
              if (_canUseBiometrics && _hasRefreshToken) ...[
                const SizedBox(height: Dimensions.space16),
                _buildBiometricButton(),
              ],
              const SizedBox(height: Dimensions.space24),
              _buildOrDivider(),
              const SizedBox(height: Dimensions.space24),
              _buildSecondaryButton(),
              const SizedBox(height: Dimensions.space32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldSection({
    required String label,
    required String hintText,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool obscureText,
    Widget? suffixIcon,
  }) {
    final isFocused = focusNode.hasFocus;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textLabel, height: 1.43)),
        const SizedBox(height: Dimensions.space8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isFocused ? AppColors.bluePrimary : AppColors.borderNormal, width: 2),
          ),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary, height: 1.5),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textTertiary, height: 1.5),
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              contentPadding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: isFocused ? AppColors.bluePrimary : AppColors.borderNormal, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.bluePrimary, width: 2),
              ),
              suffixIcon: suffixIcon,
              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: (_canSubmit && !_isLoading) ? _onLoginPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blueDark,
          disabledBackgroundColor: AppColors.blueDark.withAlpha((0.5 * 255).round()),
          foregroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          shadowColor: AppColors.blueShadow,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5)),
      ),
    );
  }

  Widget _buildBiometricButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: _biometricLoading ? null : _onBiometricLoginPressed,
        icon: _biometricLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.fingerprint, size: 22),
        label: const Text(
          'Entrar com biometria',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5),
        ),
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.borderNormal)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('ou', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textTertiary, height: 1.43)),
        ),
        Expanded(child: Container(height: 1, color: AppColors.borderNormal)),
      ],
    );
  }

  Widget _buildSecondaryButton() {
    return SizedBox(
      height: 48,
      child: OutlinedButton(
        onPressed: _onCreateAccountPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.blueLight,
          side: const BorderSide(color: AppColors.bluePrimary, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(vertical: 12),
          backgroundColor: Colors.transparent,
        ),
        child: const Text('Criar Nova Conta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.5)),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      height: 56,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space24, vertical: Dimensions.space16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      child: Center(
        child: Text(
          _versionLabel.isEmpty ? '© 2026 San1tyPay' : '© 2026 San1tyPay  •  $_versionLabel',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textTertiary, height: 1.43),
        ),
      ),
    );
  }
}
