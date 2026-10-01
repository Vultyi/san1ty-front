import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/commerce_onboarding_screen.dart';

class CommercePlanScreen extends StatelessWidget {
  static const String routeName = '/commerce/plan';

  const CommercePlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Plano Comercial'),
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.screenPadding,
          children: [
            const SizedBox(height: Dimensions.space24),
            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundSecondary,
                border: Border.all(color: AppColors.borderDefault, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.radius20),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.actionPrimary,
                          borderRadius: BorderRadius.circular(Dimensions.radius12),
                        ),
                        child: const Icon(Icons.store, size: 24, color: Colors.white),
                      ),
                      const SizedBox(width: Dimensions.space12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Comércio Básico', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                          SizedBox(height: Dimensions.space4),
                          Text('Plano mensal', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimensions.space24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text('R\$ 19,90', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white)),
                      SizedBox(width: Dimensions.space8),
                      Text('/ mês', style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space24),
            _buildFeatureItem(Icons.check, '1 comércio ativo'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'QR Code fixo (valor livre)'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'QR Code dinâmico (valor definido)'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'Painel de vendas completo'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'Histórico de transações'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'Solicitação de saque manual'),
            const SizedBox(height: Dimensions.space12),
            _buildFeatureItem(Icons.check, 'Assistente financeiro com resumo mensal'),
            const SizedBox(height: Dimensions.space24),
            Container(
              decoration: BoxDecoration(
                color: const Color(0x4D000000),
                border: Border.all(color: AppColors.borderDefault, width: 1),
                borderRadius: BorderRadius.circular(Dimensions.radius14),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildLimitRow('Limite de vendas mensal', 'R\$ 5.000'),
                  const SizedBox(height: Dimensions.space12),
                  _buildLimitRow('Limite de saque diário', 'R\$ 1.000'),
                ],
              ),
            ),
            const SizedBox(height: Dimensions.space32),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, CommerceOnboardingScreen.routeName),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionPrimary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius16)),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: const Text('Selecionar plano', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.successGreen),
        const SizedBox(width: Dimensions.space12),
        Expanded(child: Text(title, style: AppTextStyles.bodyMedium)),
      ],
    );
  }

  Widget _buildLimitRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.bodySmall),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
