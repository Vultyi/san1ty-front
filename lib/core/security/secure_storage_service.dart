import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço de armazenamento seguro para dados sensíveis
/// Usa encriptação nativa do SO (Keychain/Keystore)
class SecureStorageService {
  static const String _tokenKey = 'san1ty_auth_token';
  static const String _refreshTokenKey = 'san1ty_refresh_token';
  static const String _userDataKey = 'san1ty_user_data';
  static const String _supportTokenKey = 'san1ty_support_token';
  static const String _paymentSessionKey = 'san1ty_payment_session';
  static const String _deviceIdKey = 'san1ty_device_id';

  static final SecureStorageService _instance =
      SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  /// Inicializa o serviço (mantido por compatibilidade, não é mais necessário)
  void initialize() {
    // _storage já é inicializado na declaração — nenhum setup adicional necessário.
  }

  /// Salva o token JWT de autenticação
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Recupera o token JWT
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Salva o refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Recupera o refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Salva dados do usuário (criptografado)
  Future<void> saveUserData(String userData) async {
    await _storage.write(key: _userDataKey, value: userData);
  }

  /// Recupera dados do usuário
  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  /// Salva token de suporte
  Future<void> saveSupportToken(String token) async {
    await _storage.write(key: _supportTokenKey, value: token);
  }

  /// Recupera token de suporte
  Future<String?> getSupportToken() async {
    return await _storage.read(key: _supportTokenKey);
  }

  /// Salva a sessão de pagamento (credencial de leitura do polling).
  /// Emitida pelo backend no create (corpo session_id + cookie sid).
  Future<void> savePaymentSession(String sessionId) async {
    await _storage.write(key: _paymentSessionKey, value: sessionId);
  }

  /// Recupera a sessão de pagamento, ou null se inexistente.
  Future<String?> getPaymentSession() async {
    return await _storage.read(key: _paymentSessionKey);
  }

  /// Remove a sessão de pagamento (ex: após concluir/cancelar o fluxo).
  Future<void> clearPaymentSession() async {
    await _storage.delete(key: _paymentSessionKey);
  }

  /// ID estável do dispositivo (para o binding JWT do backend).
  /// Gerado uma vez (32 bytes aleatórios) e persistido.
  Future<String> getOrCreateDeviceId() async {
    final existing = await _storage.read(key: _deviceIdKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final rand = Random.secure();
    final bytes = List<int>.generate(32, (_) => rand.nextInt(256));
    final id = base64Url.encode(bytes).replaceAll('=', '');
    await _storage.write(key: _deviceIdKey, value: id);
    return id;
  }

  /// Limpa todos os dados sensíveis (logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Verifica se há token válido
  Future<bool> hasValidToken() async {
    final token = await getAuthToken();
    if (token == null) return false;
    
    // Verifica se o token não está vazio
    return token.isNotEmpty;
  }
}