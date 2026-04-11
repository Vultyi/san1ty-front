import 'dart:math';

import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';

class PixRegisterKeyScreen extends StatefulWidget {
  static const String routeName = '/pix/register-key';

  final String keyType;

  const PixRegisterKeyScreen({
    super.key,
    required this.keyType,
  });

  @override
  State<PixRegisterKeyScreen> createState() => _PixRegisterKeyScreenState();
}

class _PixRegisterKeyScreenState extends State<PixRegisterKeyScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  String _generatedKey = '';
  bool _isGenerating = false;

  String get _keyTypeLabel {
    switch (widget.keyType) {
      case 'cpf':
        return 'CPF';
      case 'phone':
        return 'Celular';
      case 'email':
        return 'E-mail';
      case 'random':
        return 'Aleatória';
      default:
        return 'Chave';
    }
  }

  String get _placeholder {
    switch (widget.keyType) {
      case 'cpf':
        return '000.000.000-00';
      case 'phone':
        return '(00) 00000-0000';
      case 'email':
        return 'email@exemplo.com';
      default:
        return '';
    }
  }

  String get _buttonText {
    if (widget.keyType == 'random') {
      return 'Cadastrar chave';
    }
    return widget.keyType == 'email' || widget.keyType == 'phone'
        ? 'Enviar código'
        : 'Cadastrar chave';
  }

  bool get _isValid {
    if (widget.keyType == 'random') {
      return _generatedKey.isNotEmpty;
    }
    return _inputController.text.trim().isNotEmpty;
  }

  String _formatCPF(String input) {
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length <= 3) return numbers;
    if (numbers.length <= 6) return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
    if (numbers.length <= 9) return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
    return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, 11)}';
  }

  String _formatPhone(String input) {
    final numbers = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (numbers.length <= 2) return numbers;
    if (numbers.length <= 7) return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7, 11)}';
  }

  void _generateRandomKey() {
    setState(() => _isGenerating = true);

    // Simular delay de geração
    Future.delayed(const Duration(seconds: 1), () {
      final random = Random();
      final bytes = List<int>.generate(32, (_) => random.nextInt(16));

      final key = bytes
          .map((b) => b.toRadixString(16))
          .join('')
          .replaceAllMapped(
            RegExp(r'.{4}'),
            (match) => '${match.group(0)}-',
          ).substring(0, 71); // Remove último hífen

      setState(() {
        _generatedKey = key;
        _isGenerating = false;
      });
    });
  }

  void _registerKey() {
    if (!_isValid) return;

    final value = widget.keyType == 'random' ? _generatedKey : _inputController.text.trim();

    // Navegar para tela de confirmação se necessário
    if (widget.keyType == 'email') {
      Navigator.pushNamed(
        context,
        '/pix/confirm-email',
        arguments: {'email': value},
      );
    } else if (widget.keyType == 'phone') {
      Navigator.pushNamed(
        context,
        '/pix/confirm-phone',
        arguments: {'phone': value},
      );
    } else {
      // CPF ou chave aleatória - cadastrar diretamente
      _showSuccessDialog();
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
            Text(
              'Chave cadastrada!',
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
              Navigator.of(context).pop(); // Voltar para gerenciar chaves
            },
            child: Text(
              'OK',
              style: TextStyle(color: AppColors.actionPrimary),
            ),
          ),
        ],
      ),
    );
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
                    const SizedBox(height: Dimensions.space50),
                    Text(
                      'Cadastrar chave $_keyTypeLabel',
                      style: AppTextStyles.heading2,
                    ),
                    const SizedBox(height: Dimensions.space32),

                    if (widget.keyType != 'random') ...[
                      _buildInputField(),
                      if (widget.keyType == 'email' || widget.keyType == 'phone')
                        _buildHelperText(),
                      const SizedBox(height: Dimensions.space32),
                    ] else ...[
                      _buildGenerateButton(),
                      if (_generatedKey.isNotEmpty) _buildGeneratedKeyDisplay(),
                      const SizedBox(height: Dimensions.space32),
                    ],

                    _buildRegisterButton(),
                    const SizedBox(height: Dimensions.space24),
                    _buildFooterText(),
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

  Widget _buildInputField() {
    return TextField(
      controller: _inputController,
      focusNode: _inputFocusNode,
      decoration: InputDecoration(
        hintText: _placeholder,
        hintStyle: TextStyle(color: AppColors.textPlaceholder),
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.borderNormal),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.actionPrimary),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        if (widget.keyType == 'cpf') {
          final formatted = _formatCPF(value);
          if (formatted != value) {
            _inputController.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        } else if (widget.keyType == 'phone') {
          final formatted = _formatPhone(value);
          if (formatted != value) {
            _inputController.value = TextEditingValue(
              text: formatted,
              selection: TextSelection.collapsed(offset: formatted.length),
            );
          }
        }
      },
    );
  }

  Widget _buildHelperText() {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.space12),
      child: Text(
        widget.keyType == 'email'
            ? 'Você receberá um código de confirmação por e-mail'
            : 'Você receberá um SMS com código de confirmação',
        style: TextStyle(
          color: AppColors.textLabel,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildGenerateButton() {
    return OutlinedButton(
      onPressed: _isGenerating ? null : _generateRandomKey,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        foregroundColor: AppColors.actionPrimary,
        side: const BorderSide(color: AppColors.borderNormal),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: _isGenerating
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(AppColors.actionPrimary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shuffle, size: 20),
                const SizedBox(width: 8),
                const Text('Gerar chave automaticamente', style: TextStyle(fontSize: 16)),
              ],
            ),
    );
  }

  Widget _buildGeneratedKeyDisplay() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: Dimensions.space16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderNormal),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sua nova chave:',
            style: TextStyle(color: AppColors.textLabel, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(
            _generatedKey,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isValid ? _registerKey : null,
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
      child: Text(_buttonText, style: const TextStyle(fontSize: 16)),
    );
  }

  Widget _buildFooterText() {
    return Text(
      'Você ainda pode cadastrar 5 de 5 chaves.',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColors.textLabel,
        fontSize: 12,
      ),
    );
  }
}