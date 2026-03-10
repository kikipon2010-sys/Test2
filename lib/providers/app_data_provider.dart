import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../models/exception_report.dart';
import '../models/dashboard_data.dart';
import '../models/knowledge_item.dart';
import '../models/department_data.dart';
import '../models/chat_message.dart';

class AppDataProvider extends ChangeNotifier {
  // 今日任務列表 (員工端)
  final List<Task> _todayTasks = [
    Task(
      id: '1',
      title: '開店前置準備',
      description: '檢查設備、清點備料、確認當日特餐',
      status: TaskStatus.completed,
      sopLink: 'sop_opening_prep',
      dueTime: DateTime.now().subtract(const Duration(hours: 2)),
      assignedTo: '張小華',
    ),
    Task(
      id: '2',
      title: '生鮮庫存盤點',
      description: '盤點冷藏區所有生鮮食材並更新系統',
      status: TaskStatus.reported,
      sopLink: 'sop_inventory_check',
      dueTime: DateTime.now().add(const Duration(hours: 1)),
      assignedTo: '張小華',
    ),
    Task(
      id: '3',
      title: '離峰時段清潔',
      description: '完成用餐區、廚房、洗手間全面清潔',
      status: TaskStatus.notReported,
      sopLink: 'sop_cleaning',
      dueTime: DateTime.now().add(const Duration(hours: 3)),
      assignedTo: '張小華',
    ),
    Task(
      id: '4',
      title: '食安溫度紀錄',
      description: '記錄冷藏冷凍設備溫度及食材保存狀態',
      status: TaskStatus.notReported,
      sopLink: 'sop_temperature',
      dueTime: DateTime.now().add(const Duration(hours: 4)),
      assignedTo: '張小華',
    ),
    Task(
      id: '5',
      title: '營業額對帳',
      description: '核對收銀系統與實際現金、信用卡金額',
      status: TaskStatus.needSupport,
      sopLink: 'sop_reconciliation',
      dueTime: DateTime.now().add(const Duration(hours: 8)),
      assignedTo: '張小華',
    ),
  ];

  // 異常回報列表 (店長端)
  final List<ExceptionReport> _exceptionReports = [
    ExceptionReport(
      id: '1',
      title: '冷藏設備異常',
      description: '冷藏冰箱溫度顯示異常,疑似壓縮機故障',
      type: ExceptionType.equipmentFailure,
      priority: ExceptionPriority.urgent,
      reportedBy: '李店長',
      reportedTime: DateTime.now().subtract(const Duration(minutes: 15)),
      assignedTo: '維修部-王師傅',
      isEscalated: true,
      storeId: 'store_001',
      storeName: '忠孝店',
    ),
    ExceptionReport(
      id: '2',
      title: '早班人員請假',
      description: '早班員工臨時請假,現場人力不足',
      type: ExceptionType.personnelIssue,
      priority: ExceptionPriority.high,
      reportedBy: '李店長',
      reportedTime: DateTime.now().subtract(const Duration(hours: 1)),
      assignedTo: '人資部-陳主管',
      isEscalated: false,
      storeId: 'store_001',
      storeName: '忠孝店',
    ),
    ExceptionReport(
      id: '3',
      title: '食材供應短缺',
      description: '供應商未能按時配送新鮮蔬菜',
      type: ExceptionType.supplierIssue,
      priority: ExceptionPriority.medium,
      reportedBy: '李店長',
      reportedTime: DateTime.now().subtract(const Duration(hours: 2)),
      storeId: 'store_001',
      storeName: '忠孝店',
    ),
  ];

  // 營運儀表板資料 (老闆端)
  final DashboardData _dashboardData = DashboardData(
    storePerformances: [
      StorePerformance(
        storeId: 'store_001',
        storeName: '忠孝店',
        taskCompletionRate: 0.92,
        averageDelay: 0.5,
        totalTasks: 50,
        completedTasks: 46,
        delayedTasks: 2,
      ),
      StorePerformance(
        storeId: 'store_002',
        storeName: '信義店',
        taskCompletionRate: 0.88,
        averageDelay: 1.2,
        totalTasks: 48,
        completedTasks: 42,
        delayedTasks: 5,
      ),
      StorePerformance(
        storeId: 'store_003',
        storeName: '南港店',
        taskCompletionRate: 0.75,
        averageDelay: 2.8,
        totalTasks: 52,
        completedTasks: 39,
        delayedTasks: 8,
      ),
      StorePerformance(
        storeId: 'store_004',
        storeName: '板橋店',
        taskCompletionRate: 0.95,
        averageDelay: 0.3,
        totalTasks: 45,
        completedTasks: 43,
        delayedTasks: 1,
      ),
      StorePerformance(
        storeId: 'store_005',
        storeName: '新莊店',
        taskCompletionRate: 0.78,
        averageDelay: 2.1,
        totalTasks: 47,
        completedTasks: 37,
        delayedTasks: 6,
      ),
    ],
    recurringIssues: [
      RecurringIssue(
        issueTitle: '離峰清潔未按時完成',
        occurrences: 12,
        category: '執行紀律',
        lastOccurrence: DateTime.now().subtract(const Duration(hours: 3)),
        details: [
          IssueOccurrence(
            storeId: '1',
            storeName: '忠孝店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 3)),
            description: '下午3點離峰清潔未完成,延遲40分鐘',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 8)),
            description: '早班清潔作業未按SOP執行',
          ),
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 26)),
            description: '離峰時段清潔延遲1小時',
          ),
          IssueOccurrence(
            storeId: '1',
            storeName: '忠孝店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 30)),
            description: '清潔任務未按時回報',
          ),
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 48)),
            description: '下午清潔作業延遲',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 50)),
            description: '清潔標準未達要求,需重做',
          ),
          IssueOccurrence(
            storeId: '5',
            storeName: '新竹店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 55)),
            description: '離峰清潔完全遺漏',
          ),
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 72)),
            description: '清潔用品未補充導致延遲',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 75)),
            description: '人力不足影響清潔進度',
          ),
          IssueOccurrence(
            storeId: '1',
            storeName: '忠孝店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 96)),
            description: '清潔SOP流程不熟悉',
          ),
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 100)),
            description: '離峰清潔時段安排不當',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 120)),
            description: '清潔任務未列入交班事項',
          ),
        ],
      ),
      RecurringIssue(
        issueTitle: '食材盤點數據誤差',
        occurrences: 8,
        category: '流程問題',
        lastOccurrence: DateTime.now().subtract(const Duration(days: 1)),
        details: [
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(days: 1)),
            description: '生鮮盤點數量與系統相差15%',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 2)),
            description: '冷凍食材盤點遺漏3項',
          ),
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(days: 3)),
            description: '盤點單位錯誤導致數據異常',
          ),
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(days: 4)),
            description: '盤點時間不當,數據不準確',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 5)),
            description: '多人盤點未統一標準',
          ),
          IssueOccurrence(
            storeId: '5',
            storeName: '新竹店',
            occurredAt: DateTime.now().subtract(const Duration(days: 6)),
            description: '盤點表格填寫錯誤',
          ),
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(days: 7)),
            description: '新人盤點訓練不足',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 8)),
            description: '盤點工具損壞影響準確度',
          ),
        ],
      ),
      RecurringIssue(
        issueTitle: '設備維護通報延遲',
        occurrences: 6,
        category: '溝通協調',
        lastOccurrence: DateTime.now().subtract(const Duration(days: 2)),
        details: [
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(days: 2)),
            description: '冷氣故障3天後才通報維修',
          ),
          IssueOccurrence(
            storeId: '5',
            storeName: '新竹店',
            occurredAt: DateTime.now().subtract(const Duration(days: 4)),
            description: '冰箱溫度異常未即時回報',
          ),
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(days: 6)),
            description: '油煙機清潔維護逾期',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 8)),
            description: '爐具故障未填寫維修單',
          ),
          IssueOccurrence(
            storeId: '5',
            storeName: '新竹店',
            occurredAt: DateTime.now().subtract(const Duration(days: 10)),
            description: '設備異常僅口頭通知未登記',
          ),
          IssueOccurrence(
            storeId: '4',
            storeName: '板橋店',
            occurredAt: DateTime.now().subtract(const Duration(days: 12)),
            description: '排水系統堵塞延遲處理',
          ),
        ],
      ),
      RecurringIssue(
        issueTitle: '新人訓練進度落後',
        occurrences: 5,
        category: '人員培訓',
        lastOccurrence: DateTime.now().subtract(const Duration(hours: 12)),
        details: [
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(hours: 12)),
            description: '新進員工第二週訓練未完成',
          ),
          IssueOccurrence(
            storeId: '5',
            storeName: '新竹店',
            occurredAt: DateTime.now().subtract(const Duration(days: 3)),
            description: '訓練導師請假,新人無人指導',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 5)),
            description: '新人訓練計畫未按時執行',
          ),
          IssueOccurrence(
            storeId: '2',
            storeName: '信義店',
            occurredAt: DateTime.now().subtract(const Duration(days: 8)),
            description: '訓練資料未提供給新進人員',
          ),
          IssueOccurrence(
            storeId: '3',
            storeName: '南港店',
            occurredAt: DateTime.now().subtract(const Duration(days: 10)),
            description: '新人試用期考核延遲',
          ),
        ],
      ),
    ],
    overallCompletionRate: 0.856,
    overallAverageDelay: 1.38,
    totalActiveStores: 5,
    alertCount: 3,
  );

  // 知識庫項目 (人資端)
  final List<KnowledgeItem> _knowledgeItems = [
    KnowledgeItem(
      id: '1',
      title: '新進員工完整培訓手冊',
      content: '本手冊包含新進員工所需了解的所有基礎知識,包括企業文化、作業流程、安全規範等。',
      category: KnowledgeCategory.training,
      publishedDate: DateTime.now().subtract(const Duration(days: 2)),
      author: '人資部',
      tags: ['新人', '必讀', '培訓'],
      viewCount: 156,
      isPinned: true,
    ),
    KnowledgeItem(
      id: '2',
      title: '開店前置作業 SOP',
      content: '詳細說明每日開店前的準備工作流程,包括設備檢查、備料確認等步驟。',
      category: KnowledgeCategory.sop,
      publishedDate: DateTime.now().subtract(const Duration(days: 5)),
      author: '營運部',
      tags: ['開店', 'SOP', '日常'],
      viewCount: 324,
      isPinned: true,
    ),
    KnowledgeItem(
      id: '3',
      title: '食品安全衛生管理規範',
      content: '依據食品安全衛生管理法制定的內部規範,包含食材保存、溫度控制等要點。',
      category: KnowledgeCategory.policy,
      publishedDate: DateTime.now().subtract(const Duration(days: 10)),
      author: '品保部',
      tags: ['食安', '規範', '必讀'],
      viewCount: 289,
      isPinned: false,
    ),
    KnowledgeItem(
      id: '4',
      title: '【公告】5月份優秀員工表揚',
      content: '恭喜本月獲選優秀員工的夥伴們!感謝大家的辛勤付出。',
      category: KnowledgeCategory.announcement,
      publishedDate: DateTime.now().subtract(const Duration(days: 1)),
      author: '總經理室',
      tags: ['表揚', '公告'],
      viewCount: 198,
      isPinned: true,
    ),
    KnowledgeItem(
      id: '5',
      title: '常見設備故障排除指南',
      content: '整理了門市最常見的設備問題及初步排除方法,協助第一時間處理。',
      category: KnowledgeCategory.faq,
      publishedDate: DateTime.now().subtract(const Duration(days: 15)),
      author: '設備部',
      tags: ['故障', '維修', '指南'],
      viewCount: 412,
      isPinned: false,
    ),
  ];

  // 總部部門數據
  final HeadquartersDashboardData _headquartersData = HeadquartersDashboardData(
    overallDepartmentPerformance: [
      DepartmentPerformance(
        department: Department.kitchen,
        departmentName: '廚房部',
        totalTasks: 245,
        completedTasks: 218,
        pendingTasks: 27,
        completionRate: 0.89,
        activeStaff: 45,
        issueCount: 8,
        averageResponseTime: 1.2,
      ),
      DepartmentPerformance(
        department: Department.service,
        departmentName: '服務部',
        totalTasks: 198,
        completedTasks: 185,
        pendingTasks: 13,
        completionRate: 0.93,
        activeStaff: 38,
        issueCount: 3,
        averageResponseTime: 0.8,
      ),
      DepartmentPerformance(
        department: Department.operations,
        departmentName: '營運部',
        totalTasks: 156,
        completedTasks: 145,
        pendingTasks: 11,
        completionRate: 0.93,
        activeStaff: 25,
        issueCount: 5,
        averageResponseTime: 0.9,
      ),
      DepartmentPerformance(
        department: Department.hr,
        departmentName: '人資部',
        totalTasks: 89,
        completedTasks: 82,
        pendingTasks: 7,
        completionRate: 0.92,
        activeStaff: 12,
        issueCount: 2,
        averageResponseTime: 1.5,
      ),
      DepartmentPerformance(
        department: Department.finance,
        departmentName: '財務部',
        totalTasks: 134,
        completedTasks: 98,
        pendingTasks: 36,
        completionRate: 0.73,
        activeStaff: 18,
        issueCount: 12,
        averageResponseTime: 2.8,
      ),
      DepartmentPerformance(
        department: Department.procurement,
        departmentName: '採購部',
        totalTasks: 176,
        completedTasks: 154,
        pendingTasks: 22,
        completionRate: 0.88,
        activeStaff: 22,
        issueCount: 6,
        averageResponseTime: 1.1,
      ),
      DepartmentPerformance(
        department: Department.maintenance,
        departmentName: '維修部',
        totalTasks: 112,
        completedTasks: 89,
        pendingTasks: 23,
        completionRate: 0.79,
        activeStaff: 15,
        issueCount: 9,
        averageResponseTime: 2.3,
      ),
    ],
    storesDepartmentData: [
      StoreDepartmentData(
        storeId: 'store_001',
        storeName: '忠孝店',
        departmentData: {
          Department.kitchen: DepartmentPerformance(
            department: Department.kitchen,
            departmentName: '廚房部',
            totalTasks: 52,
            completedTasks: 48,
            pendingTasks: 4,
            completionRate: 0.92,
            activeStaff: 9,
            issueCount: 1,
            averageResponseTime: 0.8,
          ),
          Department.service: DepartmentPerformance(
            department: Department.service,
            departmentName: '服務部',
            totalTasks: 45,
            completedTasks: 42,
            pendingTasks: 3,
            completionRate: 0.93,
            activeStaff: 8,
            issueCount: 0,
            averageResponseTime: 0.5,
          ),
        },
      ),
      StoreDepartmentData(
        storeId: 'store_002',
        storeName: '信義店',
        departmentData: {
          Department.kitchen: DepartmentPerformance(
            department: Department.kitchen,
            departmentName: '廚房部',
            totalTasks: 48,
            completedTasks: 42,
            pendingTasks: 6,
            completionRate: 0.88,
            activeStaff: 9,
            issueCount: 2,
            averageResponseTime: 1.2,
          ),
          Department.service: DepartmentPerformance(
            department: Department.service,
            departmentName: '服務部',
            totalTasks: 41,
            completedTasks: 37,
            pendingTasks: 4,
            completionRate: 0.90,
            activeStaff: 7,
            issueCount: 1,
            averageResponseTime: 0.9,
          ),
        },
      ),
      StoreDepartmentData(
        storeId: 'store_003',
        storeName: '南港店',
        departmentData: {
          Department.kitchen: DepartmentPerformance(
            department: Department.kitchen,
            departmentName: '廚房部',
            totalTasks: 54,
            completedTasks: 39,
            pendingTasks: 15,
            completionRate: 0.72,
            activeStaff: 9,
            issueCount: 4,
            averageResponseTime: 2.5,
          ),
          Department.service: DepartmentPerformance(
            department: Department.service,
            departmentName: '服務部',
            totalTasks: 46,
            completedTasks: 35,
            pendingTasks: 11,
            completionRate: 0.76,
            activeStaff: 8,
            issueCount: 2,
            averageResponseTime: 2.1,
          ),
        },
      ),
    ],
    departmentIssues: {
      Department.kitchen: ['食材盤點延遲', '設備維護通報不及時'],
      Department.service: ['客訴處理流程待優化'],
      Department.finance: ['門市對帳數據誤差', '發票開立延遲'],
      Department.maintenance: ['設備維修響應時間過長', '零件庫存管理問題'],
    },
    totalStaff: 175,
    totalActiveTasks: 1110,
  );

  // 新增通知計數
  int _notificationCount = 3;

  // Getters
  List<Task> get todayTasks => _todayTasks;
  List<ExceptionReport> get exceptionReports => _exceptionReports;
  DashboardData get dashboardData => _dashboardData;
  List<KnowledgeItem> get knowledgeItems => _knowledgeItems;
  HeadquartersDashboardData get headquartersData => _headquartersData;
  int get notificationCount => _notificationCount;

  // 更新任務狀態
  void updateTaskStatus(String taskId, TaskStatus newStatus) {
    final taskIndex = _todayTasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      final oldTask = _todayTasks[taskIndex];
      _todayTasks[taskIndex] = Task(
        id: oldTask.id,
        title: oldTask.title,
        description: oldTask.description,
        status: newStatus,
        sopLink: oldTask.sopLink,
        dueTime: oldTask.dueTime,
        assignedTo: oldTask.assignedTo,
      );
      notifyListeners();
      
      // 模擬跨角色連動:員工更新任務→老闆端收到通知
      if (newStatus == TaskStatus.needSupport) {
        _notificationCount++;
        if (kDebugMode) {
          debugPrint('🔔 跨角色連動:任務需要支援,已通知管理層');
        }
      }
    }
  }

  // 新增異常回報
  void addExceptionReport(ExceptionReport report) {
    _exceptionReports.insert(0, report);
    _notificationCount++;
    notifyListeners();
    
    if (kDebugMode) {
      debugPrint('🔔 跨角色連動:新增異常回報,已通知管理層');
    }
  }

  // 指派責任人
  void assignResponsiblePerson(String reportId, String assignee) {
    final reportIndex = _exceptionReports.indexWhere((r) => r.id == reportId);
    if (reportIndex != -1) {
      final oldReport = _exceptionReports[reportIndex];
      _exceptionReports[reportIndex] = ExceptionReport(
        id: oldReport.id,
        title: oldReport.title,
        description: oldReport.description,
        type: oldReport.type,
        priority: oldReport.priority,
        reportedBy: oldReport.reportedBy,
        reportedTime: oldReport.reportedTime,
        assignedTo: assignee,
        isEscalated: oldReport.isEscalated,
        storeId: oldReport.storeId,
        storeName: oldReport.storeName,
      );
      notifyListeners();
    }
  }

  // 向上呈報
  void escalateReport(String reportId) {
    final reportIndex = _exceptionReports.indexWhere((r) => r.id == reportId);
    if (reportIndex != -1) {
      final oldReport = _exceptionReports[reportIndex];
      _exceptionReports[reportIndex] = ExceptionReport(
        id: oldReport.id,
        title: oldReport.title,
        description: oldReport.description,
        type: oldReport.type,
        priority: oldReport.priority,
        reportedBy: oldReport.reportedBy,
        reportedTime: oldReport.reportedTime,
        assignedTo: oldReport.assignedTo,
        isEscalated: true,
        storeId: oldReport.storeId,
        storeName: oldReport.storeName,
      );
      _notificationCount++;
      notifyListeners();
      
      if (kDebugMode) {
        debugPrint('🔔 跨角色連動:異常已向上呈報,高層已收到通知');
      }
    }
  }

  // 清除通知
  void clearNotifications() {
    _notificationCount = 0;
    notifyListeners();
  }

  // ===== 聊天室功能 =====
  
  // 聊天室列表
  final List<ChatRoom> _chatRooms = [
    ChatRoom(
      id: 'room_001',
      title: '忠孝店-管理群組',
      participantIds: ['manager_001', 'executive_001', 'employee_001'],
      lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      messages: [
        ChatMessage(
          id: 'msg_001',
          senderId: 'employee_001',
          senderName: '張小華',
          senderRole: UserRole.employee,
          content: '李店長,今天營業額對帳遇到問題,收銀系統金額與實際現金有500元差額',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          isRead: true,
          relatedTaskId: '5',
        ),
        ChatMessage(
          id: 'msg_002',
          senderId: 'manager_001',
          senderName: '李店長',
          senderRole: UserRole.manager,
          content: '收到!我先過去協助確認。這種情況要先檢查是否有退款或折扣沒有記錄',
          type: MessageType.feedback,
          timestamp: DateTime.now().subtract(const Duration(minutes: 12)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_003',
          senderId: 'manager_001',
          senderName: '李店長',
          senderRole: UserRole.manager,
          content: '小華,我已經確認過了,是中午有一筆退款沒有正確輸入系統。請你現在補登記這筆退款紀錄',
          type: MessageType.taskAssignment,
          timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_004',
          senderId: 'executive_001',
          senderName: '王總經理',
          senderRole: UserRole.executive,
          content: '李店長,看到對帳問題已處理。建議加強員工對退款流程的訓練,避免類似問題重複發生',
          type: MessageType.feedback,
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          isRead: false,
        ),
        ChatMessage(
          id: 'msg_005',
          senderId: 'manager_001',
          senderName: '李店長',
          senderRole: UserRole.manager,
          content: '是的王總,我會安排下週進行退款流程的複訓',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
          isRead: false,
        ),
      ],
    ),
    ChatRoom(
      id: 'room_002',
      title: '設備維修緊急處理',
      participantIds: ['manager_001', 'maintenance_001'],
      lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      unreadCount: 0,
      messages: [
        ChatMessage(
          id: 'msg_006',
          senderId: 'manager_001',
          senderName: '李店長',
          senderRole: UserRole.manager,
          content: '冷藏冰箱溫度異常,顯示12度,正常應該是4度以下,請盡快派人處理!',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
          relatedReportId: '1',
        ),
        ChatMessage(
          id: 'msg_007',
          senderId: 'maintenance_001',
          senderName: '王師傅',
          senderRole: UserRole.employee,
          content: '收到!我30分鐘內趕到現場',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_008',
          senderId: 'maintenance_001',
          senderName: '王師傅',
          senderRole: UserRole.employee,
          content: '已到現場,初步判斷是壓縮機故障。需要更換零件,預計2小時內完成',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_009',
          senderId: 'maintenance_001',
          senderName: '王師傅',
          senderRole: UserRole.employee,
          content: '維修完成,冰箱溫度已恢復正常。建議每週檢查一次設備',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
      ],
    ),
    ChatRoom(
      id: 'room_003',
      title: '南港店-績效改善討論',
      participantIds: ['executive_001', 'manager_002'],
      lastActivity: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 1,
      messages: [
        ChatMessage(
          id: 'msg_010',
          senderId: 'executive_001',
          senderName: '王總經理',
          senderRole: UserRole.executive,
          content: '陳店長,看到南港店本週任務完成率只有75%,需要了解一下原因',
          type: MessageType.feedback,
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_011',
          senderId: 'manager_002',
          senderName: '陳店長',
          senderRole: UserRole.manager,
          content: '王總抱歉,本週確實表現不佳。主要是廚房部人手不足,加上兩位員工請假',
          type: MessageType.text,
          timestamp: DateTime.now().subtract(const Duration(hours: 3, minutes: 40)),
          isRead: true,
        ),
        ChatMessage(
          id: 'msg_012',
          senderId: 'executive_001',
          senderName: '王總經理',
          senderRole: UserRole.executive,
          content: '了解。我會請人資部協調人力支援。另外,請你本週完成人員排班優化計畫',
          type: MessageType.taskAssignment,
          timestamp: DateTime.now().subtract(const Duration(hours: 3)),
          isRead: false,
        ),
      ],
    ),
  ];

  // Getters
  List<ChatRoom> get chatRooms => _chatRooms;
  
  int get totalUnreadMessages {
    return _chatRooms.fold(0, (sum, room) => sum + room.unreadCount);
  }

  // 發送訊息
  void sendMessage(String roomId, ChatMessage message) {
    final roomIndex = _chatRooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      _chatRooms[roomIndex].messages.add(message);
      notifyListeners();
      
      if (kDebugMode) {
        debugPrint('💬 新訊息: ${message.senderName} - ${message.content}');
      }
    }
  }

  // 標記訊息已讀
  void markRoomAsRead(String roomId) {
    final roomIndex = _chatRooms.indexWhere((room) => room.id == roomId);
    if (roomIndex != -1) {
      final room = _chatRooms[roomIndex];
      final updatedRoom = ChatRoom(
        id: room.id,
        title: room.title,
        participantIds: room.participantIds,
        messages: room.messages,
        lastActivity: room.lastActivity,
        unreadCount: 0,
      );
      _chatRooms[roomIndex] = updatedRoom;
      notifyListeners();
    }
  }
}

