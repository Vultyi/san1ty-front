import 'package:flutter/material.dart';
import 'package:estrutura_front_san1ty/theme/support_theme.dart';
import 'package:estrutura_front_san1ty/theme/support_colors.dart';
import 'package:estrutura_front_san1ty/models/support_models.dart';
import 'package:estrutura_front_san1ty/widgets/support_sidebar.dart';
import 'package:estrutura_front_san1ty/widgets/support_components.dart';
import 'package:estrutura_front_san1ty/widgets/support_badge.dart';
import 'package:estrutura_front_san1ty/widgets/support_button.dart';

class SupportChatsScreen extends StatefulWidget {
  static const String routeName = '/support-chats';

  const SupportChatsScreen({super.key});

  @override
  State<SupportChatsScreen> createState() => _SupportChatsScreenState();
}

class _SupportChatsScreenState extends State<SupportChatsScreen> {
  String _currentRoute = '/support-chats';
  late List<SupportChat> _chats;
  late SupportChat? _selectedChat;
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chats = [
      SupportChat(
        id: '1',
        userName: 'João Silva',
        email: 'joao@email.com',
        lastMessage: 'Conseguiu resolver meu problema?',
        time: '2 min',
        status: 'em_atendimento',
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      SupportChat(
        id: '2',
        userName: 'Maria Santos',
        email: 'maria@email.com',
        lastMessage: 'Obrigada pela ajuda!',
        time: '15 min',
        status: 'encerrado',
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      SupportChat(
        id: '3',
        userName: 'Pedro Costa',
        email: 'pedro@email.com',
        lastMessage: 'Estou com dificuldade em fazer o PIX',
        time: '30 min',
        status: 'novo',
        unreadCount: 1,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
    _selectedChat = _chats.first;
  }

  void _handleNavigation(String route) {
    setState(() => _currentRoute = route);
  }

  void _handleLogout() {
    Navigator.pushReplacementNamed(context, '/support-login');
  }

  void _handleSendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      _messageController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mensagem enviada!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SupportColors.bgPrimary,
      body: Row(
        children: [
          // Sidebar
          SupportSidebar(
            attendantName: 'Carlos Silva',
            currentRoute: _currentRoute,
            onNavigate: _handleNavigation,
            onLogout: _handleLogout,
          ),
          // Chat List
          Container(
            width: SupportDimensions.chatListWidth,
            color: SupportColors.bgSecondary,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: SupportColors.borderPrimary,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    'Chats de Suporte',
                    style: SupportTypography.headingLg.copyWith(
                      color: SupportColors.textPrimary,
                    ),
                  ),
                ),
                // Chat List
                Expanded(
                  child: ListView.builder(
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      final isSelected = _selectedChat?.id == chat.id;
                      return _buildChatItem(chat, isSelected);
                    },
                  ),
                ),
              ],
            ),
          ),
          // Chat Area
          Expanded(
            child: Column(
              children: [
                // Chat Header
                if (_selectedChat != null)
                  _buildChatHeader(_selectedChat!)
                else
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Selecione um chat',
                      style: SupportTypography.bodyBase.copyWith(
                        color: SupportColors.textTertiary,
                      ),
                    ),
                  ),
                // Messages Area
                if (_selectedChat != null)
                  Expanded(
                    child: Container(
                      color: SupportColors.bgPrimary,
                      padding: const EdgeInsets.all(16),
                      child: ListView(
                        children: [
                          _buildMessage(
                            'Oi, estou com um problema...',
                            'user',
                            '10:30',
                          ),
                          const SizedBox(height: 16),
                          _buildMessage(
                            'Claro! como posso ajudar?',
                            'support',
                            '10:31',
                          ),
                          const SizedBox(height: 16),
                          _buildMessage(
                            'Não consigo fazer um PIX',
                            'user',
                            '10:32',
                          ),
                        ],
                      ),
                    ),
                  ),
                // Input Area
                if (_selectedChat != null) _buildInputArea(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem(SupportChat chat, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _selectedChat = chat),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? SupportColors.bgTertiary : Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: SupportColors.borderPrimary,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            SupportAvatar(
              initials: chat.userName.substring(0, 2).toUpperCase(),
              size: SupportDimensions.avatarBase,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chat.userName,
                        style: SupportTypography.bodySm.copyWith(
                          fontWeight: FontWeight.w500,
                          color: SupportColors.textPrimary,
                        ),
                      ),
                      Text(
                        chat.time,
                        style: SupportTypography.bodyXs.copyWith(
                          color: SupportColors.textDisabled,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chat.lastMessage,
                    style: SupportTypography.bodyXs.copyWith(
                      color: SupportColors.textTertiary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      SupportBadge(
                        text: _getStatusLabel(chat.status),
                        variant: _getStatusVariant(chat.status),
                      ),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        SupportBadge(
                          text: chat.unreadCount.toString(),
                          variant: SupportBadgeVariant.error,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatHeader(SupportChat chat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportColors.bgSecondary,
        border: Border(
          bottom: BorderSide(
            color: SupportColors.borderPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SupportAvatar(
            initials: chat.userName.substring(0, 2).toUpperCase(),
            size: SupportDimensions.avatarBase,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.userName,
                  style: SupportTypography.bodyBase.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SupportColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                SupportBadge(
                  text: _getStatusLabel(chat.status),
                  variant: _getStatusVariant(chat.status),
                ),
              ],
            ),
          ),
          SupportButton(
            text: 'Marcar Resolvido',
            onPressed: () {},
            size: SupportButtonSize.sm,
            variant: SupportButtonVariant.primary,
          ),
          const SizedBox(width: 8),
          SupportButton(
            text: 'Encerrar',
            onPressed: () {},
            size: SupportButtonSize.sm,
            variant: SupportButtonVariant.outline,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, String sender, String time) {
    final isSupport = sender == 'support';

    return Align(
      alignment: isSupport ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isSupport
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.4,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isSupport
                  ? SupportColors.brandPrimary
                  : SupportColors.bgTertiary,
              borderRadius: SupportBorderRadius.radiusLg,
            ),
            child: Text(
              text,
              style: SupportTypography.bodySm.copyWith(
                color: isSupport ? Colors.white : SupportColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$time • ${isSupport ? "Você" : "Usuário"}',
            style: SupportTypography.bodyXs.copyWith(
              color: SupportColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: SupportColors.bgSecondary,
        border: Border(
          top: BorderSide(
            color: SupportColors.borderPrimary,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: SupportDimensions.inputHeightBase,
              decoration: BoxDecoration(
                color: SupportColors.bgTertiary,
                borderRadius: SupportBorderRadius.radiusLg,
                border: Border.all(
                  color: SupportColors.borderSecondary,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _messageController,
                style: SupportTypography.bodyBase.copyWith(
                  color: SupportColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  hintStyle: SupportTypography.bodyBase.copyWith(
                    color: SupportColors.textQuaternary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) => _handleSendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: SupportDimensions.buttonHeightBase,
            height: SupportDimensions.buttonHeightBase,
            child: ElevatedButton(
              onPressed: _handleSendMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: SupportColors.brandPrimary,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: SupportBorderRadius.radiusLg,
                ),
              ),
              child: Icon(
                Icons.send,
                size: SupportDimensions.iconSm,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'novo':
        return 'Novo';
      case 'em_atendimento':
        return 'Em atendimento';
      case 'encerrado':
        return 'Encerrado';
      default:
        return status;
    }
  }

  SupportBadgeVariant _getStatusVariant(String status) {
    switch (status) {
      case 'novo':
        return SupportBadgeVariant.info;
      case 'em_atendimento':
        return SupportBadgeVariant.success;
      case 'encerrado':
        return SupportBadgeVariant.defaultBadge;
      default:
        return SupportBadgeVariant.defaultBadge;
    }
  }
}
