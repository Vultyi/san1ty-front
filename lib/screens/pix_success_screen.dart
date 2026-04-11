import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';

class PixSuccessScreen extends StatelessWidget {
  static const String routeName = '/pix/success';

  final String amount;
  final String recipientKey;
  final DateTime timestamp;

  const PixSuccessScreen({super.key, required this.amount, required this.recipientKey, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Dimensions.space24),
              _buildSuccessIcon(),
              const SizedBox(height: Dimensions.space24),
              const Text('Pagamento realizado!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              const Text(
                'Seu pagamento foi processado com sucesso',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14),
              ),
              const SizedBox(height: 32),
              _buildDetailsCard(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 54),
                  backgroundColor: const Color(0xFF1D4ED8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  shadowColor: const Color(0x4D1D4ED8),
                ),
                child: const Text('Voltar ao Início', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        width: 96,
        height: 96,
        decoration: const BoxDecoration(color: Color(0xFF00FF88), shape: BoxShape.circle),
        child: const Icon(Icons.check, size: 56, color: Colors.black),
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        border: Border.all(color: const Color(0xFF333333)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildDetailRow('Valor pago', amount, isLarge: true),
          const Divider(color: Color(0xFF333333), height: 32, thickness: 1),
          _buildDetailRow('Para', recipientKey),
          const Divider(color: Color(0xFF333333), height: 32, thickness: 1),
          _buildDetailRow('Data e hora', _formatTimestamp(timestamp)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isLarge = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFB0B0B0), fontSize: 12)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: Colors.white, fontSize: isLarge ? 24 : 16)),
      ],
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day/$month/$year • $hour:$minute';
  }
}
