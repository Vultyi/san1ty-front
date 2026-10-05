import 'dart:convert';
import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';

/// Chamadas KYC alinhadas ao backend (`POST /api/kyc/register`,
/// `POST /api/kyc/documents/upload`, `GET /api/kyc/status`, ...).
class KycService {
  final ApiSecurityService _apiService = ApiSecurityService();

  /// Registro PF. Campos flat exigidos pelo backend.
  Future<Map<String, dynamic>> startPersonalKyc({
    required String fullName,
    required String cpf,
    required String phone,
    required String email,
    required String address,
    required String city,
    required String state,
    required String cep,
    bool pepSelfDeclared = false,
  }) async {
    try {
      final response = await _apiService.post('/api/kyc/register', body: {
        'full_name': fullName,
        'cpf': cpf,
        'phone': phone,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'cep': cep,
        'pep_self_declared': pepSelfDeclared,
      });
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao iniciar processo KYC.',
      };
    }
  }

  /// Triagem PJ: backend guarda em metadata + fila de revisão manual
  /// (sem screening automático — NÃO é KYB completo).
  Future<Map<String, dynamic>> startBusinessKyc({
    required String fullName,
    required String cpf,
    required String phone,
    required String email,
    required String address,
    required String city,
    required String state,
    required String cep,
    required String companyName,
    required String cnpj,
  }) async {
    try {
      final response = await _apiService.post('/api/kyc/register', body: {
        'full_name': fullName,
        'cpf': cpf,
        'phone': phone,
        'email': email,
        'address': address,
        'city': city,
        'state': state,
        'cep': cep,
        'is_business': true,
        'company_name': companyName,
        'cnpj': cnpj,
      });
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao iniciar processo KYC empresarial.',
      };
    }
  }

  /// Upload de documento (bytes -> base64, tipos do backend).
  Future<Map<String, dynamic>> uploadDocument({
    required String documentType,
    required List<int> fileBytes,
    String? fileName,
  }) async {
    try {
      final response = await _apiService.post('/api/kyc/documents/upload', body: {
        'document_type': documentType.toUpperCase(),
        'file_data': base64Encode(fileBytes),
      });
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao fazer upload do documento.',
      };
    }
  }

  /// Consulta status do KYC
  Future<Map<String, dynamic>> getKycStatus() async {
    try {
      final response = await _apiService.get('/api/kyc/status');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao consultar status KYC.',
        'status': 'unknown',
      };
    }
  }

  /// Lista documentos aceitos (fonte: backend)
  Future<Map<String, dynamic>> getRequiredDocuments() async {
    try {
      final response = await _apiService.get('/api/kyc/required-documents');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao carregar documentos necessários.',
        'documents': [],
      };
    }
  }

  /// Obtém lista de estados brasileiros
  Future<Map<String, dynamic>> getStates() async {
    try {
      final response = await _apiService.get('/api/locations/states');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao carregar estados.',
        'states': [],
      };
    }
  }

  /// Obtém cidades de um estado
  Future<Map<String, dynamic>> getCities(String stateCode) async {
    try {
      final response = await _apiService.get('/api/locations/states/$stateCode/cities');
      return response;
    } catch (e) {
      return {
        'success': false,
        'error': 'Erro ao carregar cidades.',
        'cities': [],
      };
    }
  }
}
