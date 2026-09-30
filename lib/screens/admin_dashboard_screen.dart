// lib/screens/admin_dashboard_screen.dart
import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_kpi_card.dart';
import '../widgets/admin_member_card.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_alert.dart';
import '../widgets/admin_credentials_display.dart';
import '../widgets/admin_input.dart';
import '../models/admin_models.dart';

class AdminDashboardScreen extends StatefulWidget {
  static const String routeName = '/admin/dashboard';

  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _currentIndex = 0;
  late List<SupportMember> _teamMembers;
  late TeamSummary _summary;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    // Mock data - replace with actual API calls
    _teamMembers = [
      SupportMember(
        id: 'support_1',
        name: 'Lucas Oliveira',
        email: 'suporte-lucas-oliveira@gmail.com',
        avatar: 'LO',
        role: SupportRole.supportLevel1,
        status: SupportStatus.online,
        stats: SupportStats(
          loggedTime: '7h 23min',
          loggedTimeMinutes: 443,
          chatsActive: 3,
          chatsResolved: 28,
          avgResponseTime: '2min',
          avgResponseTimeSeconds: 120,
          satisfaction: 4.8,
          lastActivity: DateTime.now(),
        ),
        lastActivity: DateTime.now(),
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      SupportMember(
        id: 'support_2',
        name: 'Fernanda Costa',
        email: 'suporte-fernanda-costa@gmail.com',
        avatar: 'FC',
        role: SupportRole.supportLevel2,
        status: SupportStatus.online,
        stats: SupportStats(
          loggedTime: '6h 45min',
          loggedTimeMinutes: 405,
          chatsActive: 2,
          chatsResolved: 35,
          avgResponseTime: '1min',
          avgResponseTimeSeconds: 60,
          satisfaction: 4.9,
          lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
        ),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ];

    _summary = TeamSummary(
      totalMembers: 4,
      onlineMembers: 2,
      totalActiveChats: 6,
      totalResolvedToday: 124,
    );
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/admin/team');
        break;
      case 2:
        // TODO: Implement admin chats screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chats de Admin — Em integração'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 3:
        // TODO: Implement admin settings screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configurações — Em integração'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  void _showCreateMemberModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AdminColors.bgPrimary,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AdminDimensions.borderRadiusXL),
        ),
      ),
      builder: (context) => const CreateMemberModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdminColors.bgPrimary,
      body: Column(
        children: [
          AdminHeader(
            title: 'Dashboard',
            onMenuPressed: () {
              // TODO: Implement menu
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AdminDimensions.spacingBase),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // KPI Cards Grid
                  GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: AdminDimensions.spacingBase,
                    mainAxisSpacing: AdminDimensions.spacingBase,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      AdminKpiCard(
                        title: 'Online',
                        value: _summary.onlineMembers.toString(),
                        icon: Icons.headphones,
                        iconColor: AdminColors.statusGreen,
                        iconBgColor: AdminColors.statusGreen10,
                      ),
                      AdminKpiCard(
                        title: 'Ativos',
                        value: _summary.totalActiveChats.toString(),
                        icon: Icons.chat,
                        iconColor: AdminColors.statusYellow,
                        iconBgColor: AdminColors.statusYellow10,
                      ),
                      AdminKpiCard(
                        title: 'Resolvidos',
                        value: _summary.totalResolvedToday.toString(),
                        icon: Icons.check_circle,
                        iconColor: AdminColors.statusGreen,
                        iconBgColor: AdminColors.statusGreen10,
                      ),
                    ],
                  ),
                  SizedBox(height: AdminDimensions.spacingLG),
                  // Team Section Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Equipe Online',
                        style: AdminTextStyles.headingBase,
                      ),
                      AdminButton(
                        text: 'Criar Login',
                        onPressed: _showCreateMemberModal,
                        size: AdminButtonSize.sm,
                        icon: Icon(Icons.person_add, size: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: AdminDimensions.spacingBase),
                  // Team Members List
                  ..._teamMembers.where((member) => member.status == SupportStatus.online).map(
                    (member) => Padding(
                      padding: EdgeInsets.only(bottom: AdminDimensions.spacingBase),
                      child: AdminMemberCard(
                        member: member,
                        onTap: () {
                          // Navigate to team screen with member ID as argument
                          Navigator.pushNamed(
                            context,
                            '/admin/team',
                            arguments: {'memberId': member.id},
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

class CreateMemberModal extends StatefulWidget {
  const CreateMemberModal({super.key});

  @override
  State<CreateMemberModal> createState() => _CreateMemberModalState();
}

class _CreateMemberModalState extends State<CreateMemberModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isLoading = false;
  SupportCredentials? _credentials;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _createMember() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // TODO: Implement actual API call
    await Future.delayed(const Duration(seconds: 2));

    // Mock credentials
    setState(() {
      _credentials = SupportCredentials(
        id: 'support_new',
        name: _nameController.text,
        email: 'suporte-${_nameController.text.toLowerCase().replaceAll(' ', '-')}@gmail.com',
        password: 'TempPass123!',
        role: SupportRole.supportLevel1,
        createdAt: DateTime.now(),
        message: 'Login criado com sucesso. Envie as credenciais para o agente.',
      );
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AdminDimensions.spacingLG),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Criar Login de Suporte',
                      style: AdminTextStyles.headingBase,
                    ),
                    SizedBox(height: AdminDimensions.spacingXS),
                    Text(
                      'Gere credenciais para novo membro da equipe',
                      style: AdminTextStyles.bodyBase.copyWith(
                        color: AdminColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AdminColors.textPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: AdminColors.bgSecondary,
                    shape: const CircleBorder(),
                  ),
                ),
              ],
            ),
            SizedBox(height: AdminDimensions.spacingLG),
            if (_credentials == null) ...[
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AdminInput(
                      label: 'Nome do Agente',
                      placeholder: 'Ex: João Silva',
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        if (value.length < 2) {
                          return 'Nome deve ter pelo menos 2 caracteres';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: AdminDimensions.spacingLG),
                    AdminButton(
                      text: 'Gerar Credenciais',
                      onPressed: _createMember,
                      loading: _isLoading,
                      fullWidth: true,
                      icon: Icon(Icons.person_add, size: 20),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Success message and credentials
              AdminAlert(
                title: 'Credenciais Geradas com Sucesso!',
                message: _credentials!.message,
                type: AdminAlertType.success,
              ),
              SizedBox(height: AdminDimensions.spacingLG),
              AdminAlert(
                title: 'Informações Importantes',
                message: '',
                type: AdminAlertType.info,
                details: [
                  'Uma senha segura foi gerada automaticamente',
                  'Copie e envie as credenciais para o agente',
                  'O agente poderá alterar a senha no primeiro acesso',
                ],
              ),
              SizedBox(height: AdminDimensions.spacingLG),
              AdminCredentialsDisplay(credentials: _credentials!),
              SizedBox(height: AdminDimensions.spacingLG),
              AdminButton(
                text: 'Fechar',
                onPressed: () => Navigator.pop(context),
                fullWidth: true,
                variant: AdminButtonVariant.secondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}