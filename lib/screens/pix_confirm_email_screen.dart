import 'dart:async';

import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';

class PixConfirmEmailScreen extends StatefulWidget {
  static const String routeName = '/pix/confirm-email';

  const PixConfirmEmailScreen({super.key});

  @override
  State<PixConfirmEmailScreen> createState() => _PixConfirmEmailScreenState();
}

class _PixConfirmEmailScreenState extends State<PixConfirmEmailScreen> {
  final List<TextEditingController> _codeControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  late Timer _resendTimer;
  int _secondsRemaining = 60;
  bool _canResend = false;
  String _email = '';

  String get _formattedCode => _codeControllers.map((c) => c.text).join();

  bool get _isComplete => _formattedCode.length == 6;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Pegar email dos argumentos da rota
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args.containsKey('email')) {
        setState(() => _email = args['email']);
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _codeControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    _resendTimer.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _secondsRemaining = 60;
    _canResend = false;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining--;
        if (_secondsRemaining <= 0) {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleCodeChange(int index, String value) {
    if (value.isNotEmpty && value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _handleCodeBackspace(int index, String value) {
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _resendCode() {
    if (!_canResend) return;

    // Simular reenvio do código
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Código reenviado!'),
        backgroundColor: AppColors.successGreen,
        duration: const Duration(seconds: 2),
      ),
    );

    _startResendTimer();
  }

  void _confirmEmail() {
    if (!_isComplete) return;

    // Simular verificação do código
    const correctCode = '123456'; // Código fixo para demo
    if (_formattedCode == correctCode) {
      _showSuccessDialog();
    } else {
      _showErrorDialog();
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.successGreen, size: 24),
            const SizedBox(width: 12),
            const Text(
              'E-mail confirmado!',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Sua chave PIX foi cadastrada com sucesso.',
          style: TextStyle(color: AppColors.textLabel, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Fechar dialog
              Navigator.of(context).popUntil((route) => route.settings.name == '/pix/manage-keys'); // Voltar para gerenciar chaves
            },
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.actionPrimary),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.error, color: AppColors.errorRed, size: 24),
            const SizedBox(width: 12),
            const Text(
              'Código incorreto',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'O código digitado está incorreto. Tente novamente.',
          style: TextStyle(color: AppColors.textLabel, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.actionPrimary),
            ),
          ),
        ],
      ),
    );

    // Limpar campos após erro
    for (final controller in _codeControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    _buildIcon(),
                    const SizedBox(height: Dimensions.space32),
                    _buildTitleAndSubtitle(),
                    const SizedBox(height: Dimensions.space32),
                    _buildCodeFields(),
                    const SizedBox(height: Dimensions.space24),
                    _buildResendSection(),
                    const SizedBox(height: Dimensions.space32),
                    _buildConfirmButton(),
                    const SizedBox(height: Dimensions.space24),
                    _buildHelperText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.borderDefault, width: 1),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: AppColors.actionPrimary),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: const Color(0xFF333333)),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.email,
        size: 40,
        color: AppColors.actionPrimary,
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Confirme seu e-mail',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: Dimensions.space12),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(color: AppColors.textLabel, fontSize: 14),
            children: [
              const TextSpan(text: 'Enviamos um código de 6 dígitos para\n'),
              TextSpan(
                text: _email,
                style: const TextStyle(color: AppColors.actionPrimary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        6,
        (index) => Container(
          width: 48,
          height: 56,
          margin: EdgeInsets.only(right: index < 5 ? 12 : 0),
          child: TextField(
            controller: _codeControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.backgroundSecondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.borderNormal, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.actionPrimary, width: 2),
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
            onChanged: (value) => _handleCodeChange(index, value),
          ),
        ),
      ),
    );
  }

  Widget _buildResendSection() {
    return Center(
      child: _canResend
          ? TextButton(
              onPressed: _resendCode,
              child: const Text(
                'Reenviar código',
                style: TextStyle(
                  color: AppColors.actionPrimary,
                  fontSize: 14,
                ),
              ),
            )
          : Text(
              'Reenviar código em ${_secondsRemaining}s',
              style: const TextStyle(
                color: AppColors.textLabel,
                fontSize: 14,
              ),
            ),
    );
  }

  Widget _buildConfirmButton() {
    return ElevatedButton(
      onPressed: _isComplete ? _confirmEmail : null,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: AppColors.actionPrimary,
        disabledBackgroundColor: AppColors.actionPrimary.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        shadowColor: AppColors.actionPrimary.withOpacity(0.3),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.check, size: 20),
          const SizedBox(width: 8),
          const Text('Confirmar e-mail', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildHelperText() {
    return Text(
      'Verifique sua caixa de spam caso não encontre o e-mail',
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.textPlaceholder,
        fontSize: 12,
      ),
    );
  }
}