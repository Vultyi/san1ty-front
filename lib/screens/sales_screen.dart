import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';

class SalesScreen extends StatefulWidget {
  static const String routeName = '/sales';

  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> with TickerProviderStateMixin {
  String _selectedFilter = 'Todas';
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
        title: const Text('Vendas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildSummaryCards(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSalesList(),
                  _buildPendingList(),
                  _buildCompletedList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to create sale
        },
        backgroundColor: AppColors.actionPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: Dimensions.screenPadding,
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Hoje',
              value: 'R\$ 245,50',
              count: '12 vendas',
              color: AppColors.successGreen,
            ),
          ),
          const SizedBox(width: Dimensions.space12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Esta semana',
              value: 'R\$ 1.245,50',
              count: '48 vendas',
              color: AppColors.actionPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required String count, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.bodySmall),
          const SizedBox(height: Dimensions.space4),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: Dimensions.space4),
          Text(count, style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      indicatorColor: AppColors.actionPrimary,
      labelColor: AppColors.actionPrimary,
      unselectedLabelColor: AppColors.textSecondary,
      tabs: const [
        Tab(text: 'Todas'),
        Tab(text: 'Pendentes'),
        Tab(text: 'Concluídas'),
      ],
    );
  }

  Widget _buildSalesList() {
    final sales = [
      _SaleItem(
        id: '#1234',
        customer: 'João Silva',
        amount: 'R\$ 50,00',
        method: 'PIX',
        status: 'Concluída',
        date: 'Hoje, 14:30',
        statusColor: AppColors.successGreen,
      ),
      _SaleItem(
        id: '#1233',
        customer: 'Maria Santos',
        amount: 'R\$ 120,00',
        method: 'Cartão',
        status: 'Pendente',
        date: 'Hoje, 12:15',
        statusColor: AppColors.warningOrange,
      ),
      _SaleItem(
        id: '#1232',
        customer: 'Pedro Oliveira',
        amount: 'R\$ 89,90',
        method: 'PIX',
        status: 'Concluída',
        date: 'Ontem, 18:45',
        statusColor: AppColors.successGreen,
      ),
    ];

    return ListView.builder(
      padding: Dimensions.screenPadding,
      itemCount: sales.length,
      itemBuilder: (context, index) => _buildSaleCard(sales[index]),
    );
  }

  Widget _buildPendingList() {
    return _buildEmptyState('Nenhuma venda pendente', 'As vendas pendentes aparecerão aqui');
  }

  Widget _buildCompletedList() {
    final completedSales = [
      _SaleItem(
        id: '#1234',
        customer: 'João Silva',
        amount: 'R\$ 50,00',
        method: 'PIX',
        status: 'Concluída',
        date: 'Hoje, 14:30',
        statusColor: AppColors.successGreen,
      ),
      _SaleItem(
        id: '#1232',
        customer: 'Pedro Oliveira',
        amount: 'R\$ 89,90',
        method: 'PIX',
        status: 'Concluída',
        date: 'Ontem, 18:45',
        statusColor: AppColors.successGreen,
      ),
    ];

    return ListView.builder(
      padding: Dimensions.screenPadding,
      itemCount: completedSales.length,
      itemBuilder: (context, index) => _buildSaleCard(completedSales[index]),
    );
  }

  Widget _buildSaleCard(_SaleItem sale) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: ExpansionTile(
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(sale.id, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                  Text(sale.customer, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(sale.amount, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white)),
                Text(sale.date, style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildDetailRow('Método', sale.method),
                const SizedBox(height: Dimensions.space8),
                _buildDetailRow('Status', sale.status, valueColor: sale.statusColor),
                const SizedBox(height: Dimensions.space12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.actionPrimary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
                        ),
                        child: const Text('Ver detalhes'),
                      ),
                    ),
                    const SizedBox(width: Dimensions.space12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.actionPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radius12)),
                        ),
                        child: const Text('Compartilhar'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodySmall),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: Dimensions.space16),
          Text(title, style: AppTextStyles.heading3, textAlign: TextAlign.center),
          const SizedBox(height: Dimensions.space8),
          Text(subtitle, style: AppTextStyles.bodyMedium, textAlign: TextAlign.center),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundSecondary,
        title: const Text('Filtrar vendas', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Todas'),
            _buildFilterOption('PIX'),
            _buildFilterOption('Cartão'),
            _buildFilterOption('Dinheiro'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.actionPrimary),
            child: const Text('Aplicar'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String option) {
    return RadioListTile<String>(
      title: Text(option, style: const TextStyle(color: Colors.white)),
      value: option,
      groupValue: _selectedFilter,
      activeColor: AppColors.actionPrimary,
      onChanged: (value) {
        setState(() => _selectedFilter = value!);
      },
    );
  }
}

class _SaleItem {
  final String id;
  final String customer;
  final String amount;
  final String method;
  final String status;
  final String date;
  final Color statusColor;

  const _SaleItem({
    required this.id,
    required this.customer,
    required this.amount,
    required this.method,
    required this.status,
    required this.date,
    required this.statusColor,
  });
}