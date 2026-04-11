import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:estrutura_front_san1ty/screens/commerce_list_screen.dart';

class CommerceOnboardingScreen extends StatefulWidget {
  static const String routeName = '/commerce/onboarding';

  const CommerceOnboardingScreen({super.key});

  @override
  State<CommerceOnboardingScreen> createState() =>
      _CommerceOnboardingScreenState();
}

class _CommerceOnboardingScreenState extends State<CommerceOnboardingScreen> {
  final _nameController = TextEditingController();
  final _displayNameController = TextEditingController();
  String _selectedCategory = 'Cosméticos';
  String _operationType = 'both';

  @override
  void dispose() {
    _nameController.dispose();
    _displayNameController.dispose();
    super.dispose();
  }

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
        title: const Text('Criar Comércio'),
      ),
      body: SafeArea(
        child: ListView(
          padding: Dimensions.screenPadding,
          children: [
            const SizedBox(height: Dimensions.space24),
            const Center(
              child: Icon(
                Icons.store,
                size: 64,
                color: AppColors.actionPrimary,
              ),
            ),
            const SizedBox(height: Dimensions.space24),
            _buildTextField(
              'Nome do Comércio *',
              'Ex: Loja do João',
              _nameController,
            ),
            const SizedBox(height: Dimensions.space20),
            _buildDropdownField(),
            const SizedBox(height: Dimensions.space20),
            _buildTextField(
              'Nome exibido no QR Code *',
              'Nome que aparecerá para seus clientes',
              _displayNameController,
            ),
            const SizedBox(height: Dimensions.space24),
            const Text(
              'Tipo de operação *',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: Dimensions.space12),
            _buildOperationOption('physical', 'Loja Física'),
            const SizedBox(height: Dimensions.space12),
            _buildOperationOption('online', 'Loja Online'),
            const SizedBox(height: Dimensions.space12),
            _buildOperationOption('both', 'Ambos'),
            const SizedBox(height: Dimensions.space32),
            ElevatedButton(
              onPressed:
                  _nameController.text.isNotEmpty &&
                      _displayNameController.text.isNotEmpty
                  ? () => Navigator.pushNamed(
                      context,
                      CommerceListScreen.routeName,
                    )
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.actionPrimary,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.radius14),
                ),
              ),
              child: const Text(
                'Ativar comércio',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String placeholder,
    TextEditingController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: Dimensions.space8),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(color: AppColors.textTertiary),
            filled: true,
            fillColor: AppColors.backgroundSecondary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius14),
              borderSide: const BorderSide(color: AppColors.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius14),
              borderSide: const BorderSide(color: AppColors.actionPrimary),
            ),
          ),
          onChanged: (_) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    final categories = [
      'Cosméticos',
      'Cards e Colecionáveis',
      'Eletrônicos',
      'Serviços',
      'Moda e Vestuário',
      'Alimentos e Bebidas',
      'Artesanato',
      'Outros',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoria *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: Dimensions.space8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(Dimensions.radius14),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: DropdownButton<String>(
            value: _selectedCategory,
            isExpanded: true,
            underline: const SizedBox.shrink(),
            dropdownColor: AppColors.backgroundSecondary,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
            items: categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category, style: AppTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOperationOption(String value, String label) {
    final selected = _operationType == value;
    return GestureDetector(
      onTap: () => setState(() => _operationType = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0x1A007AFF)
              : AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(Dimensions.radius14),
          border: Border.all(
            color: selected ? AppColors.actionPrimary : AppColors.borderDefault,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _operationType,
              activeColor: AppColors.actionPrimary,
              fillColor: WidgetStateProperty.resolveWith(
                (states) => selected
                    ? AppColors.actionPrimary
                    : AppColors.textSecondary,
              ),
              onChanged: (value) => setState(() => _operationType = value!),
            ),
            const SizedBox(width: Dimensions.space12),
            Text(label, style: AppTextStyles.bodyMedium),
          ],
        ),
      ),
    );
  }
}
