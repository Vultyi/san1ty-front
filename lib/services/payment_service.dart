// lib/services/payment_service.dart

import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';
import 'package:estrutura_front_san1ty/core/security/secure_storage_service.dart';

/// Handles all payment-related API calls for the San1ty Pay application.
///
/// Delegates network operations to [ApiSecurityService], which enforces
/// secure headers and automatic session handling.
class PaymentService {
  final ApiSecurityService _apiService = ApiSecurityService();
  final SecureStorageService _secureStorage = SecureStorageService();

  /// Initiates a new payment intent on the platform.
  ///
  /// [currency] — ISO 4217 currency code (e.g. `BRL`).
  /// [amount]   — Value in the currency's base unit.
  /// [description] — Optional human-readable description for the transaction.
  ///
  /// Returns the server response containing the payment reference on success.
  Future<Map<String, dynamic>> createPayment({
    required String currency,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await _apiService.post('/api/payment/create', body: {
        'currency': currency,
        'amount': amount,
        if (description != null) 'description': description,
      });
      // Persiste a credencial de sessão emitida pelo backend para o polling.
      final sessionId = response['session_id'] as String?;
      if (response['success'] != false && sessionId != null && sessionId.isNotEmpty) {
        await _secureStorage.savePaymentSession(sessionId);
      }
      return response;
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao criar pagamento. Tente novamente.',
      };
    }
  }

  /// Queries the current status of a payment by its identifier.
  ///
  /// [paymentId] — Unique identifier returned by [createPayment].
  Future<Map<String, dynamic>> getPaymentStatus(String paymentId) async {
    try {
      return await _apiService.get('/api/payment/$paymentId/status');
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao consultar status do pagamento.',
      };
    }
  }

  /// Retrieves a paginated list of the user's past transactions.
  ///
  /// [page]  — 1-based page index (default: 1).
  /// [limit] — Maximum number of records per page (default: 20).
  Future<Map<String, dynamic>> getTransactionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      return await _apiService.get(
        '/api/payment/history?page=$page&limit=$limit',
      );
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao carregar histórico.',
        'transactions': <dynamic>[],
      };
    }
  }

  /// Returns a consolidated financial statement for the authenticated user.
  ///
  /// When [startDate] and [endDate] are both provided the results are
  /// filtered to that date range (ISO 8601 strings, e.g. `2026-01-01`).
  Future<Map<String, dynamic>> getStatement({
    String? startDate,
    String? endDate,
  }) async {
    try {
      final hasRange = startDate != null && endDate != null;
      final url = hasRange
          ? '/api/payment/statement?start_date=$startDate&end_date=$endDate'
          : '/api/payment/statement';

      return await _apiService.get(url);
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao carregar extrato.',
      };
    }
  }

  /// Processes a PIX payment to the specified key.
  ///
  /// [pixKey]     — Destination PIX key (CPF, CNPJ, phone, email or random key).
  /// [amount]     — Amount to transfer in BRL.
  /// [description] — Optional transfer description visible to both parties.
  Future<Map<String, dynamic>> processPixPayment({
    required String pixKey,
    required double amount,
    String? description,
  }) async {
    try {
      return await _apiService.post('/api/payment/mercado-pago/pix', body: {
        'pix_key': pixKey,
        'amount': amount,
        if (description != null) 'description': description,
      });
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao processar pagamento PIX.',
      };
    }
  }

  /// Registers a new PIX key for the authenticated user.
  ///
  /// [keyType]  — Key type: `cpf`, `cnpj`, `phone`, `email` or `random`.
  /// [keyValue] — The actual key value corresponding to the type.
  Future<Map<String, dynamic>> registerPixKey({
    required String keyType,
    required String keyValue,
  }) async {
    try {
      return await _apiService.post('/api/payment/pix/register-key', body: {
        'key_type': keyType,
        'key_value': keyValue,
      });
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao registrar chave PIX.',
      };
    }
  }

  /// Returns all PIX keys registered by the authenticated user.
  Future<Map<String, dynamic>> getPixKeys() async {
    try {
      return await _apiService.get('/api/payment/pix/keys');
    } catch (_) {
      return {
        'success': false,
        'error': 'Erro ao carregar chaves PIX.',
        'keys': <dynamic>[],
      };
    }
  }
}
/// Status de uma cobrança Pix para a tela de Vendas.
enum PaymentStatus { pending, paid, expired }

/// Cobrança Pix criada para compartilhar com o cliente.
class PixCharge {
  final String id;
  final int amountCents;
  final String pixCode;
  final PaymentStatus status;

  const PixCharge({
    required this.id,
    required this.amountCents,
    required this.pixCode,
    required this.status,
  });

  PixCharge copyWith({PaymentStatus? status}) => PixCharge(
        id: id,
        amountCents: amountCents,
        pixCode: pixCode,
        status: status ?? this.status,
      );
}

/// Erro de fluxo de cobrança com mensagem pronta para a UI.
class PaymentException implements Exception {
  final String message;
  const PaymentException(this.message);

  @override
  String toString() => message;
}

PaymentStatus _mapStatus(String? raw) {
  switch ((raw ?? '').toLowerCase()) {
    case 'paid':
    case 'approved':
    case 'completed':
    case 'accredited':
      return PaymentStatus.paid;
    case 'expired':
    case 'cancelled':
    case 'canceled':
    case 'failed':
    case 'rejected':
      return PaymentStatus.expired;
    default:
      return PaymentStatus.pending;
  }
}

/// Extensão da tela de Vendas sobre o [PaymentService] existente.
extension SalesChargeExtension on PaymentService {
  /// Cria cobrança Pix e devolve o copia-e-cola.
  Future<PixCharge> createCharge({
    required int amountCents,
    required String description,
  }) async {
    late final Map<String, dynamic> response;
    try {
      response = await _apiService.post('/api/payment/create', body: {
        'currency': 'BRL',
        'amount': amountCents / 100.0,
        'description': description,
      });
    } catch (_) {
      throw const PaymentException('Erro de conexão. Verifique sua internet.');
    }
    if (response['success'] == false) {
      throw PaymentException(
        response['error']?.toString() ?? 'Não foi possível gerar a cobrança.',
      );
    }
    final sessionId = response['session_id'] as String?;
    if (sessionId != null && sessionId.isNotEmpty) {
      await _secureStorage.savePaymentSession(sessionId);
    }
    final id = response['payment_id']?.toString() ?? '';
    final code = (response['qr_code_text'] ?? response['qr_code'] ?? '').toString();
    if (id.isEmpty) {
      throw const PaymentException('Resposta inválida do servidor.');
    }
    if (code.isEmpty) {
      throw const PaymentException(
        'QR indisponível no momento. Tente novamente.',
      );
    }
    return PixCharge(
      id: id,
      amountCents: amountCents,
      pixCode: code,
      status: _mapStatus(response['status']?.toString()),
    );
  }

  /// Consulta o status atual de uma cobrança.
  Future<PaymentStatus> fetchStatus(String id) async {
    late final Map<String, dynamic> response;
    try {
      response = await _apiService.get('/api/payment/$id/status');
    } catch (_) {
      throw const PaymentException('Erro de conexão. Verifique sua internet.');
    }
    if (response['success'] == false && response['status'] == null) {
      throw PaymentException(
        response['error']?.toString() ?? 'Não foi possível consultar o status.',
      );
    }
    return _mapStatus(response['status']?.toString());
  }

  /// Libera recursos (mantido para o ciclo de vida das telas).
  void dispose() {}
}

/// Apaga uma chave PIX do usuário (soft-delete no backend).
extension PixKeyDeleteExtension on PaymentService {
  Future<bool> deletePixKey(String keyId) async {
    try {
      final response = await _apiService.delete('/api/payment/pix/keys/$keyId');
      return response['success'] == true || response['deleted'] == true;
    } catch (_) {
      return false;
    }
  }
}
