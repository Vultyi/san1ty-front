import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/screens/pix_success_screen.dart';

class PixValueScreen extends StatefulWidget {
  static const String routeName = '/pix/value';

  final String recipientKey;

  const PixValueScreen({super.key, required this.recipientKey});

  @override
  State<PixValueScreen> createState() => _PixValueScreenState();
}

class _PixValueScreenState extends State<PixValueScreen> {
  String _amountDigits = '';

  int get _amountCents => int.tryParse(_amountDigits.isEmpty ? '0' : _amountDigits) ?? 0;

  String get _formattedAmount {
    final reais = _amountCents ~/ 100;
    final centavos = _amountCents % 100;
    final reaisString = reais.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
    return 'R\$ ${reaisString.isEmpty ? '0' : reaisString},${centavos.toString().padLeft(2, '0')}';
  }

  bool get _canConfirm => _amountCents > 0;

  void _addDigit(String digit) {
    if (_amountDigits.length >= 9) return;
    setState(() {
      _amountDigits = '$_amountDigits$digit';
    });
  }

  void _deleteDigit() {
    if (_amountDigits.isEmpty) return;
    setState(() {
      _amountDigits = _amountDigits.substring(0, _amountDigits.length - 1);
    });
  }

  void _setQuickValue(int reais) {
    setState(() {
      _amountDigits = (reais * 100).toString();
    });
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
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Dimensions.space24),
                    const Text('Quanto deseja pagar?', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400)),
                    const SizedBox(height: Dimensions.space16),
                    _buildRecipientInfo(),
                    const SizedBox(height: Dimensions.space16),
                    _buildAmountDisplay(),
                    const SizedBox(height: Dimensions.space24),
                    const Text('Valores rápidos:', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
                    const SizedBox(height: Dimensions.space12),
                    _buildQuickValues(),
                    const SizedBox(height: Dimensions.space24),
                    _buildNumericKeyboard(),
                    const SizedBox(height: Dimensions.space24),
                    ElevatedButton(
                      onPressed: _canConfirm ? _confirm : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 58),
                        backgroundColor: const Color(0xFF1D4ED8),
                        disabledBackgroundColor: const Color(0xFF1D4ED8).withOpacity(0.4),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        shadowColor: const Color(0x4D1D4ED8),
                      ),
                      child: Text('Confirmar Pagamento $_formattedAmount', style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(height: Dimensions.space24),
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
        border: Border(bottom: BorderSide(color: Color(0xFF1E1E1E), width: 1)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          iconSize: 24,
          icon: const Icon(Icons.arrow_back, color: Color(0xFF60A5FA)),
          onPressed: () => Navigator.of(context).pop(),
          splashRadius: 24,
          hoverColor: const Color(0x1A93C5FD),
        ),
      ),
    );
  }

  Widget _buildRecipientInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pagando para:', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
        const SizedBox(height: 4),
        Text(widget.recipientKey, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _buildAmountDisplay() {
    return Container(
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Center(
        child: Text(_formattedAmount, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w400)),
      ),
    );
  }

  Widget _buildQuickValues() {
    final values = [10, 20, 50, 100];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: values.map((value) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: value == 10 ? 0 : 8, right: value == 100 ? 0 : 8),
            child: OutlinedButton(
              onPressed: () => _setQuickValue(value),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 40),
                foregroundColor: const Color(0xFF60A5FA),
                side: const BorderSide(color: Color(0xFF333333)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('R\$ $value', style: const TextStyle(fontSize: 14)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNumericKeyboard() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'back'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.35,
      ),
      itemBuilder: (context, index) {
        final key = keys[index];
        if (key.isEmpty) {
          return Container();
        }
        return GestureDetector(
          onTap: key == 'back' ? _deleteDigit : () => _addDigit(key),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF333333)),
            ),
            child: Center(
              child: key == 'back'
                  ? const Icon(Icons.backspace, color: Color(0xFFFF4444), size: 24)
                  : Text(key, style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ),
        );
      },
    );
  }

  void _confirm() {
    if (!_canConfirm) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PixSuccessScreen(
          amount: _formattedAmount,
          recipientKey: widget.recipientKey,
          timestamp: DateTime.now(),
        ),
      ),
    );
  }
}
