import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/screens/pix_register_key_screen.dart';
import 'package:estrutura_front_san1ty/services/payment_service.dart';

enum PixKeyType { cpf, phone, email, random }

PixKeyType _typeFrom(String raw) {
  switch (raw.toLowerCase()) {
    case 'cpf':
      return PixKeyType.cpf;
    case 'phone':
      return PixKeyType.phone;
    case 'email':
      return PixKeyType.email;
    default:
      return PixKeyType.random;
  }
}

String _labelFor(PixKeyType type) {
  switch (type) {
    case PixKeyType.cpf:
      return 'CPF';
    case PixKeyType.phone:
      return 'Celular';
    case PixKeyType.email:
      return 'E-mail';
    case PixKeyType.random:
      return 'Aleatória';
  }
}

class PixKeyModel {
  final String id;
  final PixKeyType type;
  final String label;
  final String value;

  PixKeyModel({required this.id, required this.type, required this.label, required this.value});
}

class PixManageKeysScreen extends StatefulWidget {
  static const String routeName = '/pix/keys';

  const PixManageKeysScreen({super.key});

  @override
  State<PixManageKeysScreen> createState() => _PixManageKeysScreenState();
}

class _PixManageKeysScreenState extends State<PixManageKeysScreen> {
  final PaymentService _service = PaymentService();
  final List<PixKeyModel> _keys = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final response = await _service.getPixKeys();
      final items = response['keys'];
      final loaded = <PixKeyModel>[];
      if (items is List) {
        for (final item in items) {
          if (item is! Map) continue;
          final type = _typeFrom(item['key_type']?.toString() ?? '');
          loaded.add(PixKeyModel(
            id: item['id']?.toString() ?? '',
            type: type,
            label: _labelFor(type),
            value: item['key_value']?.toString() ?? '',
          ));
        }
      }
      if (!mounted) return;
      setState(() {
        _keys
          ..clear()
          ..addAll(loaded);
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteKey(int index) async {
    final key = _keys[index];
    final ok = await _service.deletePixKey(key.id);
    if (!mounted) return;
    if (ok) {
      setState(() => _keys.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Chave removida')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível remover. Tente de novo.')),
      );
    }
  }

  void _copyKey(String value) {
    Clipboard.setData(ClipboardData(text: value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chave copiada para o clipboard')), 
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Dimensions.space24),
              _buildHeader(context),
              const SizedBox(height: Dimensions.space32),
              _buildTitleSection(),
              const SizedBox(height: Dimensions.space32),
              _buildGridButtons(),
              const SizedBox(height: Dimensions.space32),
              const Text('Minhas Chaves', style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 18)),
              const SizedBox(height: Dimensions.space16),
              _buildKeysList(),
              const SizedBox(height: Dimensions.space12),
              const Text(
                'Toque para copiar a chave ou nos 3 pontos para mais opções',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF666666), fontSize: 12),
              ),
              const SizedBox(height: Dimensions.space24),
            ],
          ),
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
      padding: const EdgeInsets.symmetric(horizontal: 0),
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

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Gerenciar Chaves PIX', style: TextStyle(color: Color(0xFFE0E0E0), fontSize: 22)),
        SizedBox(height: Dimensions.space8),
        Text('Você pode cadastrar até 5 chaves.', style: TextStyle(color: Color(0xFFB0B0B0), fontSize: 14)),
      ],
    );
  }

  Widget _buildGridButtons() {
    final items = [
      _buildTypeCard(PixKeyType.cpf, Icons.person, 'CPF'),
      _buildTypeCard(PixKeyType.phone, Icons.smartphone, 'Celular'),
      _buildTypeCard(PixKeyType.email, Icons.email, 'E-mail'),
      _buildTypeCard(PixKeyType.random, Icons.shuffle, 'Aleatória'),
    ];

    return Wrap(
      runSpacing: Dimensions.space24,
      spacing: Dimensions.space24,
      children: items,
    );
  }

  Widget _buildTypeCard(PixKeyType type, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        final keyTypeString = type.toString().split('.').last;
        Navigator.pushNamed(
          context,
          PixRegisterKeyScreen.routeName,
          arguments: {'keyType': keyTypeString},
        ).then((_) => _loadKeys());
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 20 * 2 - 24) / 2,
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.blueLight, size: 32),
            const SizedBox(height: Dimensions.space12),
            Text(label, style: const TextStyle(color: Color(0xFFE0E0E0), fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildKeysList() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_keys.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text(
            'Nenhuma chave cadastrada ainda.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderDefault),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        children: List.generate(_keys.length, (index) {
          final key = _keys[index];
          return Column(
            children: [
              _buildKeyItem(key, index, isLast: index == _keys.length - 1),
              if (index != _keys.length - 1)
                const Divider(color: Color(0xFF333333), height: 1),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildKeyItem(PixKeyModel key, int index, {required bool isLast}) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundSecondary,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Icon(
              _iconForType(key.type),
              color: AppColors.blueLight,
              size: 20,
            ),
          ),
          const SizedBox(width: Dimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(key.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(key.value, style: const TextStyle(color: Colors.white, fontSize: 14), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          _buildActionButton(Icons.copy, () => _copyKey(key.value)),
          const SizedBox(width: Dimensions.space8),
          _buildActionButton(Icons.more_vert, () => _openKeyOptions(index)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.blueLight, size: 20),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: 20,
      ),
    );
  }

  void _openKeyOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Mais opções', style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: Dimensions.space16),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.of(context).pop();
                  _deleteKey(index);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.backgroundSecondary,
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.delete, color: Color(0xFFFF4444), size: 16),
                      SizedBox(width: Dimensions.space12),
                      Text('Deletar chave', style: TextStyle(color: Color(0xFFFF4444), fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.space12),
            ],
          ),
        );
      },
    );
  }

  IconData _iconForType(PixKeyType type) {
    switch (type) {
      case PixKeyType.cpf:
        return Icons.person;
      case PixKeyType.phone:
        return Icons.smartphone;
      case PixKeyType.email:
        return Icons.email;
      case PixKeyType.random:
        return Icons.shuffle;
    }
  }
}
