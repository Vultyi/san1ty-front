// lib/screens/admin_login_screen.dart
import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_input.dart';
import '../widgets/admin_card.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual login API call
    await Future.delayed(const Duration(seconds: 2)); // Mock delay

    setState(() => _isLoading = false);

    // Navigate to dashboard on success
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/admin/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AdminDimensions.spacingBase),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: AdminDimensions.spacing2XL),
                // Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: AdminColors.brandGradient,
                    borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusLG),
                  ),
                  child: Center(
                    child: Text(
                      'S1',
                      style: AdminTextStyles.displayLarge.copyWith(
                        color: AdminColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AdminDimensions.spacingLG),
                // Title
                Text(
                  'San1ty Pay Admin',
                  style: AdminTextStyles.headingLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AdminDimensions.spacingSM),
                Text(
                  'Entre com suas credenciais de administrador',
                  style: AdminTextStyles.bodyBase.copyWith(
                    color: AdminColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AdminDimensions.spacing2XL),
                // Login Form
                AdminCard(
                  padding: EdgeInsets.all(AdminDimensions.spacingLG),
                  child: Column(
                    children: [
                      AdminInput(
                        label: 'Email',
                        placeholder: 'admin@san1typay.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email é obrigatório';
                          }
                          if (!value.contains('@')) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AdminDimensions.spacingLG),
                      AdminInput(
                        label: 'Senha',
                        placeholder: 'Digite sua senha',
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Senha é obrigatória';
                          }
                          if (value.length < 6) {
                            return 'Senha deve ter pelo menos 6 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AdminDimensions.spacingLG),
                      AdminButton(
                        text: 'Entrar',
                        onPressed: _handleLogin,
                        loading: _isLoading,
                        fullWidth: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AdminDimensions.spacingLG),
                // Forgot Password
                TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: AdminTextStyles.bodyBase.copyWith(
                      color: AdminColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}