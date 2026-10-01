import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/commerce_plan_screen.dart';

class CommerceIntroScreen extends StatelessWidget {
  static const String routeName = '/commerce/intro';

  const CommerceIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final nav = Navigator.of(context);
            if (nav.canPop()) {
              nav.pop();
            } else {
              nav.pushReplacementNamed('/dashboard');
            }
          },
        ),
        title: const Text('Comércio'),
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.screenPadding,
          children: [
            const SizedBox(height: Dimensions.space24),
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007AFF), Color(0xFF2962FF)],
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radius24),
                  boxShadow: const [AppColors.shadowBlue],
                ),
                child: const Icon(Icons.qr_code, color: Colors.white, size: 40),
              ),
            ),
            const SizedBox(height: Dimensions.space24),
            const Text(
              'Transforme sua conta em um comércio completo',
              style: AppTextStyles.heading1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.space16),
            const Text(
              'Receba pagamentos via QR Code PIX, gerencie vendas e consulte seu negócio em tempo real.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: Dimensions.space32),
            _buildBenefitCard(
              icon: Icons.qr_code,
              title: 'Receba pagamentos via QR Code PIX',
              description: 'Use em lojas físicas, online ou grupos.',
            ),
            const SizedBox(height: Dimensions.space16),
            _buildBenefitCard(
              icon: Icons.send_to_mobile,
              title: 'Acompanhe vendas em tempo real',
              description: 'Relatórios e resumo financeiro direto no app.',
            ),
            const SizedBox(height: Dimensions.space16),
            _buildBenefitCard(
              icon: Icons.account_balance_wallet,
              title: 'Saques rápidos',
              description: 'Solicite saque de forma rápida e fácil.',
            ),
            const SizedBox(height: Dimensions.space16),
            _buildBenefitCard(
              icon: Icons.smart_toy,
              title: 'Assistente financeiro inteligente',
              description: 'Receba sugestões e acompanhe metas.',
            ),
            const SizedBox(height: Dimensions.space32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, CommercePlanScreen.routeName),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius16),
                ),
              ),
              child: const Text('Começar agora', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: Dimensions.space16),
            const Text(
              'Sem compromisso. Configure seu comércio em poucos passos.',
              style: AppTextStyles.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitCard({required IconData icon, required String title, required String description}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0x1A007AFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.actionPrimary, size: 24),
          ),
          const SizedBox(width: Dimensions.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.heading3),
                const SizedBox(height: Dimensions.space4),
                Text(description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
