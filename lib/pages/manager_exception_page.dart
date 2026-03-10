import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exception_report.dart';
import '../providers/app_data_provider.dart';

class ManagerExceptionPage extends StatelessWidget {
  const ManagerExceptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1976D2),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '異常處理',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '主動回饋與問題管理',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          Consumer<AppDataProvider>(
            builder: (context, provider, child) {
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                    onPressed: () {
                      provider.clearNotifications();
                    },
                  ),
                  if (provider.notificationCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${provider.notificationCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final reports = provider.exceptionReports;
          
          return Column(
            children: [
              // 快速統計
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFF1976D2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      '待處理',
                      '${reports.where((r) => r.assignedTo == null).length}',
                      Icons.pending_actions,
                    ),
                    _buildStatItem(
                      '處理中',
                      '${reports.where((r) => r.assignedTo != null && !r.isEscalated).length}',
                      Icons.engineering,
                    ),
                    _buildStatItem(
                      '已上報',
                      '${reports.where((r) => r.isEscalated).length}',
                      Icons.arrow_upward,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 異常列表
              Expanded(
                child: reports.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_outline, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              '目前沒有異常回報',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          return _buildExceptionCard(context, reports[index], provider);
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showNewExceptionDialog(context);
        },
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(Icons.add_alert),
        label: const Text('回報異常'),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildExceptionCard(BuildContext context, ExceptionReport report, AppDataProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: report.priority == ExceptionPriority.urgent
            ? BorderSide(color: Colors.red[700]!, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showExceptionDetailDialog(context, report, provider);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 優先級標籤
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: report.getPriorityColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      report.getPriorityText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // 類型標籤
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      report.getTypeText(),
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 12,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // 上報標記
                  if (report.isEscalated)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 14, color: Colors.orange[900]),
                          const SizedBox(width: 4),
                          Text(
                            '已上報',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.orange[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 標題
              Text(
                report.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 6),
              
              // 描述
              Text(
                report.description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              
              // 底部資訊
              Row(
                children: [
                  Icon(Icons.store, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    report.storeName,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(report.reportedTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              
              if (report.assignedTo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      '負責人: ${report.assignedTo}',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} 分鐘前';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} 小時前';
    } else {
      return '${difference.inDays} 天前';
    }
  }

  void _showExceptionDetailDialog(BuildContext context, ExceptionReport report, AppDataProvider provider) {
    final assigneeController = TextEditingController(text: report.assignedTo ?? '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: report.getPriorityColor().withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.error_outline,
                color: report.getPriorityColor(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                report.title,
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 基本資訊
              _buildInfoRow('門市', report.storeName),
              _buildInfoRow('回報人', report.reportedBy),
              _buildInfoRow('回報時間', _formatFullTime(report.reportedTime)),
              _buildInfoRow('類型', report.getTypeText()),
              _buildInfoRow('優先級', report.getPriorityText()),
              
              const SizedBox(height: 16),
              const Divider(),
              
              // 問題描述
              const Text(
                '問題描述',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Text(report.description),
              
              const SizedBox(height: 16),
              const Divider(),
              
              // 指派責任人
              const Text(
                '指派責任人',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: assigneeController,
                decoration: const InputDecoration(
                  hintText: '輸入負責人姓名',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                  isDense: true,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 操作按鈕
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (assigneeController.text.isNotEmpty) {
                          provider.assignResponsiblePerson(report.id, assigneeController.text);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('已指派責任人')),
                          );
                        }
                      },
                      icon: const Icon(Icons.person_add),
                      label: const Text('指派'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        provider.escalateReport(report.id);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('🔔 已向上呈報,高層已收到通知'),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      },
                      icon: const Icon(Icons.arrow_upward),
                      label: const Text('向上呈報'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // 回報為制度問題
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('回報為制度問題'),
                        content: const Text('此操作將標記為制度問題並向管理層提出改善建議。'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('取消'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('🔔 已回報為制度問題,建議已送達管理層'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('確認回報'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('回報為制度問題'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatFullTime(DateTime time) {
    return '${time.year}/${time.month}/${time.day} ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _showNewExceptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新增異常回報'),
        content: const Text('此功能用於創建新的異常回報。\n\n在實際系統中,這裡會有表單讓您填寫異常詳情。'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('關閉'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('異常回報已提交')),
              );
            },
            child: const Text('提交'),
          ),
        ],
      ),
    );
  }
}
