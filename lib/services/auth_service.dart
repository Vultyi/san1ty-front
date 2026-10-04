// lib/services/auth_service.dart

import 'dart:convert';
import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';
import 'package:estrutura_front_san1ty/core/security/secure_storage_service.dart';

/// Handles authentication operations for the San1ty Pay application.
///
/// All network calls are delegated to [ApiSecurityService], which enforces
/// secure headers, timeouts and automatic session cleanup on 401 responses.
/// Tokens are persisted locally via [SecureStorageService].
class AuthService {
  final ApiSecurityService _apiService = ApiSecurityService();
  final SecureStorageService _storageService = SecureStorageService();

  /// Authenticates the user and stores the received tokens locally.
  ///
  /// Backend retorna flat `{access_token, refresh_token}` (sem envelope);
  /// o perfil vem de `GET /api/auth/me`. O retorno aqui mantém o formato
  /// `{success, data:{accessToken, refreshToken, user}}` que as telas usam.
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/api/auth/login', body: {
        'email': email,
        'password': password,
      });

      final accessToken = response['access_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        return {
          'success': false,
          'error': response['error'] ?? 'Erro desconhecido no login.',
        };
      }
      await _storageService.saveAuthToken(accessToken);
      final refreshToken = response['refresh_token'] as String?;
      if (refreshToken != null) {
        await _storageService.saveRefreshToken(refreshToken);
      }
      final me = await _apiService.get('/api/auth/me');
      final user = (me['email'] != null) ? me : <String, dynamic>{};
      await _storageService.saveUserData(jsonEncode(user));
      return {
        'success': true,
        'data': {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
          'user': user,
        },
      };
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

  /// Clears all locally stored tokens and user data, effectively ending
  /// the current session on this device.
  Future<void> logout() async {
    await _storageService.clearAll();
  }

  /// Reentrada com biometria: exige biometric + troca o refresh guardado
  /// por um par novo (`POST /api/auth/refresh?refresh_token=`).
  /// O refresh antigo é revogado no servidor (rotation).
  Future<Map<String, dynamic>> loginWithBiometrics(
    Future<bool> Function() authenticate,
  ) async {
    try {
      final ok = await authenticate();
      if (!ok) {
        return {'success': false, 'error': 'Biometria não confirmada.'};
      }
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return {'success': false, 'error': 'Sessão expirada. Faça login.'};
      }
      final response = await _apiService.post(
        '/api/auth/refresh?refresh_token=$refreshToken',
        body: <String, dynamic>{},
      );
      final accessToken = response['access_token'] as String?;
      if (accessToken == null || accessToken.isEmpty) {
        await _storageService.clearAll();
        return {
          'success': false,
          'error': response['error'] ?? 'Sessão expirada. Faça login.',
        };
      }
      await _storageService.saveAuthToken(accessToken);
      final newRefresh = response['refresh_token'] as String?;
      if (newRefresh != null) {
        await _storageService.saveRefreshToken(newRefresh);
      }
      final me = await _apiService.get('/api/auth/me');
      final user = (me['email'] != null) ? me : <String, dynamic>{};
      await _storageService.saveUserData(jsonEncode(user));
      return {
        'success': true,
        'data': {
          'accessToken': accessToken,
          'refreshToken': newRefresh,
          'user': user,
        },
      };
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

  /// Returns true when a non-empty access token is present in local storage.
  ///
  /// Does not validate the token against the server — use this only for
  /// local navigation guards. The server will reject expired tokens regardless.
  Future<bool> isLoggedIn() async {
    final token = await _storageService.getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Returns the authenticated user's profile from local storage, or null
  /// when no session data is available.
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final userDataString = await _storageService.getUserData();
      if (userDataString == null || userDataString.isEmpty) {
        return null;
      }
      return jsonDecode(userDataString) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  /// Registers a new user account.
  ///
  /// Backend: `POST /api/auth/signup` `{email, password, full_name}`.
  /// O `phone` da tela não tem campo no backend — não é enviado.
  /// Retorna `{success: true}` para o fluxo atual das telas.
  Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String name,
    String? phone,
  }) async {
    try {
      final response = await _apiService.post('/api/auth/signup', body: {
        'email': email,
        'password': password,
        'full_name': name,
      });
      // Backend devolve 201 com o perfil flat (sem envelope success);
      // _handleResponse só retorna mapa em 2xx — chegou aqui, criou.
      if (response.containsKey('id') || response.containsKey('email')) {
        return {'success': true, 'data': response};
      }
      return {
        'success': false,
        'error': response['error'] ?? 'Erro desconhecido no registro.',
      };
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }

  /// Requests a password reset email for the given address.
  ///
  /// Always returns a success-like response to the UI regardless of
  /// whether the email exists, preventing email enumeration.
  Future<Map<String, dynamic>> requestPasswordReset(String email) async {
    try {
      return await _apiService.post('/api/auth/forgot-password', body: {
        'email': email,
      });
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro de conexão. Verifique sua internet e tente novamente.',
      };
    }
  }
}
/// Código de verificação por email (signup / recuperação).
extension EmailCodeExtension on AuthService {
  Future<Map<String, dynamic>> sendEmailCode(String email,
      {String purpose = 'signup'}) async {
    try {
      final response = await _apiService.post('/api/auth/email/send-code', body: {
        'email': email,
        'purpose': purpose,
      });
      if (response['success'] == false) {
        return {'success': false, 'error': response['error']?.toString() ?? 'Tente novamente.'};
      }
      return {'success': true, 'data': response};
    } catch (_) {
      return {'success': false, 'error': 'Erro de conexão. Tente novamente.'};
    }
  }

  Future<Map<String, dynamic>> verifyEmailCode(
      String email, String code,
      {String purpose = 'signup'}) async {
    try {
      final response = await _apiService.post('/api/auth/email/verify-code', body: {
        'email': email,
        'purpose': purpose,
        'code': code,
      });
      if (response['success'] == false) {
        return {'success': false, 'error': _friendly(response['error'] ?? '')};
      }
      return {'success': true};
    } on Exception catch (e) {
      return {'success': false, 'error': _friendly(e)};
    }
  }

  Future<Map<String, dynamic>> resetPasswordWithCode(
      String email, String code, String newPassword) async {
    try {
      final response = await _apiService.post('/api/auth/email/reset-password', body: {
        'email': email,
        'code': code,
        'new_password': newPassword,
      });
      if (response['success'] == false) {
        return {'success': false, 'error': _friendly(response['error'] ?? '')};
      }
      return {'success': true};
    } on Exception catch (e) {
      return {'success': false, 'error': _friendly(e)};
    }
  }

  String _friendly(Object e) {
    final s = e.toString();
    if (s.contains('400') || s.contains('Código inválido')) {
      return 'Código inválido ou expirado.';
    }
    if (s.contains('429')) return 'Muitas tentativas. Aguarde um pouco.';
    return 'Erro de conexão. Tente novamente.';
  }
}
