import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';

class PixSuccessScreen extends StatelessWidget {
  static const String routeName = '/pix/success';

  final String amount;
  final String recipientKey;
  final DateTime timestamp;
  final String pixKey;
  final String qrCodeText;
  final String? ticketUrl;
  final String paymentId;

  const PixSuccessScreen({
    super.key,
    required this.amount,
    required this.recipientKey,
    required this.timestamp,
    required this.pixKey,
    required this.qrCodeText,
    this.ticketUrl,
    required this.paymentId,
  });

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
              const SizedBox(height: 24),
              _buildCopyButton(context),
              if (ticketUrl != null && ticketUrl!.isNotEmpty) ...[
                const SizedBox(height: 16),
                _buildOpenTicketButton(context),
              ],
              const SizedBox(height: 24),
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
        decoration: const BoxDecoration(color: AppColors.successGreen, shape: BoxShape.circle),
        child: const Icon(Icons.check, size: 56, color: Colors.white),
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
          _buildDetailRow('Chave PIX', pixKey),
          if (qrCodeText.isNotEmpty) ...[
            const Divider(color: Color(0xFF333333), height: 32, thickness: 1),
            _buildDetailRow('QR Code Texto', qrCodeText),
          ],
          const Divider(color: Color(0xFF333333), height: 32, thickness: 1),
          _buildDetailRow('Data e hora', _formatTimestamp(timestamp)),
          if (paymentId.isNotEmpty) ...[
            const Divider(color: Color(0xFF333333), height: 32, thickness: 1),
            _buildDetailRow('ID do Pagamento', paymentId),
          ],
        ],
      ),
    );
  }

  Widget _buildCopyButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(ClipboardData(text: pixKey));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chave PIX copiada para a área de transferência.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: const Color(0xFF1D4ED8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Copiar chave PIX', style: TextStyle(fontSize: 16)),
    );
  }

  Widget _buildOpenTicketButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (ticketUrl == null || ticketUrl!.isEmpty) return;
        final messenger = ScaffoldMessenger.of(context);
        await Clipboard.setData(ClipboardData(text: ticketUrl!));
        messenger.showSnackBar(
          const SnackBar(
            content: Text('URL do comprovante copiada. Abra no navegador.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: const Color(0xFF0F766E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Copiar URL do comprovante', style: TextStyle(fontSize: 16)),
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
