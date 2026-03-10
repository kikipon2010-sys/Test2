import 'package:flutter/material.dart';

enum KnowledgeCategory {
  sop,          // 標準作業流程
  training,     // 培訓資料
  announcement, // 公告
  policy,       // 政策規範
  faq          // 常見問題
}

class KnowledgeItem {
  final String id;
  final String title;
  final String content;
  final KnowledgeCategory category;
  final DateTime publishedDate;
  final String author;
  final List<String> tags;
  final int viewCount;
  final bool isPinned;
  final String? attachmentUrl;
  
  KnowledgeItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishedDate,
    required this.author,
    required this.tags,
    this.viewCount = 0,
    this.isPinned = false,
    this.attachmentUrl,
  });
  
  Color getCategoryColor() {
    switch (category) {
      case KnowledgeCategory.sop:
        return Colors.blue;
      case KnowledgeCategory.training:
        return Colors.green;
      case KnowledgeCategory.announcement:
        return Colors.orange;
      case KnowledgeCategory.policy:
        return Colors.purple;
      case KnowledgeCategory.faq:
        return Colors.teal;
    }
  }
  
  String getCategoryText() {
    switch (category) {
      case KnowledgeCategory.sop:
        return 'SOP';
      case KnowledgeCategory.training:
        return '培訓';
      case KnowledgeCategory.announcement:
        return '公告';
      case KnowledgeCategory.policy:
        return '政策';
      case KnowledgeCategory.faq:
        return 'FAQ';
    }
  }
  
  IconData getCategoryIcon() {
    switch (category) {
      case KnowledgeCategory.sop:
        return Icons.description;
      case KnowledgeCategory.training:
        return Icons.school;
      case KnowledgeCategory.announcement:
        return Icons.campaign;
      case KnowledgeCategory.policy:
        return Icons.gavel;
      case KnowledgeCategory.faq:
        return Icons.help;
    }
  }
}
