import 'package:flutter/material.dart';

enum Department {
  kitchen,      // 廚房部
  service,      // 服務部
  operations,   // 營運部
  hr,          // 人資部
  finance,     // 財務部
  procurement, // 採購部
  maintenance  // 維修部
}

class DepartmentPerformance {
  final Department department;
  final String departmentName;
  final int totalTasks;
  final int completedTasks;
  final int pendingTasks;
  final double completionRate;
  final int activeStaff;
  final int issueCount;
  final double averageResponseTime; // 平均回應時間(小時)
  
  DepartmentPerformance({
    required this.department,
    required this.departmentName,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.completionRate,
    required this.activeStaff,
    required this.issueCount,
    required this.averageResponseTime,
  });
  
  Color getDepartmentColor() {
    switch (department) {
      case Department.kitchen:
        return Colors.orange;
      case Department.service:
        return Colors.blue;
      case Department.operations:
        return Colors.purple;
      case Department.hr:
        return Colors.green;
      case Department.finance:
        return Colors.red;
      case Department.procurement:
        return Colors.teal;
      case Department.maintenance:
        return Colors.amber;
    }
  }
  
  IconData getDepartmentIcon() {
    switch (department) {
      case Department.kitchen:
        return Icons.restaurant_menu;
      case Department.service:
        return Icons.room_service;
      case Department.operations:
        return Icons.business_center;
      case Department.hr:
        return Icons.people;
      case Department.finance:
        return Icons.account_balance;
      case Department.procurement:
        return Icons.shopping_cart;
      case Department.maintenance:
        return Icons.build;
    }
  }
  
  bool isPerformanceLow() => completionRate < 0.8;
}

class StoreDepartmentData {
  final String storeId;
  final String storeName;
  final Map<Department, DepartmentPerformance> departmentData;
  
  StoreDepartmentData({
    required this.storeId,
    required this.storeName,
    required this.departmentData,
  });
}

class HeadquartersDashboardData {
  final List<DepartmentPerformance> overallDepartmentPerformance;
  final List<StoreDepartmentData> storesDepartmentData;
  final Map<Department, List<String>> departmentIssues; // 各部門的主要問題
  final int totalStaff;
  final int totalActiveTasks;
  
  HeadquartersDashboardData({
    required this.overallDepartmentPerformance,
    required this.storesDepartmentData,
    required this.departmentIssues,
    required this.totalStaff,
    required this.totalActiveTasks,
  });
}
