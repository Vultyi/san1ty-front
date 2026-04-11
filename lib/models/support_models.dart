class SupportChat {
  final String id;
  final String userName;
  final String email;
  final String lastMessage;
  final String time;
  final String status; // 'novo', 'em_atendimento', 'encerrado'
  final int unreadCount;
  final DateTime createdAt;

  SupportChat({
    required this.id,
    required this.userName,
    required this.email,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.unreadCount,
    required this.createdAt,
  });
}

class SupportMessage {
  final String id;
  final String chatId;
  final String text;
  final String sender; // 'user', 'support', 'system'
  final String time;
  final DateTime sentAt;

  SupportMessage({
    required this.id,
    required this.chatId,
    required this.text,
    required this.sender,
    required this.time,
    required this.sentAt,
  });
}

class PendingAccountSupport {
  final String id;
  final String userName;
  final String email;
  final String userId;
  final String document;
  final String requestDate;
  final String status; // 'pendente', 'aprovado', 'reprovado'

  PendingAccountSupport({
    required this.id,
    required this.userName,
    required this.email,
    required this.userId,
    required this.document,
    required this.requestDate,
    required this.status,
  });
}

class AttendanceRecordSupport {
  final String id;
  final String userName;
  final String issue;
  final String date;
  final String duration;
  final String status;
  final double? rating;

  AttendanceRecordSupport({
    required this.id,
    required this.userName,
    required this.issue,
    required this.date,
    required this.duration,
    required this.status,
    this.rating,
  });
}

class PreLoginChat {
  final String id;
  final String visitorName;
  final String issue;
  final String lastMessage;
  final String time;
  final String status; // 'aguardando', 'em_atendimento', 'resolvido'
  final String priority; // 'normal', 'urgente'
  final DateTime createdAt;

  PreLoginChat({
    required this.id,
    required this.visitorName,
    required this.issue,
    required this.lastMessage,
    required this.time,
    required this.status,
    required this.priority,
    required this.createdAt,
  });
}

class SupportAttendant {
  final String id;
  final String name;
  final String initials;
  final String email;
  final String role;
  final String status; // 'online', 'offline', 'ocupado'

  SupportAttendant({
    required this.id,
    required this.name,
    required this.initials,
    required this.email,
    required this.role,
    required this.status,
  });
}
