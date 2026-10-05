import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'secure_storage_service.dart';

/// Serviço de API com segurança implementada
class ApiSecurityService {
  /// Base da API. Override no build:
  /// `flutter build apk --dart-define=API_BASE_URL=https://sua-api.com`
  /// Default sem `/v1` (o nginx também remove `/v1` por compatibilidade).
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.san1typay.com',
  );
  static const Duration requestTimeout = Duration(seconds: 60);
  
  final SecureStorageService _secureStorage = SecureStorageService();
  final http.Client _httpClient = http.Client();

  /// Headers padrão seguros para requisições
  Future<Map<String, String>> _getSecureHeaders() async {
    final token = await _secureStorage.getAuthToken();
    final paymentSession = await _secureStorage.getPaymentSession();
    final deviceId = await _secureStorage.getOrCreateDeviceId();

    return {
      'Content-Type': 'application/json; charset=utf-8',
      'Accept': 'application/json',
      'X-API-Version': '1.0',
      'X-Client-Platform': 'flutter-mobile',
      'X-Request-ID': _generateRequestId(),
      'X-Device-Id': deviceId,
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
      // Credencial de leitura do polling (backend exige nas leituras).
      if (paymentSession != null && paymentSession.isNotEmpty)
        'X-Session-Id': paymentSession,
    };
  }

  /// ID único por requisição (UUIDv4 via CSPRNG; rastreio + idempotência).
  String _generateRequestId() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    bytes[6] = (bytes[6] & 0x0F) | 0x40; // versão 4
    bytes[8] = (bytes[8] & 0x3F) | 0x80; // variante RFC 4122
    final hex =
        bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-'
        '${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
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