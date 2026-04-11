// lib/core/security/api_security_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage_service.dart';

/// Serviço de API com segurança implementada
class ApiSecurityService {
  static const String baseUrl = 'https://api.san1typay.com/v1';
  static const Duration requestTimeout = Duration(seconds: 30);
  
  final SecureStorageService _secureStorage = SecureStorageService();
  final http.Client _httpClient = http.Client();

  /// Headers padrão seguros para requisições
  Future<Map<String, String>> _getSecureHeaders() async {
    final token = await _secureStorage.getAuthToken();
    
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'X-API-Version': '1.0',
      'X-Client-Platform': 'flutter-mobile',
      'X-Request-ID': _generateRequestId(),
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
    };
  }

  /// Gera um ID único para cada requisição (para tracking de segurança)
  String _generateRequestId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  /// GET seguro
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final headers = await _getSecureHeaders();
      final response = await _httpClient
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(requestTimeout);

      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// POST seguro
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final headers = await _getSecureHeaders();
      final response = await _httpClient
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(requestTimeout);

      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// PATCH seguro
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    required Map<String, dynamic> body,
  }) async {
    try {
      final headers = await _getSecureHeaders();
      final response = await _httpClient
          .patch(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
            body: jsonEncode(body),
          )
          .timeout(requestTimeout);

      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// DELETE seguro
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final headers = await _getSecureHeaders();
      final response = await _httpClient
          .delete(
            Uri.parse('$baseUrl$endpoint'),
            headers: headers,
          )
          .timeout(requestTimeout);

      return _handleResponse(response);
    } on Exception catch (e) {
      return _handleError(e);
    }
  }

  /// Trata resposta seguramente
  Map<String, dynamic> _handleResponse(http.Response response) {
    // Verifica status code
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        return {
          'success': false,
          'error': 'Erro ao decodificar resposta',
        };
      }
    }

    // Trata erros de autenticação
    if (response.statusCode == 401) {
      _secureStorage.clearAll();
      return {
        'success': false,
        'error': 'Sessão expirada. Por favor, faça login novamente.',
        'code': 'AUTH_EXPIRED',
      };
    }

    // Trata outros erros HTTP
    return {
      'success': false,
      'error': _getErrorMessage(response.statusCode),
      'code': response.statusCode,
    };
  }

  /// Trata erros de requisição
  Map<String, dynamic> _handleError(Exception error) {
    return {
      'success': false,
      'error': 'Erro de conexão. Tente novamente.',
      'details': error.toString(),
    };
  }

  /// Retorna mensagem de erro baseada no status code
  String _getErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Requisição inválida';
      case 403:
        return 'Acesso negado';
      case 404:
        return 'Recurso não encontrado';
      case 429:
        return 'Muitas requisições. Tente novamente mais tarde.';
      case 500:
        return 'Erro no servidor. Tente novamente mais tarde.';
      case 503:
        return 'Serviço indisponível.';
      default:
        return 'Erro na requisição (código: $statusCode)';
    }
  }

  /// Logout seguro - limpa todos os tokens
  Future<void> logout() async {
    await _secureStorage.clearAll();
  }
}