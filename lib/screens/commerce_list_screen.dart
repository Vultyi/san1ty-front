import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/screens/commerce_dashboard_screen.dart';

class CommerceListScreen extends StatelessWidget {
  static const String routeName = '/commerce/list';

  const CommerceListScreen({super.key});

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
        title: const Text('Comércios'),
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.screenPadding,
          children: [
            const SizedBox(height: Dimensions.space24),
            _buildCommerceCard(context),
            const SizedBox(height: Dimensions.space16),
            _buildAddNewCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCommerceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0x1A007AFF),
                  borderRadius: BorderRadius.circular(Dimensions.radius12),
                ),
                child: const Icon(
                  Icons.store,
                  color: AppColors.actionPrimary,
                  size: 24,
                ),
              ),
              const SizedBox(width: Dimensions.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Loja do João',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: Dimensions.space8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x3300C853),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'Ativo',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: Dimensions.space8),
                        const Text(
                          'Comércio Básico',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.space16),
          Container(
            decoration: BoxDecoration(
              color: const Color(0x4D1C1C1E),
              borderRadius: BorderRadius.circular(Dimensions.radius12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Saldo disponível',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textLabel,
                  ),
                ),
                SizedBox(height: Dimensions.space4),
                Text(
                  'R\$ 1.245,50',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Dimensions.space16),
          ElevatedButton(
            onPressed: () =>
                Navigator.pushNamed(context, CommerceDashboardScreen.routeName),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionPrimary,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius14),
              ),
            ),
            child: const Text(
              'Acessar Painel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(
            color: AppColors.borderDefault,
            width: 2,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius16),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.add, size: 32, color: AppColors.textLabel),
            SizedBox(height: Dimensions.space8),
            Text(
              'Adicionar Novo Comércio',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
