# San1ty Pay Admin Panel

## 📱 Visão Geral

O painel de administração do San1ty Pay é uma interface completa para gerenciar a equipe de suporte, monitorar métricas em tempo real e administrar operações do sistema. Construído com Flutter, oferece uma experiência dark e moderna focada em produtividade.

## 🎨 Design System

### Paleta de Cores
- **Background**: `#0A0A0A` (bgPrimary), `#111111` (bgSecondary), `#1A1A1A` (bgTertiary)
- **Borders**: `#222222` (borderPrimary), `#333333` (borderSecondary)
- **Text**: `#FFFFFF` (textPrimary), `#9CA3AF` (textSecondary), `#6B7280` (textTertiary)
- **Accent**: Gradiente Cyan/Blue (`#06B6D4` → `#2563EB`)
- **Status**: Verde (`#4ADE80`), Amarelo (`#FBBF24`), Vermelho (`#EF4444`)

### Tipografia
- **Fonte**: System Default (Roboto/SF Pro)
- **Pesos**: Regular (400), Medium (500), SemiBold (600), Bold (700), Black (900)
- **Tamanhos**: XS (12px), SM (14px), Base (16px), LG (18px), XL (20px), 2XL (24px)

### Componentes Principais
- **Header**: Logo com gradiente + título + botão menu
- **Bottom Navigation**: 4 abas (Dashboard, Equipe, Chats, Configurações)
- **Cards**: KPI cards, member cards com status e métricas
- **Buttons**: Primary (gradiente), Secondary (transparente), Outline, Ghost
- **Inputs**: Text fields com validação e estados visuais
- **Alerts**: Success, Warning, Info, Error com ícones e cores específicas

## 🏗️ Arquitetura

### Estrutura de Pastas
```
lib/
├── theme/
│   ├── admin_colors.dart      # Paleta de cores e gradientes
│   └── admin_theme.dart       # Tipografia, dimensões, estilos
├── models/
│   └── admin_models.dart      # Models de dados (AdminUser, SupportMember, etc.)
├── widgets/
│   ├── admin_button.dart      # Botões com variantes
│   ├── admin_card.dart        # Cards base
│   ├── admin_kpi_card.dart    # Cards de métricas
│   ├── admin_member_card.dart # Cards de membros da equipe
│   ├── admin_input.dart       # Campos de entrada
│   ├── admin_header.dart      # Cabeçalho da tela
│   ├── admin_bottom_nav.dart  # Navegação inferior
│   ├── admin_alert.dart       # Alertas/notificações
│   └── admin_credentials_display.dart # Exibição de credenciais
└── screens/
    ├── admin_login_screen.dart    # Tela de login admin
    ├── admin_dashboard_screen.dart # Dashboard principal
    └── admin_team_screen.dart     # Gerenciamento da equipe
```

### Models de Dados

#### SupportMember
```dart
class SupportMember {
  final String id, name, email, avatar;
  final SupportRole role;
  final SupportStatus status;
  final SupportStats stats;
  final DateTime lastActivity, createdAt;
}
```

#### SupportStats
```dart
class SupportStats {
  final String loggedTime;
  final int loggedTimeMinutes, chatsActive, chatsResolved;
  final String avgResponseTime;
  final int avgResponseTimeSeconds;
  final double satisfaction;
  final DateTime lastActivity;
}
```

## 📡 API Integration

### Base URL
```
https://api.san1typay.com/v1
```

### Autenticação
```http
POST /auth/admin/login
{
  "email": "admin@san1typay.com",
  "password": "senha_segura"
}
```

### Endpoints Principais

#### Listar Membros da Equipe
```http
GET /admin/team/members
Authorization: Bearer {admin_token}
```

#### Criar Login de Suporte
```http
POST /admin/team/create-member
{
  "name": "João Silva",
  "role": "support_level_1"
}
```

#### WebSocket para Real-Time
```
ws://api.san1typay.com/ws/admin
Eventos: chat:started, support:status_changed, stats:updated
```

## 🚀 Funcionalidades

### ✅ Implementadas
- [x] Tela de login admin com validação
- [x] Dashboard com métricas em tempo real
- [x] Monitoramento da equipe online
- [x] Cards de membros com status e estatísticas
- [x] Modal de criação de login de suporte
- [x] Geração e exibição de credenciais
- [x] Filtros por status (Online/Ausente/Offline)
- [x] Design system completo e consistente
- [x] Navegação entre telas
- [x] Responsividade mobile-first

### 🔄 Próximas Implementações
- [ ] Tela de chats para visualizar conversas
- [ ] Tela de configurações do sistema
- [ ] Detalhes individuais dos membros
- [ ] Gráficos de performance
- [ ] Notificações push
- [ ] Export de relatórios
- [ ] Integração completa com APIs reais
- [ ] WebSocket para updates em tempo real

## 🎯 Como Usar

### Acesso ao Painel
1. Navegue para `/admin/login`
2. Entre com credenciais de administrador
3. Dashboard será carregado automaticamente

### Criar Novo Membro
1. No Dashboard ou tela Equipe, clique "Criar Login"
2. Preencha o nome do agente
3. Sistema gera email e senha automaticamente
4. Copie as credenciais e envie para o agente

### Monitorar Equipe
- **Dashboard**: Visão geral dos membros online
- **Equipe**: Lista completa com filtros por status
- **Cards**: Métricas individuais (tempo logado, chats ativos, satisfação)

## 🔧 Desenvolvimento

### Dependências
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.0.0          # Para chamadas API
  web_socket_channel: ^2.4.0  # WebSocket
  provider: ^6.0.0      # State management
```

### Executar
```bash
flutter run --flavor admin
```

### Build para Produção
```bash
flutter build web --flavor admin
```

## 📊 Métricas Monitoradas

### Por Membro
- Tempo logado (hoje/semana/mês)
- Chats ativos e resolvidos
- Tempo médio de resposta
- Satisfação do cliente (⭐ 1-5)

### Gerais
- Total de membros online
- Chats ativos no sistema
- Resoluções do dia
- Performance média da equipe

## 🔒 Segurança

- **Acesso Restrito**: Apenas administradores autorizados
- **JWT Tokens**: Autenticação stateless
- **HTTPS Only**: Todas as comunicações criptografadas
- **Role-based Access**: Controle granular de permissões
- **Audit Logs**: Rastreamento de todas as ações

## 📱 Responsividade

- **Mobile-first**: Otimizado para dispositivos móveis
- **Tablet Support**: Layout adaptável
- **Landscape Mode**: Suporte a orientação horizontal
- **Touch-friendly**: Botões e áreas de toque adequadas

## 🎨 Customização

### Alterar Cores
Edite `lib/theme/admin_colors.dart`:
```dart
class AdminColors {
  static const Color accentCyan = Color(0xFF06B6D4); // Mude aqui
}
```

### Modificar Tipografia
Edite `lib/theme/admin_theme.dart`:
```dart
class AdminTextStyles {
  static const TextStyle headingLarge = TextStyle(
    fontSize: 24, // Ajuste tamanho
    fontWeight: FontWeight.w900,
    color: AdminColors.textPrimary,
  );
}
```

## 🐛 Troubleshooting

### Problemas Comuns
1. **Login falha**: Verifique credenciais e conexão
2. **WebSocket não conecta**: Verifique firewall e URL
3. **UI não atualiza**: Force refresh ou limpe cache

### Debug Mode
```dart
// Habilitar logs detalhados
debugPrint('Admin Panel Debug: ${data}');
```

## 📝 Changelog

### v1.0.0 (Atual)
- Implementação inicial completa
- Design system estabelecido
- Funcionalidades core implementadas
- Base para futuras expansões

---

**Desenvolvido para San1ty Pay**  
**Data**: Janeiro 2025  
**Versão**: 1.0.0