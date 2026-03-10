import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_data_provider.dart';
import 'pages/employee_tasks_page.dart';
import 'pages/manager_exception_page.dart';
import 'pages/executive_dashboard_page.dart';
import 'pages/knowledge_wall_page.dart';
import 'pages/headquarters_department_page.dart';
import 'pages/chat_list_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppDataProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Dine Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const MainNavigationPage(),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const RoleSelectionPage(),
    const EmployeeTasksPage(),
    const ManagerExceptionPage(),
    const ExecutiveDashboardPage(),
    const HeadquartersDepartmentPage(),
    const ChatListPage(),
    const KnowledgeWallPage(),
  ];

  void updateIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF1976D2).withValues(alpha: 0.2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首頁',
          ),
          const NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: '員工端',
          ),
          const NavigationDestination(
            icon: Icon(Icons.manage_accounts_outlined),
            selectedIcon: Icon(Icons.manage_accounts),
            label: '店長端',
          ),
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: '老闆端',
          ),
          const NavigationDestination(
            icon: Icon(Icons.business_center_outlined),
            selectedIcon: Icon(Icons.business_center),
            label: '總部',
          ),
          NavigationDestination(
            icon: Stack(
              children: [
                const Icon(Icons.chat_outlined),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _UnreadBadge(),
                ),
              ],
            ),
            selectedIcon: Stack(
              children: [
                const Icon(Icons.chat),
                Positioned(
                  right: 0,
                  top: 0,
                  child: _UnreadBadge(),
                ),
              ],
            ),
            label: '溝通',
          ),
          const NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: '人資端',
          ),
        ],
      ),
    );
  }
}

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      
                      // Logo 和標題
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.restaurant_menu,
                            size: 48,
                            color: Color(0xFF1976D2),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      const Center(
                        child: Column(
                          children: [
                            Text(
                              'Smart Dine Manager',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '連鎖餐飲組織升級管理系統',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      
                      const Text(
                        '選擇您的角色',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 角色卡片
                      _buildRoleCard(
                        context,
                        '員工端',
                        '今日任務回報',
                        '快速查看並回報今日工作任務,提升執行效率',
                        Icons.assignment,
                        Colors.blue,
                        1,
                      ),
                      
                      _buildRoleCard(
                        context,
                        '店長端',
                        '異常處理與主動回饋',
                        '即時處理現場異常,指派責任人與向上呈報',
                        Icons.manage_accounts,
                        Colors.orange,
                        2,
                      ),
                      
                      _buildRoleCard(
                        context,
                        '老闆/高層端',
                        '營運監控儀表板',
                        '掌握各門市績效,數據可視化管理決策',
                        Icons.dashboard,
                        Colors.purple,
                        3,
                      ),
                      
                      _buildRoleCard(
                        context,
                        '總部部門監控',
                        '各部門績效與門市關聯',
                        '監控各部門表現,從門市數據看部門效能',
                        Icons.business_center,
                        Colors.indigo,
                        4,
                      ),
                      
                      _buildRoleCard(
                        context,
                        '主管回饋溝通',
                        '即時交辦與主動回饋',
                        '主管主動回饋,任務交辦,跨角色即時溝通',
                        Icons.chat,
                        Colors.teal,
                        5,
                      ),
                      
                      _buildRoleCard(
                        context,
                        '人資/訓練端',
                        '知識傳承公告牆',
                        '新人自主學習,取代傳統口頭教導',
                        Icons.school,
                        Colors.green,
                        6,
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // 系統特色
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '系統特色',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildFeatureItem(Icons.sync, '跨角色即時連動'),
                            _buildFeatureItem(Icons.bar_chart, '數據可視化管理'),
                            _buildFeatureItem(Icons.notification_important, '智能通知提醒'),
                            _buildFeatureItem(Icons.touch_app, '直觀易用介面'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(
    BuildContext context,
    String role,
    String title,
    String description,
    IconData icon,
    Color color,
    int pageIndex,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 直接更新父組件的索引
            final navState = context.findAncestorStateOfType<_MainNavigationPageState>();
            if (navState != null) {
              navState.updateIndex(pageIndex);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: color, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// 未讀徽章組件
class _UnreadBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppDataProvider>(
      builder: (context, provider, child) {
        final count = provider.totalUnreadMessages;
        if (count == 0) return const SizedBox.shrink();
        
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          constraints: const BoxConstraints(
            minWidth: 12,
            minHeight: 12,
          ),
          child: Text(
            count > 9 ? '9+' : '$count',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
