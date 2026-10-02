import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/screens/pix_manage_keys_screen.dart';
import 'package:estrutura_front_san1ty/screens/pix_pay_screen.dart';

class PixHomeScreen extends StatefulWidget {
  static const String routeName = '/pix/home';

  const PixHomeScreen({super.key});

  @override
  State<PixHomeScreen> createState() => _PixHomeScreenState();
}

class _PixHomeScreenState extends State<PixHomeScreen> {
  final TextEditingController _amountController = TextEditingController();
  final FocusNode _valueFocusNode = FocusNode();
  String _rawAmount = '';
  bool _qrGenerated = false;
  bool _showFeedback = false;
  Timer? _feedbackTimer;

  static const String _pixCnpj = '12.345.678/0001-99';

  @override
  void dispose() {
    _amountController.dispose();
    _valueFocusNode.dispose();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  String _formatCurrency(String digits) {
    final value = int.tryParse(digits.isEmpty ? '0' : digits) ?? 0;
    final reais = value ~/ 100;
    final centavos = value % 100;
    final reaisString = reais.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'R\$ ${reaisString.isEmpty ? '0' : reaisString},${centavos.toString().padLeft(2, '0')}';
  }

  void _updateAmount(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits == _rawAmount) return;
    _rawAmount = digits;
    final formatted = _formatCurrency(digits);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  bool get _canGenerateQr {
    final amount = int.tryParse(_rawAmount.isEmpty ? '0' : _rawAmount) ?? 0;
    return amount > 0;
  }

  void _generateQrCode() {
    if (!_canGenerateQr) return;
    _feedbackTimer?.cancel();
    setState(() {
      _qrGenerated = true;
      _showFeedback = true;
    });
    _feedbackTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showFeedback = false);
    });
  }

  Future<void> _copyPix() async {
    await Clipboard.setData(const ClipboardData(text: _pixCnpj));
    setState(() {
      _showFeedback = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('PIX do CNPJ copiado!'),
        duration: Duration(seconds: 2),
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
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Dimensions.space24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
                      child: _buildActionButtons(context),
                    ),
                    const SizedBox(height: Dimensions.space24),
                    _buildReceiveSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 90,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            iconSize: 24,
            icon: const Icon(Icons.arrow_back, color: Color(0xFF60A5FA)),
            onPressed: () => Navigator.of(context).pop(),
            splashRadius: 24,
            hoverColor: AppColors.overlay10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.flash_on, size: 24, color: Color(0xFF60A5FA)),
              SizedBox(width: Dimensions.space8),
              Text('PIX', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.white)),
            ],
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          label: 'Pagar',
          icon: Icons.send,
          onTap: () => Navigator.pushNamed(context, PixPayScreen.routeName),
        ),
        const SizedBox(height: Dimensions.space12),
        _buildActionCard(
          label: 'Minhas Chaves Pix',
          icon: Icons.vpn_key,
          onTap: () => Navigator.pushNamed(context, PixManageKeysScreen.routeName),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: const Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: AppColors.blueLight),
            const SizedBox(width: Dimensions.space12),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiveSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: const Color(0x33000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Receber Pagamento', style: TextStyle(color: Colors.white, fontSize: 18)),
          const SizedBox(height: Dimensions.space16),
          _buildQrContainer(),
          const SizedBox(height: Dimensions.space16),
          _buildValueInput(),
          const SizedBox(height: Dimensions.space16),
          ElevatedButton(
            onPressed: _canGenerateQr ? _generateQrCode : null,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.actionPrimary,
              disabledBackgroundColor: AppColors.actionPrimary.withAlpha(128),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 0,
              shadowColor: AppColors.blueShadow,
            ),
            child: const Text('Gerar QR Code', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: Dimensions.space12),
          OutlinedButton(
            onPressed: _copyPix,
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              foregroundColor: AppColors.blueLight,
              side: const BorderSide(color: AppColors.brandPrimary, width: 2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.copy, size: 20),
                SizedBox(width: Dimensions.space8),
                Text('Copiar PIX do CNPJ', style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space16),
          AnimatedOpacity(
            opacity: _showFeedback ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: const Text(
              'QR Code gerado com sucesso!',
              style: TextStyle(color: Color(0xFF60A5FA), fontSize: 14),
            ),
          ),
          const SizedBox(height: Dimensions.space16),
          const Text(
            'Pagamentos serão recebidos instantaneamente na conta SAN1TYPAY (CNPJ).',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF666666), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildQrContainer() {
    return Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: _qrGenerated
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: QrImageView(
                  data: 'PIX:$_pixCnpj:$_rawAmount',
                  version: QrVersions.auto,
                  size: 164,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              )
            : const Center(
                child: Icon(Icons.qr_code, size: 64, color: AppColors.textTertiary),
              ),
      ),
    );
  }

  Widget _buildValueInput() {
    return TextField(
      controller: _amountController,
      focusNode: _valueFocusNode,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        hintText: 'Digite o valor',
        hintStyle: const TextStyle(color: AppColors.textPlaceholder, fontSize: 20),
        filled: true,
        fillColor: AppColors.backgroundSecondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDefault, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 20),
      onChanged: _updateAmount,
    );
  }
}
