import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/department_data.dart';
import '../providers/app_data_provider.dart';

class HeadquartersDepartmentPage extends StatefulWidget {
  const HeadquartersDepartmentPage({super.key});

  @override
  State<HeadquartersDepartmentPage> createState() => _HeadquartersDepartmentPageState();
}

class _HeadquartersDepartmentPageState extends State<HeadquartersDepartmentPage> {
  Department? _selectedDepartment;
  
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
              '總部部門監控',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '各部門績效與門市數據關聯',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              _showDepartmentFilter();
            },
          ),
        ],
      ),
      body: Consumer<AppDataProvider>(
        builder: (context, provider, child) {
          final data = provider.headquartersData;
          
          // 過濾部門
          var departments = data.overallDepartmentPerformance;
          if (_selectedDepartment != null) {
            departments = departments.where((d) => d.department == _selectedDepartment).toList();
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // 總部總覽
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildOverviewItem(
                              '總員工數',
                              '${data.totalStaff}',
                              Icons.people,
                              Colors.white,
                            ),
                            _buildOverviewItem(
                              '活躍任務',
                              '${data.totalActiveTasks}',
                              Icons.assignment,
                              Colors.white,
                            ),
                            _buildOverviewItem(
                              '部門數',
                              '${data.overallDepartmentPerformance.length}',
                              Icons.business_center,
                              Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 部門績效總覽圖表
                  _buildSectionCard(
                    '各部門任務完成率',
                    Icons.bar_chart,
                    _buildDepartmentCompletionChart(departments),
                  ),
                  
                  // 部門詳細列表
                  _buildSectionCard(
                    '部門績效詳情',
                    Icons.assessment,
                    _buildDepartmentList(departments, data),
                  ),
                  
                  // 部門問題追蹤
                  if (data.departmentIssues.isNotEmpty)
                    _buildSectionCard(
                      '部門問題追蹤',
                      Icons.warning_amber,
                      _buildDepartmentIssues(data.departmentIssues),
                    ),
                  
                  // 門市部門數據關聯
                  _buildSectionCard(
                    '各門市部門表現',
                    Icons.store,
                    _buildStoreDepartmentData(data.storesDepartmentData),
                  ),
                  
                  const SizedBox(height: 80),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF1976D2), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepartmentCompletionChart(List<DepartmentPerformance> departments) {
    return SizedBox(
      height: 280,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${departments[groupIndex].departmentName}\n${rod.toY.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < departments.length) {
                    final dept = departments[value.toInt()];
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        children: [
                          Icon(
                            dept.getDepartmentIcon(),
                            size: 16,
                            color: dept.getDepartmentColor(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dept.departmentName,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 50,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%', style: const TextStyle(fontSize: 10));
                },
              ),
            ),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 20,
          ),
          borderData: FlBorderData(show: false),
          barGroups: departments.asMap().entries.map((entry) {
            final index = entry.key;
            final dept = entry.value;
            final rate = dept.completionRate * 100;
            
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: rate,
                  color: dept.isPerformanceLow() ? Colors.red : dept.getDepartmentColor(),
                  width: 24,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDepartmentList(List<DepartmentPerformance> departments, HeadquartersDashboardData data) {
    return Column(
      children: departments.map((dept) {
        final isLowPerformance = dept.isPerformanceLow();
        final hasIssues = data.departmentIssues.containsKey(dept.department);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isLowPerformance ? Colors.red[50] : Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isLowPerformance ? Colors.red[200]! : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: dept.getDepartmentColor().withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      dept.getDepartmentIcon(),
                      color: dept.getDepartmentColor(),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dept.departmentName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${dept.activeStaff} 位員工',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isLowPerformance ? Colors.red : Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${(dept.completionRate * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildMetricBox(
                      '總任務',
                      '${dept.totalTasks}',
                      Icons.assignment_outlined,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '已完成',
                      '${dept.completedTasks}',
                      Icons.check_circle_outline,
                      Colors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '待處理',
                      '${dept.pendingTasks}',
                      Icons.pending_actions,
                      Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMetricBox(
                      '問題數',
                      '${dept.issueCount}',
                      Icons.error_outline,
                      Colors.red,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 6),
                  Text(
                    '平均回應時間: ${dept.averageResponseTime.toStringAsFixed(1)} 小時',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              
              if (isLowPerformance) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning, color: Colors.red[900], size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '⚠️ 績效警示:完成率低於 80%,需要關注改善',
                          style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              if (hasIssues) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.flag, color: Colors.orange[700], size: 16),
                          const SizedBox(width: 6),
                          Text(
                            '追蹤問題:',
                            style: TextStyle(
                              color: Colors.orange[900],
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ...data.departmentIssues[dept.department]!.map((issue) => Padding(
                            padding: const EdgeInsets.only(left: 22, top: 4),
                            child: Row(
                              children: [
                                Icon(Icons.circle, size: 6, color: Colors.orange[700]),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    issue,
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetricBox(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentIssues(Map<Department, List<String>> issues) {
    return Column(
      children: issues.entries.map((entry) {
        final dept = entry.key;
        final issueList = entry.value;
        
        // 獲取部門信息
        DepartmentPerformance deptInfo = DepartmentPerformance(
          department: dept,
          departmentName: _getDepartmentName(dept),
          totalTasks: 0,
          completedTasks: 0,
          pendingTasks: 0,
          completionRate: 0,
          activeStaff: 0,
          issueCount: issueList.length,
          averageResponseTime: 0,
        );
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.orange[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange[200]!, width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    deptInfo.getDepartmentIcon(),
                    color: deptInfo.getDepartmentColor(),
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    deptInfo.departmentName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${issueList.length} 個問題',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...issueList.asMap().entries.map((e) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '${e.key + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            e.value,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStoreDepartmentData(List<StoreDepartmentData> storesData) {
    return Column(
      children: storesData.map((storeData) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: ExpansionTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.store, color: Colors.blue[700]),
            ),
            title: Text(
              storeData.storeName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              '${storeData.departmentData.length} 個部門',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: storeData.departmentData.entries.map((entry) {
                    final dept = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: dept.getDepartmentColor().withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: dept.getDepartmentColor().withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            dept.getDepartmentIcon(),
                            color: dept.getDepartmentColor(),
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dept.departmentName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      '完成 ${dept.completedTasks}/${dept.totalTasks}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${dept.activeStaff} 人',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: dept.isPerformanceLow()
                                  ? Colors.red
                                  : dept.getDepartmentColor(),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '${(dept.completionRate * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getDepartmentName(Department dept) {
    switch (dept) {
      case Department.kitchen:
        return '廚房部';
      case Department.service:
        return '服務部';
      case Department.operations:
        return '營運部';
      case Department.hr:
        return '人資部';
      case Department.finance:
        return '財務部';
      case Department.procurement:
        return '採購部';
      case Department.maintenance:
        return '維修部';
    }
  }

  void _showDepartmentFilter() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '篩選部門',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip('全部', null),
                _buildFilterChip('廚房部', Department.kitchen),
                _buildFilterChip('服務部', Department.service),
                _buildFilterChip('營運部', Department.operations),
                _buildFilterChip('人資部', Department.hr),
                _buildFilterChip('財務部', Department.finance),
                _buildFilterChip('採購部', Department.procurement),
                _buildFilterChip('維修部', Department.maintenance),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, Department? dept) {
    final isSelected = _selectedDepartment == dept;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDepartment = selected ? dept : null;
        });
        Navigator.pop(context);
      },
      backgroundColor: Colors.grey[200],
      selectedColor: const Color(0xFF1976D2).withValues(alpha: 0.2),
      checkmarkColor: const Color(0xFF1976D2),
    );
  }
}
