import 'package:flutter/material.dart';

enum MessageType {
  text,           // 一般文字訊息
  taskAssignment, // 任務交辦
  feedback,       // 主管回饋
  systemNotice,   // 系統通知
}

enum UserRole {
  employee,   // 員工
  manager,    // 店長
  executive,  // 高層
  hr,        // 人資
  system,    // 系統
}

class ChatMessage {
  final String id;
  final String senderId;
  final String senderName;
  final UserRole senderRole;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final bool isRead;
  final String? relatedTaskId;
  final String? relatedReportId;
  final List<String>? attachments;
  
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.content,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.relatedTaskId,
    this.relatedReportId,
    this.attachments,
  });
  
  Color getRoleColor() {
    switch (senderRole) {
      case UserRole.employee:
        return Colors.blue;
      case UserRole.manager:
        return Colors.orange;
      case UserRole.executive:
        return Colors.purple;
      case UserRole.hr:
        return Colors.green;
      case UserRole.system:
        return Colors.grey;
    }
  }
  
  String getRoleText() {
    switch (senderRole) {
      case UserRole.employee:
        return '員工';
      case UserRole.manager:
        return '店長';
      case UserRole.executive:
        return '高層';
      case UserRole.hr:
        return '人資';
      case UserRole.system:
        return '系統';
    }
  }
  
  IconData getTypeIcon() {
    switch (type) {
      case MessageType.text:
        return Icons.chat_bubble;
      case MessageType.taskAssignment:
        return Icons.assignment_turned_in;
      case MessageType.feedback:
        return Icons.feedback;
      case MessageType.systemNotice:
        return Icons.notifications;
    }
  }
}

class ChatRoom {
  final String id;
  final String title;
  final List<String> participantIds;
  final List<ChatMessage> messages;
  final DateTime lastActivity;
  final int unreadCount;
  
  ChatRoom({
    required this.id,
    required this.title,
    required this.participantIds,
    required this.messages,
    required this.lastActivity,
    this.unreadCount = 0,
  });
  
  ChatMessage? get lastMessage {
    if (messages.isEmpty) return null;
    return messages.last;
  }
}
