// lib/models/admin_models.dart
import 'package:flutter/material.dart';

enum SupportRole {
  supportLevel1,
  supportLevel2,
  supportTechnical,
}

enum SupportStatus {
  online,
  away,
  offline,
}

enum ChatStatus {
  active,
  resolved,
  pending,
}

class AdminUser {
  final String id;
  final String name;
  final String email;
  final List<String> permissions;
  final DateTime createdAt;

  const AdminUser({
    required this.id,
    required this.name,
    required this.email,
    required this.permissions,
    required this.createdAt,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) {
    return AdminUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      permissions: List<String>.from(json['permissions']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class SupportMember {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final SupportRole role;
  final SupportStatus status;
  final SupportStats stats;
  final DateTime lastActivity;
  final DateTime createdAt;

  const SupportMember({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.status,
    required this.stats,
    required this.lastActivity,
    required this.createdAt,
  });

  factory SupportMember.fromJson(Map<String, dynamic> json) {
    return SupportMember(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'] ?? json['name'].split(' ').map((e) => e[0]).join().toUpperCase(),
      role: _parseRole(json['role']),
      status: _parseStatus(json['status']),
      stats: SupportStats.fromJson(json['stats']),
      lastActivity: DateTime.parse(json['lastActivity']),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static SupportRole _parseRole(String role) {
    switch (role) {
      case 'support_level_1':
        return SupportRole.supportLevel1;
      case 'support_level_2':
        return SupportRole.supportLevel2;
      case 'support_technical':
        return SupportRole.supportTechnical;
      default:
        return SupportRole.supportLevel1;
    }
  }

  static SupportStatus _parseStatus(String status) {
    switch (status) {
      case 'online':
        return SupportStatus.online;
      case 'away':
        return SupportStatus.away;
      case 'offline':
        return SupportStatus.offline;
      default:
        return SupportStatus.offline;
    }
  }

  String get roleDisplay {
    switch (role) {
      case SupportRole.supportLevel1:
        return 'Suporte Nível 1';
      case SupportRole.supportLevel2:
        return 'Suporte Nível 2';
      case SupportRole.supportTechnical:
        return 'Suporte Técnico';
    }
  }

  Color get statusColor {
    switch (status) {
      case SupportStatus.online:
        return const Color(0xFF4ADE80);
      case SupportStatus.away:
        return const Color(0xFFFBBF24);
      case SupportStatus.offline:
        return const Color(0xFF9CA3AF);
    }
  }
}

class SupportStats {
  final String loggedTime;
  final int loggedTimeMinutes;
  final int chatsActive;
  final int chatsResolved;
  final String avgResponseTime;
  final int avgResponseTimeSeconds;
  final double satisfaction;
  final DateTime lastActivity;

  const SupportStats({
    required this.loggedTime,
    required this.loggedTimeMinutes,
    required this.chatsActive,
    required this.chatsResolved,
    required this.avgResponseTime,
    required this.avgResponseTimeSeconds,
    required this.satisfaction,
    required this.lastActivity,
  });

  factory SupportStats.fromJson(Map<String, dynamic> json) {
    return SupportStats(
      loggedTime: json['loggedTime'] ?? '0h 0min',
      loggedTimeMinutes: json['loggedTimeMinutes'] ?? 0,
      chatsActive: json['chatsActive'] ?? 0,
      chatsResolved: json['chatsResolved'] ?? 0,
      avgResponseTime: json['avgResponseTime'] ?? '0min',
      avgResponseTimeSeconds: json['avgResponseTimeSeconds'] ?? 0,
      satisfaction: (json['satisfaction'] ?? 0.0).toDouble(),
      lastActivity: DateTime.parse(json['lastActivity'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class AdminChat {
  final String id;
  final String userId;
  final String userName;
  final String? supportId;
  final String? supportName;
  final ChatStatus status;
  final String lastMessage;
  final DateTime lastMessageTime;
  final DateTime createdAt;
  final DateTime? resolvedAt;

  const AdminChat({
    required this.id,
    required this.userId,
    required this.userName,
    this.supportId,
    this.supportName,
    required this.status,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.createdAt,
    this.resolvedAt,
  });

  factory AdminChat.fromJson(Map<String, dynamic> json) {
    return AdminChat(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      supportId: json['supportId'],
      supportName: json['supportName'],
      status: _parseChatStatus(json['status']),
      lastMessage: json['lastMessage'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
      createdAt: DateTime.parse(json['createdAt']),
      resolvedAt: json['resolvedAt'] != null ? DateTime.parse(json['resolvedAt']) : null,
    );
  }

  static ChatStatus _parseChatStatus(String status) {
    switch (status) {
      case 'active':
        return ChatStatus.active;
      case 'resolved':
        return ChatStatus.resolved;
      case 'pending':
        return ChatStatus.pending;
      default:
        return ChatStatus.pending;
    }
  }
}

class AdminMessage {
  final String id;
  final String sender;
  final String senderName;
  final String content;
  final DateTime timestamp;

  const AdminMessage({
    required this.id,
    required this.sender,
    required this.senderName,
    required this.content,
    required this.timestamp,
  });

  factory AdminMessage.fromJson(Map<String, dynamic> json) {
    return AdminMessage(
      id: json['id'],
      sender: json['sender'],
      senderName: json['senderName'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}

class TeamSummary {
  final int totalMembers;
  final int onlineMembers;
  final int totalActiveChats;
  final int totalResolvedToday;

  const TeamSummary({
    required this.totalMembers,
    required this.onlineMembers,
    required this.totalActiveChats,
    required this.totalResolvedToday,
  });

  factory TeamSummary.fromJson(Map<String, dynamic> json) {
    return TeamSummary(
      totalMembers: json['totalMembers'],
      onlineMembers: json['onlineMembers'],
      totalActiveChats: json['totalActiveChats'],
      totalResolvedToday: json['totalResolvedToday'],
    );
  }
}

class SupportCredentials {
  final String id;
  final String name;
  final String email;
  final String password;
  final SupportRole role;
  final DateTime createdAt;
  final String message;

  const SupportCredentials({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.message,
  });

  factory SupportCredentials.fromJson(Map<String, dynamic> json) {
    return SupportCredentials(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      role: SupportMember._parseRole(json['role']),
      createdAt: DateTime.parse(json['createdAt']),
      message: json['message'],
    );
  }
}