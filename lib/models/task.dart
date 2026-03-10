import 'package:flutter/material.dart';

enum TaskStatus {
  notReported,    // 未回報
  reported,       // 已回報
  needSupport,    // 需支援
  completed       // 已完成
}

class Task {
  final String id;
  final String title;
  final String description;
  final TaskStatus status;
  final String? sopLink;
  final DateTime dueTime;
  final String assignedTo;
  
  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    this.sopLink,
    required this.dueTime,
    required this.assignedTo,
  });
  
  Color getStatusColor() {
    switch (status) {
      case TaskStatus.notReported:
        return Colors.orange;
      case TaskStatus.reported:
        return Colors.blue;
      case TaskStatus.needSupport:
        return Colors.red;
      case TaskStatus.completed:
        return Colors.green;
    }
  }
  
  String getStatusText() {
    switch (status) {
      case TaskStatus.notReported:
        return '未回報';
      case TaskStatus.reported:
        return '已回報';
      case TaskStatus.needSupport:
        return '需支援';
      case TaskStatus.completed:
        return '已完成';
    }
  }
  
  IconData getStatusIcon() {
    switch (status) {
      case TaskStatus.notReported:
        return Icons.schedule;
      case TaskStatus.reported:
        return Icons.check_circle_outline;
      case TaskStatus.needSupport:
        return Icons.error_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
    }
  }
}
