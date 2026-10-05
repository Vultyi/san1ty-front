import 'package:estrutura_front_san1ty/core/security/api_security_service.dart';

/// Chat de suporte ligado ao backend (/api/support).
class SupportService {
  final ApiSecurityService _api = ApiSecurityService();

  Future<List<Map<String, dynamic>>> myTickets() async {
    try {
      final res = await _api.get('/api/support/tickets');
      final items = res['tickets'];
      if (items is List) {
        return items.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<Map<String, dynamic>?> openTicket(String topic, String message) async {
    try {
      final res = await _api.post('/api/support/tickets', body: {
        'topic': topic,
        'message': message,
      });
      final t = res['ticket'];
      if (t is Map) return Map<String, dynamic>.from(t);
    } catch (_) {}
    return null;
  }

  Future<List<Map<String, dynamic>>> messages(String ticketId) async {
    try {
      final res = await _api.get('/api/support/tickets/$ticketId');
      final items = res['messages'];
      if (items is List) {
        return items.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<bool> sendMessage(String ticketId, String body) async {
    try {
      final res = await _api.post('/api/support/tickets/$ticketId/messages', body: {
        'body': body,
      });
      return res['success'] == true;
    } catch (_) {
      return false;
    }
  }
}
