// lib/services/admin_service.dart
import 'package:estrutura_front_san1ty/services/auth_service.dart';

/// Autenticação das áreas admin/suporte contra o backend (App).
///
/// O login fake original aceitava qualquer credencial — agora o acesso
/// exige JWT válido + role elevada lida de `GET /api/auth/me`.
class AdminService {
  final AuthService _authService = AuthService();

  /// Roles que podem entrar no painel admin.
  static const List<String> adminRoles = [
    'admin',
    'compliance_officer',
    'support',
  ];

  /// Roles que podem entrar no painel de suporte.
  static const List<String> supportRoles = [
    'support',
    'admin',
  ];

  /// Faz login e valida a role. Retorna `{success, user}` ou `{success, error}`.
  Future<Map<String, dynamic>> loginWithRole({
    required String email,
    required String password,
    required List<String> allowedRoles,
  }) async {
    final result = await _authService.login(email, password);
    if (result['success'] != true) {
      return result;
    }
    final data = result['data'] as Map<String, dynamic>?;
    final user = data?['user'] as Map<String, dynamic>?;
    final role = (user?['role'] ?? 'user').toString();
    if (!allowedRoles.contains(role)) {
      await _authService.logout();
      return {
        'success': false,
        'error': 'Acesso negado para o seu perfil ($role).',
      };
    }
    return result;
  }

  /// Atalho para o painel admin.
  Future<Map<String, dynamic>> loginAdmin(String email, String password) {
    return loginWithRole(
      email: email,
      password: password,
      allowedRoles: adminRoles,
    );
  }

  /// Atalho para o painel de suporte.
  Future<Map<String, dynamic>> loginSupport(String email, String password) {
    return loginWithRole(
      email: email,
      password: password,
      allowedRoles: supportRoles,
    );
  }
}
