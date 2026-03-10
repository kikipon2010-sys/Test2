class StorePerformance {
  final String storeId;
  final String storeName;
  final double taskCompletionRate;
  final double averageDelay; // in hours
  final int totalTasks;
  final int completedTasks;
  final int delayedTasks;
  
  StorePerformance({
    required this.storeId,
    required this.storeName,
    required this.taskCompletionRate,
    required this.averageDelay,
    required this.totalTasks,
    required this.completedTasks,
    required this.delayedTasks,
  });
  
  bool isPerformanceLow() => taskCompletionRate < 0.8;
}

class IssueOccurrence {
  final String storeId;
  final String storeName;
  final DateTime occurredAt;
  final String description;
  
  IssueOccurrence({
    required this.storeId,
    required this.storeName,
    required this.occurredAt,
    required this.description,
  });
}

class RecurringIssue {
  final String issueTitle;
  final int occurrences;
  final String category;
  final DateTime lastOccurrence;
  final List<IssueOccurrence> details;
  
  RecurringIssue({
    required this.issueTitle,
    required this.occurrences,
    required this.category,
    required this.lastOccurrence,
    this.details = const [],
  });
}

class DashboardData {
  final List<StorePerformance> storePerformances;
  final List<RecurringIssue> recurringIssues;
  final double overallCompletionRate;
  final double overallAverageDelay;
  final int totalActiveStores;
  final int alertCount;
  
  DashboardData({
    required this.storePerformances,
    required this.recurringIssues,
    required this.overallCompletionRate,
    required this.overallAverageDelay,
    required this.totalActiveStores,
    required this.alertCount,
  });
}
