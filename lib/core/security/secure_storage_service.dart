// lib/core/security/secure_storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Serviço de armazenamento seguro para dados sensíveis
/// Usa encriptação nativa do SO (Keychain/Keystore)
class SecureStorageService {
  static const String _tokenKey = 'san1ty_auth_token';
  static const String _refreshTokenKey = 'san1ty_refresh_token';
  static const String _userDataKey = 'san1ty_user_data';
  static const String _supportTokenKey = 'san1ty_support_token';

  static final SecureStorageService _instance =
      SecureStorageService._internal();

  late final FlutterSecureStorage _storage;

  SecureStorageService._internal();

  factory SecureStorageService() {
    return _instance;
  }

  /// Inicializa o serviço
  void initialize() {
    _storage = const FlutterSecureStorage();
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