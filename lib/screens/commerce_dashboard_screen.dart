import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/constants/colors.dart';
import 'package:estrutura_front_san1ty/constants/dimensions.dart';
import 'package:estrutura_front_san1ty/constants/text_styles.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

class CommerceDashboardScreen extends StatefulWidget {
  static const String routeName = '/commerce/dashboard';

  const CommerceDashboardScreen({super.key});

  @override
  State<CommerceDashboardScreen> createState() =>
      _CommerceDashboardScreenState();
}

class _CommerceDashboardScreenState extends State<CommerceDashboardScreen>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final TextEditingController _amountController = TextEditingController(
    text: '50,00',
  );
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _hasNewSuggestions = true;

  static const List<String> _pageTitles = [
    'Painel Comercial',
    'QR Codes',
    'Vendas',
    'Saques',
    'Assistente',
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _amountController.dispose();
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
        title: Text(_pageTitles[_selectedIndex]),
      ),
      body: SafeArea(child: _buildPageContent()),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.borderDefault, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: AppColors.backgroundPrimary,
          selectedItemColor: AppColors.actionPrimary,
          unselectedItemColor: AppColors.textLabel,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() => _selectedIndex = index);
            if (index == 4) {
              _hasNewSuggestions = false;
            }
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Dashboard',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR Codes',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Vendas',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.arrow_downward),
              label: 'Saques',
            ),
            BottomNavigationBarItem(
              icon: _hasNewSuggestions
                  ? Badge(
                      label: const Text('!'),
                      child: const Icon(Icons.message),
                    )
                  : const Icon(Icons.message),
              label: 'Assistente',
            ),
          ],
        ),
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () {
                _amountController.clear();
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Novo QR Code gerado!')),
                );
              },
              backgroundColor: AppColors.actionPrimary,
              child: const Icon(Icons.refresh),
            )
          : null,
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 1:
        return _buildQrCodePage();
      case 2:
        return _buildSalesPage();
      case 3:
        return _buildWithdrawalsPage();
      case 4:
        return _buildAssistantPage();
      default:
        return RefreshIndicator(
          onRefresh: () async {
            // Simulate data refresh
            await Future.delayed(const Duration(seconds: 1));
            setState(() {});
          },
          child: ListView(
            padding: Dimensions.screenPadding,
            children: [
              const SizedBox(height: Dimensions.space24),
              _buildStatusHeader(),
              const SizedBox(height: Dimensions.space24),
              _buildStatsGrid(),
              const SizedBox(height: Dimensions.space24),
              _buildSalesChart(),
              const SizedBox(height: Dimensions.space24),
              ScaleTransition(
                scale: _scaleAnimation,
                child: _buildOverviewCard(),
              ),
              const SizedBox(height: Dimensions.space24),
              _buildRecentActivity(),
            ],
          ),
        );
    }
  }

  Widget _buildStatusHeader() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.backgroundPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(width: Dimensions.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Loja do João',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: Dimensions.space4),
                Text(
                  'Ativo',
                  style: TextStyle(fontSize: 12, color: AppColors.successGreen),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    final cards = [
      _CommerceStatCard(
        label: 'Hoje',
        value: 'R\$ 245',
        color: Colors.white,
      ),
      _CommerceStatCard(
        label: 'Mês',
        value: 'R\$ 1.245',
        color: Colors.white,
      ),
      _CommerceStatCard(
        label: 'Vendas',
        value: '18',
        color: Colors.white,
      ),
      _CommerceStatCard(
        label: 'Saldo',
        value: 'R\$ 1.245',
        color: AppColors.actionPrimary,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: Dimensions.space8,
      mainAxisSpacing: Dimensions.space8,
      childAspectRatio: 1.2,
      children: cards,
    );
  }

  Widget _buildSalesChart() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Vendas dos Últimos 7 Dias',
            style: AppTextStyles.heading3,
          ),
          const SizedBox(height: Dimensions.space16),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) => Text(
                        'R\$ ${value.toInt()}',
                        style: const TextStyle(
                          color: AppColors.textLabel,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = [
                          'Seg',
                          'Ter',
                          'Qua',
                          'Qui',
                          'Sex',
                          'Sáb',
                          'Dom',
                        ];
                        return Text(
                          days[value.toInt()],
                          style: const TextStyle(
                            color: AppColors.textLabel,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 50),
                      FlSpot(1, 80),
                      FlSpot(2, 120),
                      FlSpot(3, 90),
                      FlSpot(4, 150),
                      FlSpot(5, 200),
                      FlSpot(6, 245),
                    ],
                    isCurved: true,
                    color: AppColors.actionPrimary,
                    barWidth: 3,
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.actionPrimary.withOpacity(0.1),
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: AppColors.backgroundSecondary,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((spot) {
                        return LineTooltipItem(
                          'R\$ ${spot.y.toInt()}',
                          const TextStyle(color: Colors.white),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0x3300C853), Color(0x0D00C853)],
            ),
            border: Border.all(color: const Color(0x4D00C853)),
            borderRadius: BorderRadius.circular(Dimensions.radius16),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.trending_up,
                    size: 20,
                    color: AppColors.successGreen,
                  ),
                  SizedBox(width: Dimensions.space8),
                  Text(
                    'Total Vendido Hoje',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.space8),
              const Text(
                'R\$ 245,50',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: Dimensions.space4),
              const Text(
                '+15% vs ontem',
                style: TextStyle(fontSize: 12, color: AppColors.successGreen),
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.space16),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2962FF), Color(0xFF007AFF)],
            ),
            borderRadius: BorderRadius.circular(Dimensions.radius18),
            boxShadow: const [AppColors.shadowBlue],
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Saldo Disponível para Saque',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: Dimensions.space8),
              const Text(
                'R\$ 1.245,50',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: Dimensions.space16),
              Row(
                children: [
                  Expanded(child: _buildMiniInfo('Disponível', 'R\$ 1.245,50')),
                  const SizedBox(width: Dimensions.space8),
                  Expanded(child: _buildMiniInfo('Pendente', 'R\$ 0,00')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMiniInfo(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 10, color: Colors.white60),
          ),
          const SizedBox(height: Dimensions.space4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Atividade recente', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        _buildActivityItem(
          'Venda #1234',
          'Hoje às 14:30',
          '+R\$ 50,00',
          'PIX',
          AppColors.successGreen,
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String when,
    String amount,
    String method,
    Color badgeColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius14),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0x1A00C853),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.trending_up, size: 16, color: badgeColor),
              ),
              const SizedBox(width: Dimensions.space12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: Dimensions.space4),
                  Text(when, style: AppTextStyles.bodySmall),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: badgeColor,
                ),
              ),
              const SizedBox(height: Dimensions.space4),
              Text(method, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrCodePage() {
    return ListView(
      padding: Dimensions.screenPadding,
      children: [
        const SizedBox(height: Dimensions.space24),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            border: Border.all(color: AppColors.borderDefault, width: 1),
            borderRadius: BorderRadius.circular(Dimensions.radius16),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.qr_code,
                size: 90,
                color: AppColors.actionPrimary,
              ),
              const SizedBox(height: Dimensions.space24),
              const Text(
                'QR Code de Pagamento',
                style: AppTextStyles.heading3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.space12),
              const Text(
                'Compartilhe com seus clientes para receber PIX de forma prática e segura.',
                style: AppTextStyles.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Dimensions.space24),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Valor (R\$)',
                  labelStyle: const TextStyle(color: AppColors.textLabel),
                  prefixText: 'R\$ ',
                  prefixStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: AppColors.backgroundPrimary,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius14),
                    borderSide: const BorderSide(
                      color: AppColors.borderDefault,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius14),
                    borderSide: const BorderSide(
                      color: AppColors.actionPrimary,
                    ),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: Dimensions.space24),
              Container(
                height: 220,
                decoration: BoxDecoration(
                  color: AppColors.backgroundPrimary,
                  borderRadius: BorderRadius.circular(Dimensions.radius16),
                  border: Border.all(color: AppColors.borderDefault, width: 1),
                ),
                child: Center(
                  child: QrImageView(
                    data:
                        'PIX: Loja do João - Valor: R\$ ${_amountController.text}',
                    version: QrVersions.auto,
                    size: 180.0,
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.space24),
              ElevatedButton(
                onPressed: () {
                  // Share functionality could be added here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('QR Code compartilhado!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.actionPrimary,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radius16),
                  ),
                ),
                child: const Text(
                  'Compartilhar QR Code',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalesPage() {
    return ListView(
      padding: Dimensions.screenPadding,
      children: [
        const SizedBox(height: Dimensions.space24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Vendas Recentes', style: AppTextStyles.heading3),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Ver todas',
                style: TextStyle(color: AppColors.actionPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.space16),
        ...[
          _buildSalesItem(
            'Venda #1287',
            'Hoje, 13:20',
            'R\$ 120,00',
            'PIX',
            'João Silva',
          ),
          _buildSalesItem(
            'Venda #1286',
            'Hoje, 11:45',
            'R\$ 89,90',
            'Link de pagamento',
            'Maria Santos',
          ),
          _buildSalesItem(
            'Venda #1285',
            'Ontem, 18:15',
            'R\$ 240,00',
            'QR Code',
            'Pedro Oliveira',
          ),
        ],
      ],
    );
  }

  Widget _buildWithdrawalsPage() {
    return ListView(
      padding: Dimensions.screenPadding,
      children: [
        const SizedBox(height: Dimensions.space24),
        const Text('Saques', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        _buildStatusRow('Saldo disponível', 'R\$ 1.245,50'),
        const SizedBox(height: Dimensions.space16),
        _buildWithdrawalRequestCard(
          'Solicitar saque para conta',
          'R\$ 1.000,00 disponível',
        ),
        const SizedBox(height: Dimensions.space24),
        const Text('Histórico de saques', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        _buildStatusItem(
          'Saque pendente',
          'R\$ 400,00',
          'Aguardando liberação',
        ),
        const SizedBox(height: Dimensions.space12),
        _buildStatusItem('Saque concluído', 'R\$ 200,00', 'Ontem, 17:40'),
      ],
    );
  }

  Widget _buildAssistantPage() {
    return ListView(
      padding: Dimensions.screenPadding,
      children: [
        const SizedBox(height: Dimensions.space24),
        const Text('Assistente', style: AppTextStyles.heading3),
        const SizedBox(height: Dimensions.space16),
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSecondary,
            borderRadius: BorderRadius.circular(Dimensions.radius16),
            border: Border.all(color: AppColors.borderDefault, width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Sugestões rápidas', style: AppTextStyles.heading3),
              SizedBox(height: Dimensions.space12),
              Text(
                '1. Atualize seu QR Code para promoções sazonais.',
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: Dimensions.space12),
              Text(
                '2. Ofereça desconto em vendas acima de R\$ 250 para fidelizar clientes.',
                style: AppTextStyles.bodyMedium,
              ),
              SizedBox(height: Dimensions.space12),
              Text(
                '3. Verifique o histórico semanal para ajustar seu estoque.',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSalesItem(
    String title,
    String subtitle,
    String amount,
    String method,
    String customer,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: Dimensions.space12),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        border: Border.all(color: AppColors.borderDefault, width: 1),
        borderRadius: BorderRadius.circular(Dimensions.radius16),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(subtitle, style: AppTextStyles.bodySmall),
            Text(customer, style: AppTextStyles.bodySmall),
          ],
        ),
        trailing: Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Método:', style: AppTextStyles.bodySmall),
                    Text(
                      method,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cliente:', style: AppTextStyles.bodySmall),
                    Text(
                      customer,
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.space8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status:', style: AppTextStyles.bodySmall),
                    Text(
                      'Concluído',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.successGreen,
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

  Widget _buildWithdrawalRequestCard(String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.heading3),
          const SizedBox(height: Dimensions.space8),
          Text(subtitle, style: AppTextStyles.bodyMedium),
          const SizedBox(height: Dimensions.space16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.actionPrimary,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius14),
              ),
            ),
            child: const Text(
              'Solicitar saque',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem(String title, String value, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: Dimensions.space4),
              Text(subtitle, style: AppTextStyles.bodySmall),
            ],
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(Dimensions.radius16),
        border: Border.all(color: AppColors.borderDefault, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyMedium),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _CommerceStatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _CommerceStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x801C1C1E),
        borderRadius: BorderRadius.circular(Dimensions.radius12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textLabel,
            ),
          ),
          const SizedBox(height: Dimensions.space4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
