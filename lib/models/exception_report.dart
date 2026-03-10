import 'package:flutter/material.dart';

enum ExceptionType {
  systemIssue,      // 制度問題
  equipmentFailure, // 設備故障
  personnelIssue,   // 人員問題
  supplierIssue,    // 供應商問題
  other            // 其他
}

enum ExceptionPriority {
  low,
  medium,
  high,
  urgent
}

class ExceptionReport {
  final String id;
  final String title;
  final String description;
  final ExceptionType type;
  final ExceptionPriority priority;
  final String reportedBy;
  final DateTime reportedTime;
  final String? assignedTo;
  final bool isEscalated;
  final String storeId;
  final String storeName;
  
  ExceptionReport({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.priority,
    required this.reportedBy,
    required this.reportedTime,
    this.assignedTo,
    this.isEscalated = false,
    required this.storeId,
    required this.storeName,
  });
  
  Color getPriorityColor() {
    switch (priority) {
      case ExceptionPriority.low:
        return Colors.grey;
      case ExceptionPriority.medium:
        return Colors.orange;
      case ExceptionPriority.high:
        return Colors.red;
      case ExceptionPriority.urgent:
        return Colors.red.shade900;
    }
  }
  
  String getPriorityText() {
    switch (priority) {
      case ExceptionPriority.low:
        return '低';
      case ExceptionPriority.medium:
        return '中';
      case ExceptionPriority.high:
        return '高';
      case ExceptionPriority.urgent:
        return '緊急';
    }
  }
  
  String getTypeText() {
    switch (type) {
      case ExceptionType.systemIssue:
        return '制度問題';
      case ExceptionType.equipmentFailure:
        return '設備故障';
      case ExceptionType.personnelIssue:
        return '人員問題';
      case ExceptionType.supplierIssue:
        return '供應商問題';
      case ExceptionType.other:
        return '其他';
    }
  }
}
