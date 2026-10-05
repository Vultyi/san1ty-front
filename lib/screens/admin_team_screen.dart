import 'package:flutter/material.dart';
import '../theme/admin_colors.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_header.dart';
import '../widgets/admin_bottom_nav.dart';
import '../widgets/admin_member_card.dart';
import '../widgets/admin_button.dart';
import '../widgets/admin_input.dart';
import '../widgets/admin_alert.dart';
import '../widgets/admin_credentials_display.dart';
import '../models/admin_models.dart';

class AdminTeamScreen extends StatefulWidget {
  const AdminTeamScreen({super.key});

  @override
  State<AdminTeamScreen> createState() => _AdminTeamScreenState();
}

class _AdminTeamScreenState extends State<AdminTeamScreen> {
  int _currentIndex = 1;
  late List<SupportMember> _teamMembers;
  String _selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
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
      SupportMember(
        id: 'support_3',
        name: 'Carlos Santos',
        email: 'suporte-carlos-santos@gmail.com',
        avatar: 'CS',
        role: SupportRole.supportLevel1,
        status: SupportStatus.away,
        stats: SupportStats(
          loggedTime: '5h 12min',
          loggedTimeMinutes: 312,
          chatsActive: 1,
          chatsResolved: 22,
          avgResponseTime: '3min',
          avgResponseTimeSeconds: 180,
          satisfaction: 4.6,
          lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        ),
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      SupportMember(
        id: 'support_4',
        name: 'Ana Pereira',
        email: 'suporte-ana-pereira@gmail.com',
        avatar: 'AP',
        role: SupportRole.supportTechnical,
        status: SupportStatus.offline,
        stats: SupportStats(
          loggedTime: '0h 0min',
          loggedTimeMinutes: 0,
          chatsActive: 0,
          chatsResolved: 0,
          avgResponseTime: '0min',
          avgResponseTimeSeconds: 0,
          satisfaction: 0.0,
          lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
    ];
  }

  void _onNavTap(int index) {
    setState(() => _currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/admin/dashboard');
        break;
      case 1:
        // Already on team
        break;
      case 2:
        // Admin chats - not yet implemented
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Chats do admin em breve!')),
        );
        break;
      case 3:
        // Admin settings - not yet implemented
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Configurações do admin em breve!')),
        );
        break;
    }
  }

  List<SupportMember> get _filteredMembers {
    if (_selectedStatus == 'all') return _teamMembers;

    final status = _selectedStatus == 'online'
        ? SupportStatus.online
        : _selectedStatus == 'away'
            ? SupportStatus.away
            : SupportStatus.offline;

    return _teamMembers.where((member) => member.status == status).toList();
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
            title: 'Equipe',
            onMenuPressed: () {
              // TODO: Implement menu
            },
          ),
          // Status Filter
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AdminDimensions.spacingBase,
              vertical: AdminDimensions.spacingSM,
            ),
            child: Row(
              children: [
                _StatusFilterChip(
                  label: 'Todos',
                  isSelected: _selectedStatus == 'all',
                  onTap: () => setState(() => _selectedStatus = 'all'),
                ),
                SizedBox(width: AdminDimensions.spacingSM),
                _StatusFilterChip(
                  label: 'Online',
                  isSelected: _selectedStatus == 'online',
                  color: AdminColors.statusGreen,
                  onTap: () => setState(() => _selectedStatus = 'online'),
                ),
                SizedBox(width: AdminDimensions.spacingSM),
                _StatusFilterChip(
                  label: 'Ausente',
                  isSelected: _selectedStatus == 'away',
                  color: AdminColors.statusYellow,
                  onTap: () => setState(() => _selectedStatus = 'away'),
                ),
                SizedBox(width: AdminDimensions.spacingSM),
                _StatusFilterChip(
                  label: 'Offline',
                  isSelected: _selectedStatus == 'offline',
                  color: AdminColors.textSecondary,
                  onTap: () => setState(() => _selectedStatus = 'offline'),
                ),
              ],
            ),
          ),
          // Create Button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AdminDimensions.spacingBase),
            child: AdminButton(
              text: 'Criar Novo Membro',
              onPressed: _showCreateMemberModal,
              fullWidth: true,
              icon: Icon(Icons.person_add, size: 20),
            ),
          ),
          SizedBox(height: AdminDimensions.spacingBase),
          // Team Members List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(AdminDimensions.spacingBase),
              itemCount: _filteredMembers.length,
              itemBuilder: (context, index) {
                final member = _filteredMembers[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: AdminDimensions.spacingBase),
                  child: AdminMemberCard(
                    member: member,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/admin/team/${member.id}',
                      );
                    },
                  ),
                );
              },
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

class _StatusFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color? color;
  final VoidCallback onTap;

  const _StatusFilterChip({
    required this.label,
    required this.isSelected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AdminDimensions.spacingBase,
          vertical: AdminDimensions.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (color ?? AdminColors.accentCyan).withOpacity(0.2)
              : AdminColors.bgSecondary,
          border: Border.all(
            color: isSelected
                ? (color ?? AdminColors.accentCyan)
                : AdminColors.borderPrimary,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(AdminDimensions.borderRadiusBase),
        ),
        child: Text(
          label,
          style: AdminTextStyles.labelBase.copyWith(
            color: isSelected
                ? (color ?? AdminColors.accentCyan)
                : AdminColors.textSecondary,
          ),
        ),
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