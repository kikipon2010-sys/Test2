import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/app_data_provider.dart';
import '../widgets/floating_chat_button.dart';

class EmployeeTasksPage extends StatelessWidget {
  const EmployeeTasksPage({super.key});

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
              '今日任務',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '2024年6月15日 週六',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('查看通知')),
              );
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final tasks = provider.todayTasks;
          
          // 統計數據
          final completedCount = tasks.where((t) => t.status == TaskStatus.completed).length;
          final needSupportCount = tasks.where((t) => t.status == TaskStatus.needSupport).length;
          
          return Column(
            children: [
              // 頂部統計卡片
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
                    _buildStatItem('總任務', '${tasks.length}', Icons.assignment),
                    _buildStatItem('已完成', '$completedCount', Icons.check_circle),
                    _buildStatItem('需支援', '$needSupportCount', Icons.error),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // 任務列表
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return _buildTaskCard(context, tasks[index], provider);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: const FloatingChatButton(),
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

  Widget _buildTaskCard(BuildContext context, Task task, AppDataProvider provider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          _showTaskDetailDialog(context, task, provider);
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // 狀態圖示
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: task.getStatusColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      task.getStatusIcon(),
                      color: task.getStatusColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // 任務標題
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  
                  // 狀態標籤
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: task.getStatusColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      task.getStatusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // 底部資訊
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    _formatTime(task.dueTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(width: 16),
                  if (task.sopLink != null) ...[
                    Icon(Icons.description_outlined, size: 14, color: Colors.blue[700]),
                    const SizedBox(width: 4),
                    Text(
                      '關聯 SOP',
                      style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);
    
    if (difference.isNegative) {
      final hours = difference.inHours.abs();
      return '逾期 $hours 小時';
    } else {
      final hours = difference.inHours;
      if (hours == 0) {
        return '即將到期';
      }
      return '還有 $hours 小時';
    }
  }

  void _showTaskDetailDialog(BuildContext context, Task task, AppDataProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(task.getStatusIcon(), color: task.getStatusColor()),
            const SizedBox(width: 8),
            Expanded(child: Text(task.title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '任務描述',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(task.description),
              
              const SizedBox(height: 16),
              
              if (task.sopLink != null) ...[
                const Divider(),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.description, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '關聯標準作業流程',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '點擊查看完整 SOP 文件',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.blue[700], size: 16),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 16),
              const Divider(),
              
              Text(
                '更新任務狀態',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildStatusChip(
                    '未回報',
                    TaskStatus.notReported,
                    task.status == TaskStatus.notReported,
                    () => provider.updateTaskStatus(task.id, TaskStatus.notReported),
                  ),
                  _buildStatusChip(
                    '已回報',
                    TaskStatus.reported,
                    task.status == TaskStatus.reported,
                    () => provider.updateTaskStatus(task.id, TaskStatus.reported),
                  ),
                  _buildStatusChip(
                    '需支援',
                    TaskStatus.needSupport,
                    task.status == TaskStatus.needSupport,
                    () {
                      provider.updateTaskStatus(task.id, TaskStatus.needSupport);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('🔔 已通知店長與管理層'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                  ),
                  _buildStatusChip(
                    '已完成',
                    TaskStatus.completed,
                    task.status == TaskStatus.completed,
                    () => provider.updateTaskStatus(task.id, TaskStatus.completed),
                  ),
                ],
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

  Widget _buildStatusChip(String label, TaskStatus status, bool isSelected, VoidCallback onTap) {
    Color color;
    switch (status) {
      case TaskStatus.notReported:
        color = Colors.orange;
      case TaskStatus.reported:
        color = Colors.blue;
      case TaskStatus.needSupport:
        color = Colors.red;
      case TaskStatus.completed:
        color = Colors.green;
    }
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      backgroundColor: Colors.grey[200],
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.grey[700],
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
