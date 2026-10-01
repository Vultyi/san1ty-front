import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';

class StatementScreen extends StatefulWidget {
  static const String routeName = '/statement';

  const StatementScreen({super.key});

  @override
  State<StatementScreen> createState() => _StatementScreenState();
}

class _StatementScreenState extends State<StatementScreen> {
  String _selectedPeriod = 'Esta semana';
  final List<_TransactionItem> _transactions = [
    _TransactionItem(
      type: 'Recebimento',
      description: 'PIX - João Silva',
      amount: '+R\$ 50,00',
      date: 'Hoje, 14:30',
      icon: Icons.arrow_downward,
      color: AppColors.successGreen,
    ),
    _TransactionItem(
      type: 'Pagamento',
      description: 'Compra no Shopping',
      amount: '-R\$ 120,00',
      date: 'Hoje, 12:15',
      icon: Icons.arrow_upward,
      color: AppColors.errorRed,
    ),
    _TransactionItem(
      type: 'Recebimento',
      description: 'PIX - Maria Santos',
      amount: '+R\$ 89,90',
      date: 'Ontem, 18:45',
      icon: Icons.arrow_downward,
      color: AppColors.successGreen,
    ),
    _TransactionItem(
      type: 'Transferência',
      description: 'Para conta poupança',
      amount: '-R\$ 200,00',
      date: 'Ontem, 10:30',
      icon: Icons.swap_horiz,
      color: AppColors.actionPrimary,
    ),
    _TransactionItem(
      type: 'Recebimento',
      description: 'PIX - Pedro Oliveira',
      amount: '+R\$ 150,00',
      date: '2 dias atrás',
      icon: Icons.arrow_downward,
      color: AppColors.successGreen,
    ),
  ];

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
        title: const Text('Extrato'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _showPeriodDialog,
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Export statement
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Extrato exportado!')),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildBalanceSummary(),
            _buildPeriodSelector(),
            Expanded(
              child: _buildTransactionList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSummary() {
    return Container(
      padding: Dimensions.screenPadding,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          border: Border.all(color: AppColors.borderDefault, width: 1),
          borderRadius: BorderRadius.circular(Dimensions.radius18),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Saldo do período',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: Dimensions.space8),
            const Text(
              'R\$ 1.245,50',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: Dimensions.space16),
            Row(
              children: [
                _buildMiniStat('Entradas', '+R\$ 1.389,90', AppColors.successGreen),
                const SizedBox(width: Dimensions.space16),
                _buildMiniStat('Saídas', '-R\$ 144,40', AppColors.errorRed),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(Dimensions.radius12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.white60)),
            const SizedBox(height: Dimensions.space4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.space20),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: Dimensions.space8),
          Text(_selectedPeriod, style: AppTextStyles.bodyMedium),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
            onPressed: _showPeriodDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return ListView.builder(
      padding: Dimensions.screenPadding,
      itemCount: _transactions.length,
      itemBuilder: (context, index) {
        final transaction = _transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }

  Widget _buildTransactionCard(_TransactionItem transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color.alphaBlend(transaction.color.withOpacity(0.1), AppColors.backgroundSecondary),
            borderRadius: BorderRadius.circular(Dimensions.radius12),
          ),
          child: Icon(transaction.icon, color: transaction.color, size: 24),
        ),
        title: Text(
          transaction.description,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(transaction.type, style: AppTextStyles.caption),
            Text(transaction.date, style: AppTextStyles.caption),
          ],
        ),
        trailing: Text(
          transaction.amount,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: transaction.color,
          ),
        ),
        onTap: () {
          // Show transaction details
          _showTransactionDetails(transaction);
        },
      ),
    );
  }

  void _showPeriodDialog() {
    final periods = [
      'Hoje',
      'Esta semana',
      'Este mês',
      'Últimos 3 meses',
      'Este ano',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text('Selecionar período', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: periods.map((period) => RadioListTile<String>(
            title: Text(period, style: const TextStyle(color: Colors.white)),
            value: period,
            groupValue: _selectedPeriod,
            activeColor: AppColors.actionPrimary,
            onChanged: (value) {
              setState(() => _selectedPeriod = value!);
              Navigator.of(context).pop();
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showTransactionDetails(_TransactionItem transaction) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Color.alphaBlend(transaction.color.withOpacity(0.1), AppColors.backgroundSecondary),
                    borderRadius: BorderRadius.circular(Dimensions.radius12),
                  ),
                  child: Icon(transaction.icon, color: transaction.color, size: 24),
                ),
                const SizedBox(width: Dimensions.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(transaction.description, style: AppTextStyles.heading3),
                      Text(transaction.type, style: AppTextStyles.bodySmall),
                    ],
                  ),
                ),
                Text(
                  transaction.amount,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: transaction.color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimensions.space24),
            _buildDetailRow('Data e hora', transaction.date),
            const SizedBox(height: Dimensions.space12),
            _buildDetailRow('ID da transação', '#${transaction.description.hashCode.abs()}'),
            const SizedBox(height: Dimensions.space24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.actionPrimary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
                    ),
                    child: const Text('Compartilhar'),
                  ),
                ),
                const SizedBox(width: Dimensions.space12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.actionPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
                    ),
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.white)),
      ],
    );
  }
}

class _TransactionItem {
  final String type;
  final String description;
  final String amount;
  final String date;
  final IconData icon;
  final Color color;

  const _TransactionItem({
    required this.type,
    required this.description,
    required this.amount,
    required this.date,
    required this.icon,
    required this.color,
  });
}